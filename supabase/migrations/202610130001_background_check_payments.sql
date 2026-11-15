-- Paid background-check workflow and private police-clearance storage.

alter table public.users
  add column if not exists background_check_payment_status text not null default 'unpaid',
  add column if not exists stripe_checkout_session_id text,
  add column if not exists background_check_paid_at timestamptz;

alter table public.background_checks
  add column if not exists police_clearance_path text,
  add column if not exists police_clearance_filename text,
  add column if not exists submitted_at timestamptz,
  add column if not exists notification_sent_at timestamptz;

create index if not exists users_background_check_payment_status_idx
  on public.users (background_check_payment_status);
create index if not exists background_checks_user_id_idx
  on public.background_checks (user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'background-check-documents',
  'background-check-documents',
  false,
  10485760,
  array['application/pdf', 'image/jpeg', 'image/png']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

alter table public.background_checks enable row level security;

grant select, insert, update on public.background_checks to authenticated;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'background_checks'
      and policyname = 'users_read_own_background_check'
  ) then
    create policy users_read_own_background_check
      on public.background_checks for select to authenticated
      using (user_id = auth.uid());
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'background_checks'
      and policyname = 'users_create_own_background_check'
  ) then
    create policy users_create_own_background_check
      on public.background_checks for insert to authenticated
      with check (user_id = auth.uid());
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public' and tablename = 'background_checks'
      and policyname = 'users_update_own_background_check'
  ) then
    create policy users_update_own_background_check
      on public.background_checks for update to authenticated
      using (user_id = auth.uid())
      with check (user_id = auth.uid());
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'users_upload_own_background_documents'
  ) then
    create policy users_upload_own_background_documents
      on storage.objects for insert to authenticated
      with check (
        bucket_id = 'background-check-documents'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'users_read_own_background_documents'
  ) then
    create policy users_read_own_background_documents
      on storage.objects for select to authenticated
      using (
        bucket_id = 'background-check-documents'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and policyname = 'users_replace_own_background_documents'
  ) then
    create policy users_replace_own_background_documents
      on storage.objects for update to authenticated
      using (
        bucket_id = 'background-check-documents'
        and (storage.foldername(name))[1] = auth.uid()::text
      )
      with check (
        bucket_id = 'background-check-documents'
        and (storage.foldername(name))[1] = auth.uid()::text
      );
  end if;
end
$$;

-- Only an administrator or a server-side service-role request may award or
-- remove the Blue Checkmark. Regular clients cannot promote themselves.
create or replace function public.guard_user_verification_fields()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  actor_is_admin boolean := false;
begin
  if auth.role() = 'service_role' then
    return new;
  end if;

  select coalesce(is_admin, false)
    into actor_is_admin
    from public.users
   where user_id = auth.uid()
   limit 1;

  if actor_is_admin then
    return new;
  end if;

  new.is_verified := old.is_verified;
  new.verification_status := old.verification_status;
  new.background_check_payment_status := old.background_check_payment_status;
  new.stripe_checkout_session_id := old.stripe_checkout_session_id;
  new.background_check_paid_at := old.background_check_paid_at;
  return new;
end
$$;

drop trigger if exists protect_user_verification_fields on public.users;
create trigger protect_user_verification_fields
before update on public.users
for each row execute function public.guard_user_verification_fields();

revoke all on function public.guard_user_verification_fields() from public, anon, authenticated;
