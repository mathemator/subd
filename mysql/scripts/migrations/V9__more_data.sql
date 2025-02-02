-- Новые категории
INSERT INTO category (id, name) VALUES (5, 'Clothing');
INSERT INTO category (id, name) VALUES (6, 'Toys');

-- Новые продукты
INSERT INTO product (id, name, price, manufacturer_id, supplier_id, `attributes`)
VALUES (8, 'Smartphone', 699.99, 2, 1, '{"screen": "6.5 inch", "battery": "5000mAh"}');

INSERT INTO product (id, name, price, manufacturer_id, supplier_id, `attributes`)
VALUES (9, 'Bicycle', 299.99, 3, 2, '{"frame": "aluminum", "gears": "21-speed"}');

INSERT INTO product (id, name, price, manufacturer_id, supplier_id, `attributes`)
VALUES (10, 'Children\'s Toy', 14.99, 1, 3, '{"age_group": "3-6 years", "material": "plastic"}');

INSERT INTO product_category (product_id, category_id) VALUES (5, 5);
INSERT INTO product_category (product_id, category_id) VALUES (6, 5);
INSERT INTO product_category (product_id, category_id) VALUES (7, 5);
INSERT INTO product_category (product_id, category_id) VALUES (8, 1);
INSERT INTO product_category (product_id, category_id) VALUES (9, 3);
INSERT INTO product_category (product_id, category_id) VALUES (10, 6);

INSERT INTO purchase (id, customer_id, purchase_date, product_id, quantity, metadata)
VALUES (5, 2, '2025-02-01 12:00:00', 8, 1, '{"warranty": "2 years", "discount": "5%"}');

INSERT INTO purchase (id, customer_id, purchase_date, product_id, quantity, metadata)
VALUES (6, 3, '2025-02-02 15:45:00', 9, 1, '{"assembly_required": "true"}');

INSERT INTO purchase (id, customer_id, purchase_date, product_id, quantity, metadata)
VALUES (7, 3, '2025-02-05 18:30:00', 10, 3, '{"gift_wrapping": "yes", "discount": "15%"}');

INSERT INTO purchase (id, customer_id, purchase_date, product_id, quantity, metadata)
VALUES (8, 1, '2025-02-06 20:00:00', 1, 1, '{"delivery_date": "2025-02-10", "discount": "7%"}');