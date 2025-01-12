create index purchase_date_idx on purchase_data.purchase (purchase_date) tablespace shop_ts;

comment on index purchase_date_idx is 'Индекс на дату покупки, для аналитики и метрик';
--генерируем массив данных, чтобы спровоцировать базу на использование индекса
insert into purchase_data.purchase (customer_id, purchase_date, product_id, quantity)
select 1, '2025-01-01 00:00:00' - (random() * interval '30 days'), 1, 1
from generate_series(1, 1000);

explain select * from purchase_data.purchase p
where purchase_date >= '2024-12-30 00:00:00' and purchase_date <= '2025-01-01 00:00:00';

--Bitmap Heap Scan on purchase p  (cost=4.91..12.84 rows=62 width=24)
--  Recheck Cond: ((purchase_date >= '2024-12-30 00:00:00'::timestamp without time zone) AND (purchase_date <= '2025-01-01 00:00:00'::timestamp without time zone))
--  ->  Bitmap Index Scan on purchase_date_idx  (cost=0.00..4.90 rows=62 width=0)
--        Index Cond: ((purchase_date >= '2024-12-30 00:00:00'::timestamp without time zone) AND (purchase_date <= '2025-01-01 00:00:00'::timestamp without time zone))