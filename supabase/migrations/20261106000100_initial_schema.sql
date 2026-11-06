begin;

create schema app_private;
revoke all on schema app_private from public, anon, authenticated, service_role;
grant usage on schema app_private to authenticated;

create type public.catalog_validation as enum ('provisional', 'confirmed');
create type app_private.staff_role as enum ('admin', 'staff');
create type app_private.order_status as enum ('pending', 'accepted', 'preparing', 'ready', 'completed', 'rejected', 'cancelled');

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name_fr text not null check (length(btrim(name_fr)) between 1 and 120),
  sort_order integer not null default 0,
  is_visible boolean not null default false
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  sku text not null unique,
  category_id uuid not null references public.categories(id) on delete restrict,
  name_fr text not null check (length(btrim(name_fr)) between 1 and 160),
  description_fr text,
  price_minor integer not null check (price_minor >= 0),
  image_path text,
  sort_order integer not null default 0,
  is_visible boolean not null default false,
  is_available boolean not null default false,
  validation_status public.catalog_validation not null default 'provisional',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint published_product_confirmed check (not is_visible or validation_status = 'confirmed')
);
create index products_category_sort_idx on public.products(category_id, sort_order);

create table public.modifier_groups (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name_fr text not null,
  min_select integer not null default 0 check (min_select >= 0),
  max_select integer not null check (max_select >= min_select and max_select > 0),
  is_active boolean not null default false,
  validation_status public.catalog_validation not null default 'provisional',
  check (not is_active or validation_status = 'confirmed')
);
create table public.modifiers (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  group_id uuid not null references public.modifier_groups(id) on delete restrict,
  name_fr text not null,
  price_delta_minor integer not null check (price_delta_minor >= 0),
  is_active boolean not null default false
);
create index modifiers_group_idx on public.modifiers(group_id);
create table public.product_modifier_groups (
  product_id uuid not null references public.products(id) on delete restrict,
  group_id uuid not null references public.modifier_groups(id) on delete restrict,
  primary key (product_id, group_id)
);
create index product_modifier_groups_group_idx on public.product_modifier_groups(group_id);

create table app_private.business_settings (
  singleton boolean primary key default true check (singleton),
  ordering_enabled boolean not null default false,
  lead_time_min integer check (lead_time_min > 0),
  slot_interval_min integer check (slot_interval_min > 0),
  max_orders_per_slot integer check (max_orders_per_slot > 0),
  timezone text not null default 'Africa/Casablanca' check (timezone = 'Africa/Casablanca'),
  updated_at timestamptz not null default now(),
  check (not ordering_enabled or (lead_time_min is not null and slot_interval_min is not null and max_orders_per_slot is not null))
);
insert into app_private.business_settings(singleton) values (true);

create table app_private.opening_hours (
  id uuid primary key default gen_random_uuid(),
  weekday smallint not null unique check (weekday between 0 and 6),
  open_local time,
  close_local time,
  is_closed boolean not null default true,
  check ((is_closed and open_local is null and close_local is null) or
    (not is_closed and open_local is not null and close_local is not null and close_local > open_local))
);
create table app_private.opening_exceptions (
  id uuid primary key default gen_random_uuid(),
  local_date date not null unique,
  open_local time,
  close_local time,
  is_closed boolean not null default true,
  reason text,
  check ((is_closed and open_local is null and close_local is null) or
    (not is_closed and open_local is not null and close_local is not null and close_local > open_local))
);

