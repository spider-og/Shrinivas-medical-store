-- Shrinivas Medical Store: add discount pricing and product photo uploads.
-- Run this ONCE in Supabase SQL Editor for the existing Mumbai project.
-- Does not delete or replace existing products.

alter table public.products
  add column if not exists original_price numeric(10,2) check (original_price is null or original_price >= 0),
  add column if not exists discounted_price numeric(10,2) check (discounted_price is null or discounted_price >= 0);

-- Existing products continue to display their current price until edited.
update public.products
set discounted_price = price
where discounted_price is null;

-- Create a public image bucket for product photos.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif','image/avif'])
on conflict (id) do update
set public = true, file_size_limit = 5242880,
    allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif','image/avif'];

-- Public can view product images; only store admins can upload, change, or delete them.
drop policy if exists "Public can view product images" on storage.objects;
create policy "Public can view product images" on storage.objects
for select to public
using (bucket_id = 'product-images');

drop policy if exists "Store admins upload product images" on storage.objects;
create policy "Store admins upload product images" on storage.objects
for insert to authenticated
with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "Store admins update product images" on storage.objects;
create policy "Store admins update product images" on storage.objects
for update to authenticated
using (bucket_id = 'product-images' and public.is_store_admin())
with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "Store admins delete product images" on storage.objects;
create policy "Store admins delete product images" on storage.objects
for delete to authenticated
using (bucket_id = 'product-images' and public.is_store_admin());
