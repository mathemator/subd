CREATE UNIQUE INDEX idx_unique_product
ON product (name, manufacturer_id, supplier_id);