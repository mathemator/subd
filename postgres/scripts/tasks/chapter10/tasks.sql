--1. Запрос с конструкциями SELECT, JOIN
SELECT
    c.name AS customer_name,
    p.name AS product_name,
    p.price AS product_price,
    pu.quantity AS product_quantity,
    pu.purchase_date
FROM
    purchase_data.purchase pu
JOIN
    customer_data.customer c ON pu.customer_id = c.id
JOIN
    product_data.product p ON pu.product_id = p.id;

--2. Запрос с добавлением данных INSERT INTO
INSERT INTO product_data.product (name, price, manufacturer_id, supplier_id)
VALUES ('Fancy Keyboard', 49.99, 1, 2);
commit;

--3. Запрос с обновлением данных UPDATE FROM
UPDATE
    product_data.product p
SET
    price = p.price * 1.1
FROM
    product_data.manufacturer m
WHERE
    p.manufacturer_id = m.id AND m.name = 'Cool Manufacturer';
commit;

--4. Использование USING для удаления
DELETE FROM
    product_data.product p
USING
    product_data.product_category pc
WHERE
    p.id = pc.product_id
    AND pc.category_id = 1;
commit;

--5. Пример использования утилиты COPY
COPY product_data.product (name, price, manufacturer_id, supplier_id)
FROM '/docker-entrypoint-initdb.d/tasks/chapter10/attitional_products.csv'
DELIMITER ','
CSV HEADER;
commit;