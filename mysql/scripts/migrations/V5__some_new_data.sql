-- Добавление товара с атрибутами
INSERT INTO product (name, price, manufacturer_id, supplier_id , attributes)
VALUES ('T-shirt', 19.99, 1, 1, '{"color": "red", "size": "M", "material": "cotton"}');

-- Добавление покупки с метаданными
INSERT INTO purchase (customer_id, product_id, quantity, metadata)
VALUES (1, 5, 2, '{"discount": "10%", "delivery_date": "2025-01-20"}');