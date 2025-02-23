SET search_path TO business;
-- Создание категорий товаров
INSERT INTO category (name) VALUES
('Собачья еда'), ('Поводок'), ('Намордник'), ('Миска для собак'),
('Кошачья еда'), ('Лоток'), ('Наполнитель'), ('Миска для кошек'),
('Фильтр для аквариума'), ('Аквариум'), ('Корм для рыб'), ('Аэратор');

-- Создание товаров
INSERT INTO product (name, category_id, price) VALUES
('Корм для собак A', 1, 500), ('Корм для собак B', 1, 700), ('Корм для собак C', 1, 600),
('Поводок малый', 2, 300), ('Поводок средний', 2, 400), ('Поводок большой', 2, 500),
('Намордник маленький', 3, 350), ('Намордник средний', 3, 450), ('Намордник большой', 3, 550),
('Миска металлическая', 4, 200), ('Миска керамическая', 4, 300), ('Миска пластиковая', 4, 150),
('Корм для кошек A', 5, 400), ('Корм для кошек B', 5, 500), ('Корм для кошек C', 5, 450),
('Лоток малый', 6, 350), ('Лоток средний', 6, 450), ('Лоток большой', 6, 600),
('Наполнитель силикагель', 7, 500), ('Наполнитель древесный', 7, 300), ('Наполнитель комкующийся', 7, 400),
('Миска керамическая', 8, 300), ('Миска пластиковая', 8, 150), ('Миска металлическая', 8, 200),
('Фильтр маленький', 9, 1000), ('Фильтр средний', 9, 1500), ('Фильтр большой', 9, 2000),
('Аквариум 20 л', 10, 2500), ('Аквариум 50 л', 10, 4000), ('Аквариум 100 л', 10, 7000),
('Корм для рыб A', 11, 200), ('Корм для рыб B', 11, 300), ('Корм для рыб C', 11, 250),
('Аэратор слабый', 12, 800), ('Аэратор средний', 12, 1200), ('Аэратор мощный', 12, 1800);

-- Создание магазинов
INSERT INTO shop (name, location) VALUES
('Зоомаг 1', 'ул. Пёсиковая, д. 10'), ('Зоомаг 2', 'ул. Красивых Попугаев, д. 38'), ('Зоомаг 3', 'ул. Крокодила Гены, д. 3');

-- Заполнение таблицы инвентаризации (все товары есть во всех магазинах)
INSERT INTO inventory (shop_id, product_id, quantity)
SELECT s.id, p.id, 100 + floor(random() * 100)
FROM shop s CROSS JOIN product p;

-- Создание поставщиков
INSERT INTO supplier (name) VALUES
('ЗооСнаб'), ('ПитомецМаркет'), ('АкваТрейд'), ('КотопесОпт');

-- Создание покупателей
INSERT INTO customer (id, name, email, phone, loyalty_status, bonus_points)
SELECT
    id,
    CASE
        WHEN id BETWEEN 1 AND 100 THEN
            (ARRAY['Алексей', 'Иван', 'Пётр', 'Дмитрий', 'Сергей', 'Артём', 'Егор', 'Михаил', 'Олег', 'Владимир'])[id % 10 + 1]
            || ' ' || (ARRAY['Мурлыкин', 'Когтев', 'Пушистиков', 'Лапкин', 'Котельников', 'Усатов', 'Барсиков', 'Мяукинов', 'Кискин', 'Хвостов'])[id % 10 + 1]
        WHEN id BETWEEN 101 AND 200 THEN
            (ARRAY['Анна', 'Мария', 'Екатерина', 'Ольга', 'Татьяна', 'Алина', 'Ксения', 'Елена', 'Наталья', 'Юлия'])[(id - 100) % 10 + 1]
            || ' ' || (ARRAY['Кошкина', 'Лапкина', 'Пушистая', 'Мурлова', 'Усатова', 'Кислова', 'Барсикова', 'Мяукина', 'Хвостова', 'Котейкина'])[(id - 100) % 10 + 1]
        ELSE
            (ARRAY['Рыбинович', 'Царапидзе', 'Котейко', 'Гавгавян', 'Когтюк'])[(id - 200) % 5 + 1]
    END,
    'customer' || id || '@mail.com',
    '+7900000' || LPAD(id::TEXT, 4, '0'),
    (ARRAY['BRONZE'::loyalty_status, 'SILVER'::loyalty_status, 'GOLD'::loyalty_status])[FLOOR(RANDOM() * 3 + 1)],
    FLOOR(RANDOM() * 1000)
FROM generate_series(1, 300) AS id;

-- Создание покупок (пример для 3000 записей)
DO $$
DECLARE i INT := 0;
BEGIN
    WHILE i < 3000 LOOP
        INSERT INTO purchase (customer_id, shop_id, purchase_date, total_amount)
        VALUES (
            (SELECT id FROM customer ORDER BY random() LIMIT 1),
            (SELECT id FROM shop ORDER BY random() LIMIT 1),
            NOW() - (random() * interval '365 days'),
            0 -- будет рассчитана позже
        ) RETURNING id INTO i;

        INSERT INTO purchase_item (purchase_id, product_id, quantity)
        SELECT i, p.id, (1 + (FLOOR(random() * 1000))::INTEGER % 3)
        FROM product p ORDER BY random() LIMIT (1 + floor(random() * 3));

        i := i + 1;
    END LOOP;
END $$;

UPDATE purchase p
SET total_amount = sub.total_amount_with_discount
FROM (
    SELECT
        p.id AS purchase_id,
        SUM(pi.quantity * pr.price) *
            CASE
                WHEN c.loyalty_status = 'BRONZE' THEN 0.97
                WHEN c.loyalty_status = 'SILVER' THEN 0.95
                WHEN c.loyalty_status = 'GOLD' THEN 0.93
            END AS total_amount_with_discount
    FROM
        purchase_item pi
        JOIN product pr ON pi.product_id = pr.id
        JOIN purchase p ON pi.purchase_id = p.id
        JOIN customer c ON p.customer_id = c.id
    GROUP BY
        p.id, c.loyalty_status
) AS sub
WHERE p.id = sub.purchase_id;