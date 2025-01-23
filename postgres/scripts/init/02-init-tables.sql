-- Создание таблицеспейса для данных
--CREATE TABLESPACE shop_ts LOCATION '/mnt/shop_ts';

-- Создание схем с указанием таблицеспейса
CREATE SCHEMA IF NOT EXISTS customer_data;
CREATE SCHEMA IF NOT EXISTS product_data;
CREATE SCHEMA IF NOT EXISTS purchase_data;

-- Создание таблицы "customer" в схеме "customer_data"
CREATE TABLE customer_data.customer (
    id serial4 NOT NULL,
    "name" varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (id)
)
TABLESPACE shop_ts;

-- Создание таблицы "category" в схеме "product_data"
CREATE TABLE product_data.category (
    id serial4 NOT NULL,
    "name" varchar(255) NOT NULL,
    CONSTRAINT category_name_unique UNIQUE (name),
    CONSTRAINT category_pkey PRIMARY KEY (id)
)
TABLESPACE shop_ts;
CREATE INDEX idx_category_name ON product_data.category USING btree (name) TABLESPACE shop_ts;

-- Создание таблицы "manufacturer" в схеме "product_data"
CREATE TABLE product_data.manufacturer (
    id serial4 NOT NULL,
    "name" varchar(255) NOT NULL,
    CONSTRAINT manufacturer_name_unique UNIQUE (name),
    CONSTRAINT manufacturer_pkey PRIMARY KEY (id)
)
TABLESPACE shop_ts;
CREATE INDEX idx_manufacturer_name ON product_data.manufacturer USING btree (name) TABLESPACE shop_ts;

-- Создание таблицы "product" в схеме "product_data"
CREATE TABLE product_data.product (
    id serial4 NOT NULL,
    "name" varchar(255) NOT NULL,
    price numeric(10, 2) NOT NULL,
    manufacturer_id int4 NULL,
    supplier_id int4 NULL,
    CONSTRAINT product_pkey PRIMARY KEY (id),
    CONSTRAINT product_price_nonnegative CHECK ((price >= (0)::numeric))
)
TABLESPACE shop_ts;
CREATE INDEX idx_product_manufacturer ON product_data.product USING btree (manufacturer_id) TABLESPACE shop_ts;
CREATE INDEX idx_product_name ON product_data.product USING btree (name) TABLESPACE shop_ts;
CREATE INDEX idx_product_supplier ON product_data.product USING btree (supplier_id) TABLESPACE shop_ts;

-- Создание таблицы "productcategory" в схеме "product_data"
CREATE TABLE product_data.productcategory (
    product_id int4 NOT NULL,
    category_id int4 NOT NULL,
    CONSTRAINT productcategory_pkey PRIMARY KEY (product_id, category_id)
)
TABLESPACE shop_ts;

-- Создание внешних ключей для "productcategory"
ALTER TABLE product_data.productcategory
    ADD CONSTRAINT productcategory_category_id_fkey
    FOREIGN KEY (category_id) REFERENCES product_data.category(id);

ALTER TABLE product_data.productcategory
    ADD CONSTRAINT productcategory_product_id_fkey
    FOREIGN KEY (product_id) REFERENCES product_data.product(id) ON DELETE CASCADE;

-- Создание таблицы "supplier" в схеме "product_data"
CREATE TABLE product_data.supplier (
    id serial4 NOT NULL,
    "name" varchar(255) NOT NULL,
    CONSTRAINT supplier_name_unique UNIQUE (name),
    CONSTRAINT supplier_pkey PRIMARY KEY (id)
)
TABLESPACE shop_ts;
CREATE INDEX idx_supplier_name ON product_data.supplier USING btree (name) TABLESPACE shop_ts;

-- Создание таблицы "purchase" в схеме "purchase_data"
CREATE TABLE purchase_data.purchase (
    id serial4 NOT NULL,
    customer_id int4 NULL,
    purchase_date timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    product_id int4 NULL,  -- Ссылка на продукт
    quantity int4 NOT NULL DEFAULT 1,  -- Количество
    CONSTRAINT purchase_pkey PRIMARY KEY (id),
    CONSTRAINT purchase_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer_data.customer(id) ON DELETE CASCADE,
    CONSTRAINT purchase_product_id_fkey FOREIGN KEY (product_id) REFERENCES product_data.product(id) ON DELETE CASCADE
)
TABLESPACE shop_ts;

CREATE SCHEMA migrations;

ALTER SCHEMA migrations OWNER TO shop_user;