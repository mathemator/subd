--Напишите запрос по своей базе с inner join
--Запрос существующих покупок по товарам для аналитики :)
--Можно сгруппировать, но это, похоже, для будущих ДЗ
SELECT
    p.name AS product_name,
    pr.purchase_date,
    pr.quantity
FROM
    product p
INNER JOIN
    purchase pr
ON
    p.id = pr.product_id
WHERE pr.purchase_date BETWEEN '2024-01-01' AND '2025-01-01'
ORDER BY pr.purchase_date;
--product_name	purchase_date	quantity
--Wireless Mouse	2024-11-25 10:00:00	2
--Electric Kettle	2024-11-26 14:30:00	1
--Novel: Adventure Tales	2024-11-27 09:15:00	3

--Напишите запрос по своей базе с left join
--Запрос что покупали уважаемые клиенты, некоторые может ничего не покупали...
SELECT
    c.name AS customer_name,
    pr.product_id,
    pr.purchase_date
FROM
    customer c
LEFT JOIN
    purchase pr
ON
    c.id = pr.customer_id;
--customer_name	product_id	purchase_date
--Alice Johnson	1	2024-11-25 10:00:00
--Alice Johnson	5	2025-01-24 23:14:40
--Bob Smith	2	2024-11-26 14:30:00
--Charlie Brown	4	2024-11-27 09:15:00
--1. Использование оператора равенства (=):
--Получим товары определённого производителя.
SELECT
    name, price
FROM
    product
WHERE
    manufacturer_id = 1;
--name	price
--Electric Kettle	45
--T-shirt	19,99

--2. Использование оператора сравнения (>):
--Получим товары, цена которых выше определённой суммы.
SELECT
    name, price
FROM
    product
WHERE
    price > 20;
--name	price
--Wireless Mouse	25,99
--Electric Kettle	45

--3. Использование оператора IN:
--Получим информацию о покупках конкретных клиентов.
SELECT
    *
FROM
    purchase
WHERE
    customer_id IN (1, 2, 3);
--id	customer_id	purchase_date	product_id	quantity	metadata
--1	1	2024-11-25 10:00:00	1	2
--4	1	2025-01-24 23:14:40	5	2	{"discount": "10%", "delivery_date": "2025-01-20"}
--2	2	2024-11-26 14:30:00	2	1
--3	3	2024-11-27 09:15:00	4	3

--4. Использование оператора LIKE:
--Найдём товары, название которых содержит слово "ball". Ищем мячики :)
SELECT
    name, price
FROM
    product
WHERE
    UPPER(name) LIKE '%BALL%';
--name	price
--Soccer Ball	20

--5. Использование оператора BETWEEN:
--Получим список покупок за определённый временной диапазон.
--В запросе с джойном аналогично, но формально для задания сойдёт :)
SELECT
 *
FROM
    purchase
WHERE
    purchase_date BETWEEN '2024-01-01' AND '2025-01-01';
--id	customer_id	purchase_date	product_id	quantity	metadata
--1	1	2024-11-25 10:00:00	1	2
--2	2	2024-11-26 14:30:00	2	1
--3	3	2024-11-27 09:15:00	4	3