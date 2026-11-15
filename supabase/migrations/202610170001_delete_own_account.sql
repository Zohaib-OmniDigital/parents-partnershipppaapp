-- Migration: 202610170001_delete_own_account.sql
-- Enables self-service account deletion for authenticated users directly in PostgreSQL.
-- Paste this script into your Supabase Dashboard SQL Editor (or apply via Supabase CLI).

create or replace function public.delete_own_account()
returns void
language plpgsql
security definer
set search_path = public, auth, storage
as $$
declare
  v_user_uuid uuid := auth.uid();
  v_profile_id bigint;
  r record;
begin
  if v_user_uuid is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  -- 1. Identify the profile ID in public.users (bigint)
  begin
    select id into v_profile_id
    from public.users
    where user_id::text = v_user_uuid::text
    limit 1;
  exception when others then
    v_profile_id := null;
  end;

  -- 2. Delete child records referencing users.id (bigint)
  if v_profile_id is not null then
    begin
      delete from public.forums_comments where post_id in (select id from public.forums_posts where user_id = v_profile_id);
    exception when others then null;
    end;

    begin
      delete from public.forums_comments where user_id = v_profile_id;
    exception when others then null;
    end;

    begin
      delete from public.forums_posts where user_id = v_profile_id;
    exception when others then null;
    end;

    begin
      delete from public.a_chats_message where user_id = v_profile_id;
    exception when others then null;
    end;

    begin
      delete from public.a_chats_users where users_id = v_profile_id;
    exception when others then null;
    end;

    begin
      delete from public.messages where reciepient_id = v_profile_id;
    exception when others then null;
    end;
  end if;

  -- 3. Delete from tables referencing auth UUID
  begin
    delete from public.messages where sender_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.chat_participants where user_id::text = v_user_uuid::text or chat_user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.chat_settings where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.connections where sender_id::text = v_user_uuid::text or receiver_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.posts where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.support_tickets where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.quiz_answers where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.verifications where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.background_checks where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.profile_picture where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.user_profiles where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public."user" where id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.user_id where user_id::text = v_user_uuid::text;
  exception when others then null;
  end;

  begin
    delete from public.users where user_id::text = v_user_uuid::text or (v_profile_id is not null and id = v_profile_id);
  exception when others then null;
  end;

  -- 4. Dynamic cleanup for any other public tables with foreign keys to auth.users
  for r in (
    select tc.table_schema, tc.table_name, kcu.column_name
    from information_schema.table_constraints tc
    join information_schema.key_column_usage kcu
      on tc.constraint_name = kcu.constraint_name
      and tc.table_schema = kcu.table_schema
    join information_schema.constraint_column_usage ccu
      on ccu.constraint_name = tc.constraint_name
      and ccu.table_schema = tc.table_schema
    where tc.constraint_type = 'FOREIGN KEY'
      and ccu.table_schema = 'auth'
      and ccu.table_name = 'users'
      and tc.table_schema in ('public', 'storage')
  ) loop
    begin
      execute format('delete from %I.%I where %I::text = %L', r.table_schema, r.table_name, r.column_name, v_user_uuid::text);
    exception when others then null;
    end;
  end loop;

  -- 5. Delete storage objects uploaded by this user
  begin
    delete from storage.objects
    where owner = v_user_uuid
       or owner_id = v_user_uuid::text
       or (storage.foldername(name))[1] = v_user_uuid::text
       or name like v_user_uuid::text || '/%';
  exception when others then null;
  end;

  -- 6. Clean up auth sessions & identities
  begin
    delete from auth.refresh_tokens where session_id in (select id from auth.sessions where user_id = v_user_uuid);
  exception when others then null;
  end;

  begin
    delete from auth.sessions where user_id = v_user_uuid;
  exception when others then null;
  end;

  begin
    delete from auth.identities where user_id = v_user_uuid;
  exception when others then null;
  end;

  begin
    delete from auth.mfa_factors where user_id = v_user_uuid;
  exception when others then null;
  end;

  -- 7. Permanently delete from auth.users
  delete from auth.users where id = v_user_uuid;
end;
$$;

revoke all on function public.delete_own_account() from public, anon;
grant execute on function public.delete_own_account() to authenticated;
