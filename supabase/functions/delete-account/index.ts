// @ts-nocheck
import { createClient } from 'npm:@supabase/supabase-js@^2'

declare const Deno: {
  env: {
    get(key: string): string | undefined
  }
  serve(handler: (request: Request) => Response | Promise<Response>): void
}

export const corsHeaders: Record<string, string> = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, apikey, content-type, x-client-info',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

function jsonResponse(data: unknown, init: ResponseInit = {}): Response {
  return new Response(JSON.stringify(data), {
    ...init,
    headers: {
      ...corsHeaders,
      'Content-Type': 'application/json',
      ...(init.headers ?? {}),
    },
  })
}

function storageObjectFromUrl(value: unknown) {
  if (typeof value !== 'string' || !value.trim()) return null
  const match = value.match(
    /\/storage\/v1\/object\/(?:public|sign|authenticated)\/([^/]+)\/(.+?)(?:\?.*)?$/,
  )
  if (!match) return null
  return {
    bucket: decodeURIComponent(match[1]),
    path: decodeURIComponent(match[2]),
  }
}

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  if (request.method !== 'POST') {
    return jsonResponse({ error: 'Method not allowed' }, { status: 405 })
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

  if (!supabaseUrl || !serviceRoleKey) {
    return jsonResponse(
      { error: 'Server configuration error: missing Supabase credentials' },
      { status: 500 },
    )
  }

  const authorization = request.headers.get('Authorization') ?? ''
  const token = authorization.replace(/^Bearer\s+/i, '').trim()

  if (!token) {
    return jsonResponse({ error: 'Authentication required' }, { status: 401 })
  }

  const userClient = createClient(supabaseUrl, anonKey || serviceRoleKey, {
    global: { headers: { Authorization: `Bearer ${token}` } },
  })
  const admin = createClient(supabaseUrl, serviceRoleKey)

  // Verify the authenticated user
  let user: { id: string } | null = null
  try {
    const { data: authData, error: authError } = await userClient.auth.getUser(
      token,
    )
    if (!authError && authData?.user) {
      user = authData.user
    }
  } catch (_) {}

  if (!user) {
    try {
      const { data: authData, error: authError } = await admin.auth.getUser(
        token,
      )
      if (!authError && authData?.user) {
        user = authData.user
      }
    } catch (_) {}
  }

  if (!user) {
    return jsonResponse({ error: 'Authentication required' }, { status: 401 })
  }

  // 1. Try atomic PostgreSQL RPC 'delete_own_account' first if defined
  try {
    const { error: rpcError } = await userClient.rpc('delete_own_account')
    if (!rpcError) {
      return jsonResponse({ deleted: true })
    }
  } catch (_) {
    // Proceed to fallback manual cleanup
  }

  // 2. Gather and delete storage objects owned by this user
  const storedObjects = new Map<string, Set<string>>()
  const rememberObject = (value: unknown) => {
    const object = storageObjectFromUrl(value)
    if (!object) return
    const paths = storedObjects.get(object.bucket) ?? new Set<string>()
    paths.add(object.path)
    storedObjects.set(object.bucket, paths)
  }

  try {
    const { data: account } = await admin
      .from('users')
      .select('id,profilepicture,photo_url')
      .eq('user_id', user.id)
      .maybeSingle()
    rememberObject(account?.profilepicture)
    rememberObject(account?.photo_url)

    const profileId = account?.id
    if (profileId) {
      try {
        const { data: userPosts } = await admin
          .from('forums_posts')
          .select('id')
          .eq('user_id', profileId)
        const postIds = (userPosts ?? []).map((p: any) => p.id)
        if (postIds.length > 0) {
          await admin.from('forums_comments').delete().in('post_id', postIds)
        }
      } catch (_) {}

      try {
        await admin.from('forums_comments').delete().eq('user_id', profileId)
      } catch (_) {}
      try {
        await admin.from('forums_posts').delete().eq('user_id', profileId)
      } catch (_) {}
      try {
        await admin.from('a_chats_message').delete().eq('user_id', profileId)
      } catch (_) {}
      try {
        await admin.from('a_chats_users').delete().eq('users_id', profileId)
      } catch (_) {}
      try {
        await admin.from('messages').delete().eq('user_id', profileId)
      } catch (_) {}
      try {
        await admin.from('messages').delete().eq('reciepient_id', profileId)
      } catch (_) {}
    }
  } catch (_) {}

  try {
    const { data: userProfile } = await admin
      .from('user_profiles')
      .select('profile_picture')
      .eq('user_id', user.id)
      .maybeSingle()
    rememberObject(userProfile?.profile_picture)
  } catch (_) {}

  try {
    const { data: profilePictures } = await admin
      .from('profile_picture')
      .select('profile_picture')
      .eq('user_id', user.id)
    for (const picture of profilePictures ?? []) {
      rememberObject(picture.profile_picture)
    }
  } catch (_) {}

  try {
    const { data: backgroundCheck } = await admin
      .from('background_checks')
      .select('id_document_url,selfie_url,police_clearance_path')
      .eq('user_id', user.id)
      .maybeSingle()
    rememberObject(backgroundCheck?.id_document_url)
    rememberObject(backgroundCheck?.selfie_url)
    if (backgroundCheck?.police_clearance_path) {
      const paths =
        storedObjects.get('background-check-documents') ?? new Set<string>()
      paths.add(backgroundCheck.police_clearance_path)
      storedObjects.set('background-check-documents', paths)
    }
  } catch (_) {}

  // Check background-check-documents bucket folder for user
  try {
    const { data: documents } = await admin.storage
      .from('background-check-documents')
      .list(user.id, { limit: 1000 })
    const backgroundDocumentPaths =
      storedObjects.get('background-check-documents') ?? new Set<string>()
    for (const document of documents ?? []) {
      if (document.name) {
        backgroundDocumentPaths.add(`${user.id}/${document.name}`)
      }
    }
    if (backgroundDocumentPaths.size > 0) {
      storedObjects.set('background-check-documents', backgroundDocumentPaths)
    }
  } catch (_) {}

  // Delete collected storage objects
  for (const [bucket, paths] of storedObjects) {
    if (paths.size === 0) continue
    try {
      await admin.storage.from(bucket).remove(Array.from(paths))
    } catch (e) {
      console.warn('Storage cleanup non-fatal warning:', e)
    }
  }

  // 3. Delete database records referencing user UUID
  const tablesWithUserId = [
    'messages',
    'chat_participants',
    'chat_settings',
    'connections',
    'posts',
    'support_tickets',
    'quiz_answers',
    'verifications',
    'background_checks',
    'profile_picture',
    'user_profiles',
    'users',
  ]

  for (const table of tablesWithUserId) {
    try {
      if (table === 'messages') {
        await admin.from('messages').delete().eq('sender_id', user.id)
      } else if (table === 'chat_participants') {
        await admin.from('chat_participants').delete().eq('user_id', user.id)
        await admin
          .from('chat_participants')
          .delete()
          .eq('chat_user_id', user.id)
      } else if (table === 'connections') {
        await admin.from('connections').delete().eq('sender_id', user.id)
        await admin.from('connections').delete().eq('receiver_id', user.id)
      } else {
        await admin.from(table).delete().eq('user_id', user.id)
      }
    } catch (_) {}
  }

  // 4. Delete the user from Supabase Auth
  const { error: deleteError } = await admin.auth.admin.deleteUser(user.id)
  if (deleteError) {
    console.error('Could not delete auth user', deleteError)
    return jsonResponse(
      { error: deleteError.message || 'Account could not be deleted' },
      { status: 500 },
    )
  }

  return jsonResponse({ deleted: true })
})

export default Deno.serve

export default Deno.serve

