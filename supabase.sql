-- Budgetarian database setup. Paste all of this into Supabase > SQL Editor > New query, then tap Run.

-- 1. One row per user holds that user's whole budget.
create table if not exists public.budgets (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- 2. Row Level Security: each person can only see and change their own budget.
alter table public.budgets enable row level security;

drop policy if exists "own budget: read"   on public.budgets;
drop policy if exists "own budget: insert" on public.budgets;
drop policy if exists "own budget: update" on public.budgets;
drop policy if exists "own budget: delete" on public.budgets;

create policy "own budget: read"   on public.budgets for select using (auth.uid() = user_id);
create policy "own budget: insert" on public.budgets for insert with check (auth.uid() = user_id);
create policy "own budget: update" on public.budgets for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own budget: delete" on public.budgets for delete using (auth.uid() = user_id);

-- 3. Premium: who has it. Users can READ their own row but cannot change it.
--    You grant Premium in Table Editor > entitlements (premium = true, optional expires_at).
--    Later, Google Play purchases will update this table automatically.
create table if not exists public.entitlements (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  premium    boolean not null default false,
  expires_at timestamptz,
  note       text,
  updated_at timestamptz not null default now()
);
alter table public.entitlements enable row level security;
drop policy if exists "own entitlement: read" on public.entitlements;
create policy "own entitlement: read" on public.entitlements for select using (auth.uid() = user_id);

-- Only Premium accounts may save budgets online.
create or replace function public.is_premium(uid uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.entitlements e
                 where e.user_id = uid and e.premium and (e.expires_at is null or e.expires_at > now()));
$$;
drop policy if exists "own budget: insert" on public.budgets;
drop policy if exists "own budget: update" on public.budgets;
create policy "own budget: insert" on public.budgets for insert with check (auth.uid() = user_id and public.is_premium(auth.uid()));
create policy "own budget: update" on public.budgets for update using (auth.uid() = user_id) with check (auth.uid() = user_id and public.is_premium(auth.uid()));

-- 4. Lets a signed-in user delete their own account and data (required by Google Play).
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  delete from public.budgets where user_id = auth.uid();
  delete from public.entitlements where user_id = auth.uid();
  delete from auth.users where id = auth.uid();
end;
$$;

revoke all on function public.delete_my_account() from public;
grant execute on function public.delete_my_account() to authenticated;
