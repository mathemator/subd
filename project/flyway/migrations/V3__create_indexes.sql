SET search_path TO business;

CREATE INDEX idx_product_search ON product USING GIN (
    to_tsvector('russian', description || ' ' || characteristics::text)
);

CREATE INDEX idx_product_category ON product(category_id);

CREATE INDEX idx_inventory_product_shop ON inventory(product_id, shop_id);

CREATE INDEX idx_order_customer_date ON "order"(customer_id, order_date);

CREATE INDEX idx_order_brin ON "order" USING BRIN(order_date);

CREATE UNIQUE INDEX idx_customer_phone ON customer(phone) WHERE phone IS NOT NULL;
