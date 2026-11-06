\set ON_ERROR_STOP on
begin;
set local search_path = public, app_private, pg_catalog;

create function pg_temp.assert_true(condition boolean, message text) returns void
language plpgsql as $$ begin
  if condition is distinct from true then raise exception 'TEST FAILED: %', message; end if;
end $$;

do $$ begin
  execute format('grant usage on schema %I to anon, authenticated', pg_my_temp_schema()::regnamespace);
end $$;
create function pg_temp.expect_error(statement text, expected_code text) returns void
language plpgsql as $$ begin
  begin
    execute statement;
  exception when others then
    if sqlstate = expected_code then return; end if;
    raise exception 'TEST FAILED: expected SQLSTATE %, got %', expected_code, sqlstate;
  end;
  raise exception 'TEST FAILED: expected SQLSTATE %, operation succeeded', expected_code;
end $$;

select pg_temp.assert_true((select count(*) = 17 from public.products), '17 seeded references after two runs');
select pg_temp.assert_true((select count(*) = 6 from public.categories), '6 categories');
select pg_temp.assert_true((select bool_and(validation_status = 'provisional' and not is_visible and not is_available and image_path is null) from public.products), 'demo products unpublished without photos');
select pg_temp.assert_true((select price_minor = 600 from public.products where sku = 'COF-01'), '6 MAD = 600 centimes');
select pg_temp.assert_true((select not ordering_enabled and lead_time_min is null from app_private.business_settings), 'ordering closed without fabricated configuration');
select pg_temp.assert_true((select count(*) = 0 from public.product_modifier_groups), 'no unapproved eligibility');
select pg_temp.assert_true((select count(*) = 0 from app_private.opening_hours), 'no invented hours');
select pg_temp.assert_true((select bool_and(relrowsecurity) from pg_class c join pg_namespace n on n.oid=c.relnamespace
  where c.relkind='r' and (n.nspname='app_private' or (n.nspname='public' and c.relname in ('categories','products','modifiers','modifier_groups','product_modifier_groups')))), 'RLS on every application table');
select pg_temp.assert_true((select bool_and(not has_table_privilege('anon',c.oid,'select')) from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='app_private' and c.relkind='r'), 'no anonymous private table grant');
select pg_temp.assert_true((select bool_and(not has_table_privilege('authenticated',c.oid,'insert,update,delete')) from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='app_private' and c.relkind='r'), 'no direct authenticated private mutation grants');
select pg_temp.assert_true(not has_function_privilege('anon','app_private.current_staff_role()','execute'), 'role helper not executable by anon');

select pg_temp.expect_error($q$update public.products set price_minor = -1 where sku = 'COF-01'$q$, '23514');
select pg_temp.expect_error($q$update public.products set is_visible = true where sku = 'COF-01'$q$, '23514');
select pg_temp.expect_error($q$insert into public.products(sku,category_id,name_fr,price_minor) values ('TEST',gen_random_uuid(),'Test',600)$q$, '23503');
select pg_temp.expect_error($q$insert into public.products(sku,category_id,name_fr,price_minor) select sku,category_id,name_fr,price_minor from public.products where sku='COF-01'$q$, '23505');
select pg_temp.expect_error($q$update app_private.business_settings set ordering_enabled=true$q$, '23514');
select pg_temp.expect_error($q$insert into app_private.business_settings(singleton) values(false)$q$, '23514');
select pg_temp.expect_error($q$insert into app_private.opening_hours(weekday,is_closed,open_local,close_local) values(7,false,'08:00','10:00')$q$, '23514');
select pg_temp.expect_error($q$insert into app_private.opening_hours(weekday,is_closed,open_local,close_local) values(1,false,'20:00','08:00')$q$, '23514');
select pg_temp.expect_error($q$insert into public.modifiers(code,group_id,name_fr,price_delta_minor) values('TEST',gen_random_uuid(),'Test',100)$q$, '23503');
select pg_temp.expect_error($q$insert into public.modifier_groups(code,name_fr,min_select,max_select) values('TEST','Test',2,1)$q$, '23514');

insert into app_private.orders(id,public_number,tracking_token_hash,idempotency_key,payload_hash,customer_name,customer_phone,pickup_at_utc,subtotal_minor,total_minor)
values ('10000000-0000-0000-0000-000000000001','TEST-1',repeat('a',64),'20000000-0000-0000-0000-000000000001',repeat('b',64),'Client fictif','TEST-NOT-A-PHONE',now(),600,600),
('10000000-0000-0000-0000-000000000002','TEST-2',repeat('c',64),'20000000-0000-0000-0000-000000000002',repeat('d',64),'Autre client fictif','TEST-NOT-A-PHONE',now(),600,600);
insert into app_private.order_items(order_id,product_id,sku_snapshot,name_snapshot,unit_price_minor,quantity,line_total_minor)
select '10000000-0000-0000-0000-000000000001',id,sku,name_fr,600,1,600 from public.products where sku='COF-01';
insert into app_private.order_status_events(order_id,to_status) values('10000000-0000-0000-0000-000000000001','pending');
insert into app_private.audit_events(entity_type,entity_id,action) values('test','10000000-0000-0000-0000-000000000001','test');

