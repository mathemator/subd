-- Добавляем колонку для текстового описания
alter table product_data.product
add column product_description TEXT;

-- Добавляем колонку для хранения тс-вектора для полнотекстового поиска
alter table product_data.product
add column description_tsvector tsvector;

-- Добавим описание для продуктов
update product_data.product
set product_description = 'A wireless mouse, great for work and gaming'
where id = 1;

update product_data.product
set product_description = 'A kettle to heat water quickly, perfect for tea'
where id = 2;

update product_data.product
set product_description = 'A soccer ball for sports enthusiasts'
where id = 3;

update product_data.product
set product_description = 'A novel full of exciting adventures and tales'
where id = 4;

update product_data.product
set description_tsvector = to_tsvector('english', product_description);

-- Создаём функцию, которая будет автоматически обновлять description_tsvector
create or replace function update_product_description_tsvector()
RETURNS trigger AS $$
begin
  NEW.description_tsvector := to_tsvector('english', NEW.product_description);
  return new;
end;
$$ LANGUAGE plpgsql;

-- Создаём триггер, который будет вызываться при вставке или обновлении
create trigger update_product_description_tsvector_trigger
before insert or update on product_data.product
for each row EXECUTE function update_product_description_tsvector();

INSERT INTO product_data.product (name, price, manufacturer_id, supplier_id, product_description)
SELECT
    'Product ' || i,
    10 + random() * 100,
    (i % 5) + 1,
    (i % 5) + 1,
    CASE
        WHEN i % 4 = 0 THEN 'Wireless mouse, great for gaming and work'
        WHEN i % 4 = 1 THEN 'Electric kettle for quick boiling'
        WHEN i % 4 = 2 THEN 'Football for playing sports'
        ELSE 'A fantastic adventure novel'
    END
FROM generate_series(5, 10000) AS i;

CREATE INDEX product_data.product_description_idx
ON product_data.product USING gin (description_tsvector);

comment on index product_data.product_description_idx is 'Полнотекстовый индекс на поиск товара по описанию';

EXPLAIN ANALYZE
SELECT *
FROM product_data.product
WHERE description_tsvector @@ to_tsquery('english', 'wireless & mouse');

--Bitmap Heap Scan on product  (cost=20.34..221.15 rows=625 width=120) (actual time=0.299..0.970 rows=2500 loops=1)
--  Recheck Cond: (description_tsvector @@ '''wireless'' & ''mous'''::tsquery)
--  Heap Blocks: exact=193
--  ->  Bitmap Index Scan on product_description_tsvector_idx  (cost=0.00..20.18 rows=625 width=0) (actual time=0.274..0.274 rows=2500 loops=1)
--        Index Cond: (description_tsvector @@ '''wireless'' & ''mous'''::tsquery)
--Planning Time: 1.947 ms
--Execution Time: 1.095 ms