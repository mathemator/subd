-- Наполнение базы данными в рамках домашнего задания! 😺

INSERT INTO customer_data.customer (name, email)
VALUES
    ('Alice Johnson', 'alice.johnson@example.com'),
    ('Bob Smith', 'bob.smith@example.com'),
    ('Charlie Brown', 'charlie.brown@example.com');

INSERT INTO product_data.category (name)
VALUES
    ('Electronics'),
    ('Household'),
    ('Sports'),
    ('Books');

INSERT INTO product_data.manufacturer (name)
VALUES
    ('Cool Manufacturer'),
    ('Tech Giant'),
    ('Quality Goods Inc.');

INSERT INTO product_data.supplier (name)
VALUES
    ('Best Supplies Ltd.'),
    ('Global Trade Co.'),
    ('Wholesale Partners');

INSERT INTO product_data.product (name, price, manufacturer_id, supplier_id)
VALUES
    ('Wireless Mouse', 25.99, 2, 3),
    ('Electric Kettle', 45.00, 1, 1),
    ('Soccer Ball', 20.00, 3, 2),
    ('Novel: Adventure Tales', 15.00, NULL, 3);

INSERT INTO product_data.productcategory (product_id, category_id)
VALUES
    (1, 1),  -- Wireless Mouse -> Electronics
    (2, 2),  -- Electric Kettle -> Household
    (3, 3),  -- Soccer Ball -> Sports
    (4, 4);  -- Novel -> Books

INSERT INTO purchase_data.purchase (customer_id, product_id, quantity, purchase_date)
VALUES
    (1, 1, 2, '2024-11-25 10:00:00'),  -- Alice купила 2 Wireless Mouse
    (2, 2, 1, '2024-11-26 14:30:00'),  -- Bob купил 1 Electric Kettle
    (3, 4, 3, '2024-11-27 09:15:00');  -- Charlie купил 3 книги

commit;