select pg_temp.expect_error($q$insert into app_private.orders(public_number,tracking_token_hash,idempotency_key,payload_hash,customer_name,customer_phone,pickup_at_utc,subtotal_minor,total_minor)
values('TEST-3',repeat('e',64),'20000000-0000-0000-0000-000000000001',repeat('f',64),'Fictif','TEST',now(),600,600)$q$, '23505');
select pg_temp.expect_error($q$insert into app_private.order_items(order_id,sku_snapshot,name_snapshot,unit_price_minor,quantity,line_total_minor) values(gen_random_uuid(),'TEST','Test',600,1,600)$q$, '23503');
select pg_temp.expect_error($q$insert into app_private.order_items(order_id,sku_snapshot,name_snapshot,unit_price_minor,quantity,line_total_minor) values('10000000-0000-0000-0000-000000000001','TEST','Test',600,0,0)$q$, '23514');
select pg_temp.expect_error($q$insert into app_private.order_item_modifiers(order_item_id,name_snapshot,delta_minor,quantity) values(gen_random_uuid(),'Test',100,1)$q$, '23503');
select pg_temp.expect_error($q$delete from public.products where sku='COF-01'$q$, '23503');
select pg_temp.expect_error($q$update app_private.order_items set unit_price_minor=700$q$, '23514');
select pg_temp.expect_error($q$delete from app_private.order_status_events$q$, '23514');
select pg_temp.expect_error($q$delete from app_private.audit_events$q$, '23514');
update public.products set price_minor=800 where sku='COF-01';
select pg_temp.assert_true((select unit_price_minor=600 from app_private.order_items limit 1), 'catalog changes preserve historical prices');

-- RLS indépendant des GRANTs : privilèges temporairement ajoutés uniquement dans cette transaction.
grant usage on schema app_private to anon;
grant select, insert, update, delete on all tables in schema app_private to anon;
set local role anon;
select pg_temp.assert_true((select count(*)=0 from app_private.orders), 'anon cannot enumerate either customer order even with SELECT grant');
select pg_temp.assert_true((select count(*)=0 from app_private.order_items), 'anon cannot read private lines');
select pg_temp.assert_true((select count(*)=0 from public.products), 'anon cannot read provisional catalogue');
select pg_temp.expect_error($q$insert into app_private.orders(public_number,tracking_token_hash,idempotency_key,payload_hash,customer_name,customer_phone,pickup_at_utc,subtotal_minor,total_minor) values('ATTACK',repeat('e',64),gen_random_uuid(),repeat('f',64),'Fictif','TEST',now(),0,0)$q$, '42501');
update app_private.orders set customer_name='ATTACK';
delete from app_private.orders;
reset role;
select pg_temp.assert_true((select count(*)=2 and bool_and(customer_name <> 'ATTACK') from app_private.orders), 'anon update/delete affect no customer orders');
revoke all on schema app_private from anon;
revoke all on all tables in schema app_private from anon;
set local role anon;
select pg_temp.expect_error('select * from app_private.orders', '42501');
select pg_temp.expect_error('select * from app_private.staff_members', '42501');
select pg_temp.expect_error('insert into public.categories(slug,name_fr) values (''attack'',''Attack'')', '42501');
reset role;
set local role service_role;
select pg_temp.expect_error('insert into public.categories(slug,name_fr) values (''attack'',''Attack'')', '42501');
reset role;

-- Authenticated n'est pas synonyme de personnel ; aucun JWT de rôle fourni par le client.
set local role authenticated;
select set_config('request.jwt.claim.sub','30000000-0000-0000-0000-000000000001',true);
select pg_temp.assert_true((select count(*)=0 from app_private.orders), 'nonstaff sees neither customer order');
select pg_temp.assert_true((select count(*)=0 from app_private.staff_members), 'nonstaff cannot enumerate personnel');
select pg_temp.expect_error('update app_private.business_settings set ordering_enabled=true', '42501');
reset role;

insert into auth.users(id) values ('30000000-0000-0000-0000-000000000001');
insert into app_private.staff_members(auth_user_id,role,active) values ('30000000-0000-0000-0000-000000000001','staff',true);
set local role authenticated;
select pg_temp.assert_true((select count(*)=2 from app_private.orders), 'active staff can read operational orders');
select pg_temp.assert_true((select count(*)=0 from app_private.business_settings), 'staff cannot read admin settings');
select pg_temp.expect_error('update app_private.staff_members set role=''admin''', '42501');
reset role;
update app_private.staff_members set active=false;
set local role authenticated;
select pg_temp.assert_true((select count(*)=0 from app_private.orders), 'inactive staff loses order access');
reset role;
update app_private.staff_members set active=true, role='admin';
set local role authenticated;
select pg_temp.assert_true((select count(*)=1 from app_private.business_settings), 'active admin can read configuration');
select pg_temp.expect_error('update app_private.business_settings set ordering_enabled=true', '42501');
reset role;

update public.categories set is_visible=true where slug='coffee';
update public.products set validation_status='confirmed', is_visible=true where sku='COF-01';
set local role anon;
select pg_temp.assert_true((select count(*)=1 from public.products), 'only explicitly published confirmed product visible');
select pg_temp.assert_true((select count(*)=0 from public.modifiers), 'unapproved supplements remain absent');
reset role;

rollback;
\echo 'PASS: database assertions (constraints, relationships, RLS, history, roles).'
