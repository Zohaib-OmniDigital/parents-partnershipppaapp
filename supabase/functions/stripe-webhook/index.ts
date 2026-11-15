// @ts-nocheck
import { createClient } from 'npm:@supabase/supabase-js@^2'

const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET') ?? ''
const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

const supabase = createClient(supabaseUrl, serviceRoleKey)
const encoder = new TextEncoder()

function hexToBytes(hex: string): Uint8Array | null {
  if (!/^[0-9a-f]+$/i.test(hex) || hex.length % 2 !== 0) return null
  return Uint8Array.from(
    hex.match(/.{2}/g) ?? [],
    (byte) => Number.parseInt(byte, 16),
  )
}

async function hasValidStripeSignature(
  body: string,
  signatureHeader: string,
): Promise<boolean> {
  if (!webhookSecret) return false

  const parts = signatureHeader.split(',').map((part) => part.trim())
  const timestampValue = parts
    .find((part) => part.startsWith('t='))
    ?.slice(2)
  const signatures = parts
    .filter((part) => part.startsWith('v1='))
    .map((part) => part.slice(3))

  const timestamp = Number(timestampValue)
  if (!Number.isFinite(timestamp) || signatures.length === 0) return false
  if (Math.abs(Date.now() / 1000 - timestamp) > 300) return false

  const key = await crypto.subtle.importKey(
    'raw',
    encoder.encode(webhookSecret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['verify'],
  )
  const signedPayload = encoder.encode(`${timestamp}.${body}`)

  for (const signature of signatures) {
    const signatureBytes = hexToBytes(signature)
    if (
      signatureBytes &&
      await crypto.subtle.verify('HMAC', key, signatureBytes, signedPayload)
    ) {
      return true
    }
  }
  return false
}

Deno.serve(async (request) => {
  if (request.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  const signature = request.headers.get('stripe-signature') ?? ''
  const body = await request.text()

  if (!await hasValidStripeSignature(body, signature)) {
    console.error('Stripe signature verification failed')
    return new Response('Invalid Stripe signature', { status: 400 })
  }

  let event: {
    type: string
    data: { object: Record<string, unknown> }
  }
  try {
    event = JSON.parse(body)
  } catch (error) {
    console.error('Stripe event JSON was invalid', error)
    return new Response('Invalid Stripe payload', { status: 400 })
  }

  if (
    event.type !== 'checkout.session.completed' &&
    event.type !== 'checkout.session.async_payment_succeeded'
  ) {
    return Response.json({ received: true })
  }

  const session = event.data.object
  const userId = typeof session.client_reference_id === 'string'
    ? session.client_reference_id
    : null
  const paid = session.payment_status === 'paid'
  const correctAmount = session.amount_total === 3999
  const correctCurrency =
    typeof session.currency === 'string' &&
    session.currency.toLowerCase() === 'usd'

  if (!userId || !paid || !correctAmount || !correctCurrency) {
    console.error('Rejected unmatched checkout session', {
      sessionId: session.id,
      userId,
      paymentStatus: session.payment_status,
      amountTotal: session.amount_total,
      currency: session.currency,
    })
    return new Response('Checkout session does not match the background check', {
      status: 400,
    })
  }

  const { error } = await supabase
    .from('users')
    .update({
      background_check_payment_status: 'paid',
      stripe_checkout_session_id: session.id,
      background_check_paid_at: new Date().toISOString(),
    })
    .eq('user_id', userId)

  if (error) {
    console.error('Could not record Stripe payment', error)
    return new Response('Could not record payment', { status: 500 })
  }

  return Response.json({ received: true })
})
