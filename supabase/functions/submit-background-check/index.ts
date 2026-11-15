// @ts-nocheck
import { Buffer } from 'node:buffer'
import nodemailer from 'npm:nodemailer@^6.9.16'
import { createClient } from 'npm:@supabase/supabase-js@^2'

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
const anonKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''
const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
const smtpHost = Deno.env.get('HOSTINGER_SMTP_HOST') ?? 'smtp.hostinger.com'
const smtpPort = Number(Deno.env.get('HOSTINGER_SMTP_PORT') ?? '465')
const smtpUsername = Deno.env.get('HOSTINGER_SMTP_USERNAME') ?? ''
const smtpPassword = Deno.env.get('HOSTINGER_SMTP_PASSWORD') ?? ''
const recipientEmail = Deno.env.get('VERIFICATION_RECIPIENT_EMAIL') ?? ''

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, apikey, content-type, x-client-info',
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  if (request.method !== 'POST') {
    return Response.json(
      { error: 'Method not allowed' },
      { status: 405, headers: corsHeaders },
    )
  }

  const authorization = request.headers.get('Authorization') ?? ''
  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authorization } },
  })
  const admin = createClient(supabaseUrl, serviceRoleKey)

  const { data: authData, error: authError } = await userClient.auth.getUser()
  const user = authData.user
  if (authError || !user) {
    return Response.json(
      { error: 'Authentication required' },
      { status: 401, headers: corsHeaders },
    )
  }

  const { data: profile, error: profileError } = await admin
    .from('users')
    .select('full_name,email,background_check_payment_status')
    .eq('user_id', user.id)
    .single()

  if (profileError || !profile) {
    return Response.json(
      { error: 'Profile not found' },
      { status: 404, headers: corsHeaders },
    )
  }
  if (profile.background_check_payment_status !== 'paid') {
    return Response.json(
      { error: 'The $39.99 payment has not been confirmed yet' },
      { status: 402, headers: corsHeaders },
    )
  }

  const { data: application, error: applicationError } = await admin
    .from('background_checks')
    .select('*')
    .eq('user_id', user.id)
    .single()

  if (applicationError || !application?.police_clearance_path) {
    return Response.json(
      { error: 'Police Clearance Certificate is required' },
      { status: 400, headers: corsHeaders },
    )
  }

  const requiredFields = [
    application.full_legal_name,
    application.date_of_birth,
    application.current_address,
    application.contry,
    application.state,
    application.zip_code,
    application.id_document_url,
    application.selfie_url,
  ]
  if (requiredFields.some((value) => !String(value ?? '').trim())) {
    return Response.json(
      { error: 'Complete every background-check section before submitting' },
      { status: 400, headers: corsHeaders },
    )
  }

  if (!application.notification_sent_at) {
    const { data: document, error: downloadError } = await admin.storage
      .from('background-check-documents')
      .download(application.police_clearance_path)

    if (downloadError || !document) {
      console.error('Document download failed', downloadError)
      return Response.json(
        { error: 'Could not retrieve the uploaded document' },
        { status: 500, headers: corsHeaders },
      )
    }

    const transporter = nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465,
      auth: { user: smtpUsername, pass: smtpPassword },
    })

    try {
      await transporter.sendMail({
        from: `Parents Partnership Verification <${smtpUsername}>`,
        to: recipientEmail,
        subject: `Background Check Submission - ${profile.full_name ?? user.email}`,
        text: [
          'A paid background-check application is ready for review.',
          `Applicant: ${profile.full_name ?? 'Not provided'}`,
          `Account email: ${profile.email ?? user.email ?? 'Not provided'}`,
          `User ID: ${user.id}`,
          '',
          'The Police Clearance Certificate is attached.',
        ].join('\n'),
        attachments: [
          {
            filename: application.police_clearance_filename ?? 'police-clearance.pdf',
            content: Buffer.from(await document.arrayBuffer()),
          },
        ],
      })
    } catch (error) {
      console.error('Hostinger SMTP delivery failed', error)
      return Response.json(
        { error: 'Could not send the document to the verification inbox' },
        { status: 502, headers: corsHeaders },
      )
    }

    const { error: notificationError } = await admin
      .from('background_checks')
      .update({ notification_sent_at: new Date().toISOString() })
      .eq('user_id', user.id)

    if (notificationError) {
      console.error('Could not record email delivery', notificationError)
    }
  }

  const submittedAt = new Date().toISOString()
  const { error: applicationUpdateError } = await admin
    .from('background_checks')
    .update({ submitted_at: submittedAt })
    .eq('user_id', user.id)
  const { error: userUpdateError } = await admin
    .from('users')
    .update({ verification_status: 'pending', is_verified: false })
    .eq('user_id', user.id)

  if (applicationUpdateError || userUpdateError) {
    console.error('Could not queue application', {
      applicationUpdateError,
      userUpdateError,
    })
    return Response.json(
      { error: 'The document was sent, but the review queue could not be updated' },
      { status: 500, headers: corsHeaders },
    )
  }

  return Response.json(
    { submitted: true },
    { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
  )
})