create table app_private.staff_members (
  auth_user_id uuid primary key references auth.users(id) on delete restrict,
  role app_private.staff_role not null,
  active boolean not null default false,
  created_at timestamptz not null default now()
);
create table app_private.orders (
  id uuid primary key default gen_random_uuid(),
  public_number text not null unique,
  tracking_token_hash text not null unique check (tracking_token_hash ~ '^[0-9a-f]{64}$'),
  idempotency_key uuid not null unique,
  payload_hash text not null check (payload_hash ~ '^[0-9a-f]{64}$'),
  customer_name text not null check (length(btrim(customer_name)) between 1 and 120),
  customer_phone text not null check (length(btrim(customer_phone)) between 1 and 32),
  pickup_at_utc timestamptz not null,
  status app_private.order_status not null default 'pending',
  payment_method text not null default 'pay_at_pickup' check (payment_method = 'pay_at_pickup'),
  payment_status text not null default 'unpaid' check (payment_status in ('unpaid', 'paid')),
  currency text not null default 'MAD' check (currency = 'MAD'),
  subtotal_minor integer not null check (subtotal_minor >= 0),
  total_minor integer not null check (total_minor >= 0),
  note text check (length(note) <= 2000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index orders_status_created_idx on app_private.orders(status, created_at);
create index orders_pickup_idx on app_private.orders(pickup_at_utc);

create table app_private.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references app_private.orders(id) on delete restrict,
  product_id uuid references public.products(id) on delete restrict,
  sku_snapshot text not null,
  name_snapshot text not null,
  unit_price_minor integer not null check (unit_price_minor >= 0),
  quantity integer not null check (quantity > 0),
  line_total_minor integer not null check (line_total_minor >= 0),
  check (line_total_minor::bigint >= unit_price_minor::bigint * quantity::bigint)
);
create index order_items_order_idx on app_private.order_items(order_id);
create index order_items_product_idx on app_private.order_items(product_id);
create table app_private.order_item_modifiers (
  id uuid primary key default gen_random_uuid(),
  order_item_id uuid not null references app_private.order_items(id) on delete restrict,
  modifier_id uuid references public.modifiers(id) on delete restrict,
  name_snapshot text not null,
  delta_minor integer not null check (delta_minor >= 0),
  quantity integer not null check (quantity > 0)
);
create index order_item_modifiers_item_idx on app_private.order_item_modifiers(order_item_id);
create index order_item_modifiers_modifier_idx on app_private.order_item_modifiers(modifier_id);
create table app_private.order_status_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references app_private.orders(id) on delete restrict,
  from_status app_private.order_status,
  to_status app_private.order_status not null,
  actor_id uuid references app_private.staff_members(auth_user_id) on delete restrict,
  reason text,
  occurred_at timestamptz not null default now()
);
create index order_status_events_order_idx on app_private.order_status_events(order_id, occurred_at);
create index order_status_events_actor_idx on app_private.order_status_events(actor_id);
create table app_private.audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references app_private.staff_members(auth_user_id) on delete restrict,
  entity_type text not null,
  entity_id uuid not null,
  action text not null,
  safe_metadata jsonb not null default '{}'::jsonb check (jsonb_typeof(safe_metadata) = 'object'),
  occurred_at timestamptz not null default now()
);
create index audit_events_entity_idx on app_private.audit_events(entity_type, entity_id, occurred_at);
create index audit_events_actor_idx on app_private.audit_events(actor_id);

-- Une fonction privée et sans search_path implicite évite la récursion RLS des rôles.
create function app_private.current_staff_role() returns app_private.staff_role
language sql stable security definer set search_path = '' as $$
  select role from app_private.staff_members where auth_user_id = (select auth.uid()) and active;
$$;
revoke all on function app_private.current_staff_role() from public, anon, authenticated, service_role;
grant execute on function app_private.current_staff_role() to authenticated;

-- L'historique et les snapshots ne peuvent pas être réécrits ou supprimés.
create function app_private.reject_history_change() returns trigger
language plpgsql set search_path = '' as $$
begin
  raise exception 'Historical records are append-only' using errcode = '23514';
