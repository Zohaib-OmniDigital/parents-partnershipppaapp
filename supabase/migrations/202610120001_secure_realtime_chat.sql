-- Secure, realtime chat support for the existing a_chats* tables.
-- Apply with the Supabase CLI or paste into the Dashboard SQL editor.
-- This migration is additive: it does not remove existing data or policies.

create index if not exists a_chats_users_chat_id_idx
  on public.a_chats_users (chat_id);
create index if not exists a_chats_users_users_id_idx
  on public.a_chats_users (users_id);
create index if not exists a_chats_message_chat_created_idx
  on public.a_chats_message (chat_id, created_at, id);

create or replace function public.current_profile_id()
returns bigint
language sql
stable
security definer
set search_path = public
as $$
  select id::bigint
  from public.users
  where user_id = auth.uid()
  limit 1
$$;

create or replace function public.is_chat_member(target_chat_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.a_chats_users membership
    where membership.chat_id = target_chat_id
      and membership.users_id = public.current_profile_id()
  )
$$;

revoke all on function public.current_profile_id() from public, anon;
revoke all on function public.is_chat_member(bigint) from public, anon;
grant execute on function public.current_profile_id() to authenticated;
grant execute on function public.is_chat_member(bigint) to authenticated;

alter table public.a_chats enable row level security;
alter table public.a_chats_users enable row level security;
alter table public.a_chats_message enable row level security;

grant select on public.a_chats, public.a_chats_users,
  public.a_chats_message to authenticated;
grant insert on public.a_chats_message to authenticated;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'a_chats'
      and policyname = 'chat_members_can_read_chats'
  ) then
    create policy chat_members_can_read_chats
      on public.a_chats for select to authenticated
      using (public.is_chat_member(id));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'a_chats_users'
      and policyname = 'chat_members_can_read_memberships'
  ) then
    create policy chat_members_can_read_memberships
      on public.a_chats_users for select to authenticated
      using (public.is_chat_member(chat_id));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'a_chats_message'
      and policyname = 'chat_members_can_read_messages'
  ) then
    create policy chat_members_can_read_messages
      on public.a_chats_message for select to authenticated
      using (public.is_chat_member(chat_id));
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'a_chats_message'
      and policyname = 'chat_members_can_send_messages'
  ) then
    create policy chat_members_can_send_messages
      on public.a_chats_message for insert to authenticated
      with check (
        public.is_chat_member(chat_id)
        and user_id = public.current_profile_id()
        and nullif(btrim(message), '') is not null
        and char_length(message) <= 4000
      );
  end if;
end
$$;

create or replace function public.start_direct_chat(target_profile_id bigint)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_profile_id bigint := public.current_profile_id();
  result_chat_id bigint;
begin
  if auth.uid() is null or actor_profile_id is null then
    raise exception 'An authenticated profile is required'
      using errcode = '42501';
  end if;
  if target_profile_id is null or target_profile_id = actor_profile_id then
    raise exception 'A different target profile is required'
      using errcode = '22023';
  end if;
  if not exists (select 1 from public.users where id = target_profile_id) then
    raise exception 'Target profile does not exist'
      using errcode = '22023';
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended(
      least(actor_profile_id, target_profile_id)::text || ':' ||
      greatest(actor_profile_id, target_profile_id)::text,
      0
    )
  );

  select membership.chat_id
  into result_chat_id
  from public.a_chats_users membership
  group by membership.chat_id
  having count(distinct membership.users_id) = 2
     and count(distinct membership.users_id) filter (
       where membership.users_id in (actor_profile_id, target_profile_id)
     ) = 2
  limit 1;

  if result_chat_id is null then
    insert into public.a_chats (last_message)
    values ('')
    returning id into result_chat_id;

    insert into public.a_chats_users (chat_id, users_id)
    values
      (result_chat_id, actor_profile_id),
      (result_chat_id, target_profile_id);
  end if;

  return result_chat_id;
end
$$;

revoke all on function public.start_direct_chat(bigint) from public, anon;
grant execute on function public.start_direct_chat(bigint) to authenticated;

create or replace function public.add_chat_participant(
  target_chat_id bigint,
  target_profile_id bigint
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null or not public.is_chat_member(target_chat_id) then
    raise exception 'Only chat members can add participants'
      using errcode = '42501';
  end if;
  if target_profile_id is null
     or not exists (select 1 from public.users where id = target_profile_id) then
    raise exception 'Target profile does not exist'
      using errcode = '22023';
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended(target_chat_id::text || ':' || target_profile_id::text, 0)
  );
  if not exists (
    select 1 from public.a_chats_users
    where chat_id = target_chat_id and users_id = target_profile_id
  ) then
    insert into public.a_chats_users (chat_id, users_id)
    values (target_chat_id, target_profile_id);
  end if;
end
$$;

revoke all on function public.add_chat_participant(bigint, bigint)
  from public, anon;
grant execute on function public.add_chat_participant(bigint, bigint)
  to authenticated;

create or replace function public.sync_chat_last_message()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.a_chats
  set last_message = left(new.message, 200)
  where id = new.chat_id;
  return new;
end
$$;

drop trigger if exists sync_chat_last_message_after_insert
  on public.a_chats_message;
create trigger sync_chat_last_message_after_insert
after insert on public.a_chats_message
for each row execute function public.sync_chat_last_message();

create or replace view public.a_chat_summary
with (security_invoker = true)
as
select
  chat.id as chat_id,
  coalesce((
    select message.message
    from public.a_chats_message message
    where message.chat_id = chat.id
    order by message.created_at desc, message.id desc
    limit 1
  ), chat.last_message, '') as last_message,
  array(
    select membership.users_id
    from public.a_chats_users membership
    where membership.chat_id = chat.id
    order by membership.id
  ) as user_ids,
  array(
    select coalesce(nullif(btrim(profile.full_name), ''), 'Community member')
    from public.a_chats_users membership
    join public.users profile on profile.id = membership.users_id
    where membership.chat_id = chat.id
      and membership.users_id <> public.current_profile_id()
    order by membership.id
  ) as full_names,
  array(
    select coalesce(profile.profilepicture, '')
    from public.a_chats_users membership
    join public.users profile on profile.id = membership.users_id
    where membership.chat_id = chat.id
      and membership.users_id <> public.current_profile_id()
    order by membership.id
  ) as profile_pictures,
  coalesce((
    select message.created_at
    from public.a_chats_message message
    where message.chat_id = chat.id
    order by message.created_at desc, message.id desc
    limit 1
  ), chat.created_at) as updated_at
from public.a_chats chat
where public.is_chat_member(chat.id);

create or replace view public.chat_messages_info_view
with (security_invoker = true)
as
select
  message.chat_id,
  message.created_at,
  profile.full_name,
  profile.user_id as user_uuid,
  message.message,
  message.id,
  message.user_id,
  profile.profilepicture as profile_picture
from public.a_chats_message message
join public.users profile on profile.id = message.user_id
where public.is_chat_member(message.chat_id);

grant select on public.a_chat_summary to authenticated;
grant select on public.chat_messages_info_view to authenticated;

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public' and tablename = 'a_chats'
  ) then
    alter publication supabase_realtime add table public.a_chats;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public' and tablename = 'a_chats_users'
  ) then
    alter publication supabase_realtime add table public.a_chats_users;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public' and tablename = 'a_chats_message'
  ) then
    alter publication supabase_realtime add table public.a_chats_message;
  end if;
end
$$;
