create index customer_product_idx on purchase_data.purchase (customer_id, product_id);

COMMENT ON INDEX customer_product_idx IS 'Составной индекс на покупателя и товар (в случае, допустим, обращения покупателя на возврат или т.п.';
explain analyze
select * from purchase_data.purchase
where customer_id = 2 and product_id = 2;

--Index Scan using customer_product_idx on purchase  (cost=0.15..8.17 rows=1 width=24) (actual time=0.011..0.012 rows=2 loops=1)
--  Index Cond: ((customer_id = 2) AND (product_id = 2))
--Planning Time: 0.259 ms
--Execution Time: 0.022 ms