end;
$$;
revoke all on function app_private.reject_history_change() from public, anon, authenticated, service_role;
create trigger order_items_immutable before update or delete on app_private.order_items for each row execute function app_private.reject_history_change();
create trigger order_item_modifiers_immutable before update or delete on app_private.order_item_modifiers for each row execute function app_private.reject_history_change();
create trigger order_status_events_immutable before update or delete on app_private.order_status_events for each row execute function app_private.reject_history_change();
create trigger audit_events_immutable before update or delete on app_private.audit_events for each row execute function app_private.reject_history_change();

-- Retirer les privilèges automatiques Supabase, puis ouvrir seulement la lecture nécessaire.
do $$
declare t record;
begin
  for t in select schemaname, tablename from pg_tables
    where (schemaname = 'app_private') or (schemaname = 'public' and tablename in
      ('categories','products','modifier_groups','modifiers','product_modifier_groups'))
  loop
    execute format('alter table %I.%I enable row level security', t.schemaname, t.tablename);
    execute format('revoke all on table %I.%I from public, anon, authenticated, service_role', t.schemaname, t.tablename);
  end loop;
end;
$$;
alter default privileges in schema app_private revoke all on tables from public, anon, authenticated, service_role;
alter default privileges in schema app_private revoke execute on functions from public, anon, authenticated, service_role;
alter default privileges in schema public revoke all on tables from public, anon, authenticated, service_role;
alter default privileges in schema public revoke execute on functions from public, anon, authenticated, service_role;

grant select on public.categories, public.products, public.modifier_groups, public.modifiers, public.product_modifier_groups to anon, authenticated;
create policy categories_public_read on public.categories for select to anon, authenticated using (is_visible);
create policy products_public_read on public.products for select to anon, authenticated using (
  is_visible and validation_status = 'confirmed' and exists (select 1 from public.categories c where c.id = category_id and c.is_visible)
);
create policy modifier_groups_public_read on public.modifier_groups for select to anon, authenticated using (is_active and validation_status = 'confirmed');
create policy modifiers_public_read on public.modifiers for select to anon, authenticated using (
  is_active and exists (select 1 from public.modifier_groups g where g.id = group_id and g.is_active)
);
create policy product_modifier_groups_public_read on public.product_modifier_groups for select to anon, authenticated using (
  exists (select 1 from public.products p where p.id = product_id) and
  exists (select 1 from public.modifier_groups g where g.id = group_id)
);

-- Préparation de lectures personnel, aucune mutation directe, aucune exposition Data API du schéma privé.
grant select on all tables in schema app_private to authenticated;
create policy staff_members_read on app_private.staff_members for select to authenticated using (
  (auth_user_id = (select auth.uid()) and active) or (select app_private.current_staff_role()) = 'admin'
);
do $$
declare tab text;
begin
  foreach tab in array array['orders','order_items','order_item_modifiers','order_status_events'] loop
    execute format('create policy staff_read on app_private.%I for select to authenticated using ((select app_private.current_staff_role()) in (''admin'', ''staff''))', tab);
  end loop;
  foreach tab in array array['business_settings','opening_hours','opening_exceptions','audit_events'] loop
    execute format('create policy admin_read on app_private.%I for select to authenticated using ((select app_private.current_staff_role()) = ''admin'')', tab);
  end loop;
  foreach tab in array array['categories','products','modifier_groups','modifiers','product_modifier_groups'] loop
    execute format('create policy staff_catalog_read on public.%I for select to authenticated using ((select app_private.current_staff_role()) in (''admin'', ''staff''))', tab);
  end loop;
end;
$$;

comment on schema app_private is 'Not exposed by Data API. No browser writes; server handlers and narrowly granted RPCs must be added by their tickets.';
comment on column public.products.validation_status is 'Source menu transcription only until explicit owner approval; provisional entries cannot be published.';
comment on table app_private.orders is 'Storage foundation only: atomic pricing, slot locks, payload validation and status transitions belong to T-010/T-012; no creation RPC granted.';
comment on column app_private.audit_events.safe_metadata is 'Server allowlist required before future writes; never store PII, tokens or checkout payloads here.';
commit;
