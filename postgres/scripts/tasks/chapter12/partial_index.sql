create index product_price_cheap_idx on product_data.product (price)
where price < 20.00;

comment on index product_price_cheap_idx is 'Индекс на часть таблицы - поиск по дешевым продуктам. Демонстрационный :) Допустим, это некий магический порог нашего магазина!'

explain analyze
select *
from product_data.product
where price < 20.00;

--Bitmap Heap Scan on product  (cost=19.60..224.40 rows=944 width=120) (actual time=0.174..0.411 rows=945 loops=1)
--  Recheck Cond: (price < 20.00)
--  Heap Blocks: exact=191
--  ->  Bitmap Index Scan on product_price_cheap_idx  (cost=0.00..19.36 rows=944 width=0) (actual time=0.153..0.154 rows=945 loops=1)
--        Index Cond: (price < 20.00)
--Planning Time: 0.632 ms
--Execution Time: 0.512 ms