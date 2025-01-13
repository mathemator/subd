-- Создаём роль и пользователя
CREATE ROLE shop_admin;
CREATE USER admin_sasha WITH PASSWORD 'admin_sasha';
GRANT shop_admin TO admin_sasha;
-- Назначаем права и владельца
ALTER DATABASE shop_db OWNER TO admin_sasha;

-- Создаём схемы
CREATE SCHEMA product_data AUTHORIZATION shop_admin;
CREATE SCHEMA customer_data AUTHORIZATION shop_admin;
CREATE SCHEMA purchase_data AUTHORIZATION shop_admin;

CREATE SCHEMA migrations AUTHORIZATION shop_admin;

ALTER TABLE public.product SET SCHEMA product_data;
ALTER TABLE public.category SET SCHEMA product_data;
ALTER TABLE public.manufacturer SET SCHEMA product_data;
ALTER TABLE public.productcategory SET SCHEMA product_data;
ALTER TABLE public.supplier SET SCHEMA product_data;
ALTER TABLE public.customer SET SCHEMA customer_data;
ALTER TABLE public.purchase SET SCHEMA purchase_data;