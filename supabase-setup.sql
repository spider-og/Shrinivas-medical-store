/*
  REFERENCE SETUP SCRIPT for a NEW, EMPTY Supabase project only.
  Since you have already run your setup in the Mumbai project, DO NOT run this again
  unless you have reviewed it and know the tables/policies are missing.
  Create the admin Auth user in Dashboard > Authentication > Users, then run:
  INSERT INTO public.store_admins (user_id) VALUES ('YOUR_NEW_AUTH_USER_UUID');
*/

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  category text,
  price numeric(10,2) not null default 0 check (price >= 0),
  image_url text,
  stock integer not null default 0 check (stock >= 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.store_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.store_admins enable row level security;

create or replace function public.is_store_admin()
returns boolean
language sql
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.store_admins
    where user_id = (select auth.uid())
  );
$$;

grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;
grant select on public.store_admins to authenticated;

drop policy if exists "Public can view active products" on public.products;
create policy "Public can view active products" on public.products
for select to anon, authenticated
using (is_active = true or public.is_store_admin());

drop policy if exists "Admins can insert products" on public.products;
create policy "Admins can insert products" on public.products
for insert to authenticated
with check (public.is_store_admin());

drop policy if exists "Admins can update products" on public.products;
create policy "Admins can update products" on public.products
for update to authenticated
using (public.is_store_admin())
with check (public.is_store_admin());

drop policy if exists "Admins can delete products" on public.products;
create policy "Admins can delete products" on public.products
for delete to authenticated
using (public.is_store_admin());

drop policy if exists "Admins can view their admin record" on public.store_admins;
create policy "Admins can view their admin record" on public.store_admins
for select to authenticated
using (user_id = (select auth.uid()));
