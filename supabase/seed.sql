-- Demonstration only. No PII, no confirmed prices, no enabled ordering.
do $$
begin
  if current_setting('app.environment', true) is distinct from 'test' then
    raise exception 'Demo seed requires explicit app.environment=test';
  end if;
end;
$$;

insert into public.categories(id, slug, name_fr, sort_order, is_visible)
values
  (md5('rs-coffee:coffee')::uuid, 'coffee', 'Coffee', 1, false),
  (md5('rs-coffee:milk-drinks')::uuid, 'milk-drinks', 'Milk Drinks', 2, false),
  (md5('rs-coffee:cappuccino')::uuid, 'cappuccino', 'Cappuccino', 3, false),
  (md5('rs-coffee:tea')::uuid, 'tea', 'Tea', 4, false),
  (md5('rs-coffee:ice-fresh')::uuid, 'ice-fresh', 'Ice & Fresh', 5, false),
  (md5('rs-coffee:bakery-dessert')::uuid, 'bakery-dessert', 'Bakery & Dessert', 6, false)
on conflict (slug) do nothing;

insert into public.products(id, sku, category_id, name_fr, price_minor, sort_order, validation_status, is_visible, is_available)
select md5('rs-coffee:' || v.sku)::uuid, v.sku, c.id, v.name_fr, v.price_minor, v.sort_order,
  'provisional'::public.catalog_validation, false, false
from (values
  ('COF-01','coffee','Café Spécial',600,1),
  ('COF-02','coffee','Café Moka',800,2),
  ('COF-03','coffee','Café au lait',700,3),
  ('COF-04','coffee','Café aromatisé',700,4),
  ('MIL-01','milk-drinks','Lait chocolat',700,1),
  ('MIL-02','milk-drinks','Lait chaud',600,2),
  ('CAP-01','cappuccino','Cappuccino',800,1),
  ('CAP-02','cappuccino','Cappuccino Royal',1000,2),
  ('TEA-01','tea','Thé normal',600,1),
  ('TEA-02','tea','Thé spécial',800,2),
  ('ICE-01','ice-fresh','Ice coffee',1500,1),
  ('ICE-02','ice-fresh','Ice coffee with water',1300,2),
  ('ICE-03','ice-fresh','Mojito virgin',1300,3),
  ('ICE-04','ice-fresh','Fresh cocktail Mojito',1300,4),
  ('BAK-01','bakery-dessert','Croissant français',600,1),
  ('BAK-02','bakery-dessert','Croissant normal',400,2),
  ('BAK-03','bakery-dessert','Tiramisu café',1300,3)
) as v(sku, category_slug, name_fr, price_minor, sort_order)
join public.categories c on c.slug = v.category_slug
on conflict (sku) do nothing;

-- Unknown eligibility/limits: no modifiers or product links inserted.
-- Existing admin edits, settings and ordering flags are never overwritten by this seed.
