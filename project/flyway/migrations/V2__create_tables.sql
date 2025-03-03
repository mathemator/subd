CREATE SCHEMA IF NOT EXISTS business;
SET search_path TO business;

CREATE DOMAIN email_domain AS TEXT
CHECK (VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

CREATE DOMAIN phone_domain AS TEXT
CHECK (VALUE ~ '^\+?\d{10,15}$');

CREATE TYPE loyalty_status AS ENUM ('BRONZE', 'SILVER', 'GOLD');

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    contact_info TEXT
);

CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    category_id INT NOT NULL REFERENCES category(id),
    supplier_id INT NOT NULL REFERENCES supplier(id),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    characteristics JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE shop (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT NOT NULL
);

CREATE TABLE inventory (
    shop_id INT NOT NULL REFERENCES shop(id),
    product_id INT NOT NULL REFERENCES product(id),
    quantity INT NOT NULL CHECK (quantity >= 0),
    PRIMARY KEY (shop_id, product_id)
);

CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    phone phone_domain UNIQUE NOT NULL,
    email email_domain UNIQUE NOT NULL,
    name TEXT NOT NULL,
    loyalty_status loyalty_status NOT NULL DEFAULT 'BRONZE',
    bonus_points NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (bonus_points >= 0)
);

CREATE TABLE purchase (
    id BIGSERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customer(id),
    shop_id INT NOT NULL REFERENCES shop(id),
    purchase_date TIMESTAMP DEFAULT NOW(),
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0)
);

CREATE TABLE purchase_item (
    purchase_id BIGINT NOT NULL REFERENCES purchase(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES product(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (purchase_id, product_id)
);
