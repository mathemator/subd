INSERT INTO manufacturer (name)
VALUES
    ('Cool Manufacturer'),
    ('Tech Giant'),
    ('Quality Goods Inc.');

   INSERT INTO category (name)
VALUES
    ('Electronics'),
    ('Household'),
    ('Sports'),
    ('Books');


INSERT INTO supplier (name)
VALUES
    ('Best Supplies Ltd.'),
    ('Global Trade Co.'),
    ('Wholesale Partners');

INSERT INTO customer (name, email)
VALUES
    ('Alice Johnson', 'alice.johnson@example.com'),
    ('Bob Smith', 'bob.smith@example.com'),
    ('Charlie Brown', 'charlie.brown@example.com');

INSERT INTO product (name, price, manufacturer_id, supplier_id)
VALUES
    ('Wireless Mouse', 25.99, 2, 3),
    ('Electric Kettle', 45.00, 1, 1),
    ('Soccer Ball', 20.00, 3, 2),
    ('Novel: Adventure Tales', 15.00, NULL, 3);

INSERT INTO product_category (product_id, category_id)
VALUES
    (1, 1),  -- Wireless Mouse -> Electronics
    (2, 2),  -- Electric Kettle -> Household
    (3, 3),  -- Soccer Ball -> Sports
    (4, 4);  -- Novel -> Books

INSERT INTO purchase (customer_id, product_id, quantity, purchase_date)
VALUES
    (1, 1, 2, '2024-11-25 10:00:00'),  -- Alice купила 2 Wireless Mouse
    (2, 2, 1, '2024-11-26 14:30:00'),  -- Bob купил 1 Electric Kettle
    (3, 4, 3, '2024-11-27 09:15:00');  -- Charlie купил 3 книги
commit;

ALTER TABLE purchase DROP FOREIGN KEY fk_purchase_customer;
ALTER TABLE purchase MODIFY COLUMN id BIGINT AUTO_INCREMENT NOT NULL;
ALTER TABLE customer MODIFY COLUMN id BIGINT AUTO_INCREMENT NOT NULL;
ALTER TABLE purchase MODIFY COLUMN customer_id BIGINT  NOT NULL;
ALTER TABLE purchase ADD CONSTRAINT fk_purchase_customer FOREIGN KEY (customer_id) REFERENCES customer(id);
ALTER TABLE product MODIFY COLUMN price DECIMAL(12, 2) NOT NULL;

ALTER TABLE product ADD COLUMN attributes JSON DEFAULT NULL;
ALTER TABLE purchase ADD COLUMN metadata JSON DEFAULT NULL;

INSERT INTO product (name, price, manufacturer_id, supplier_id , attributes)
VALUES ('T-shirt', 19.99, 1, 1, '{"color": "red", "size": "M", "material": "cotton"}');

INSERT INTO purchase (customer_id, product_id, quantity, metadata)
VALUES (1, 5, 2, '{"discount": "10%", "delivery_date": "2025-01-20"}');
commit;