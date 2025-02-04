# Улучшаем запрос
## Анализ исходных данных
Допустим, разработчик составил по заданию бизнеса такой запрос,
подобный которому часто вызывается из приложения, формирующего контекстные
предложения.
```sql 
SELECT 
    p.id AS product_id, 
    p.name AS product_name, 
    m.name AS manufacturer_name, 
    s.name AS supplier_name,
    c.name AS category_name, 
    (SELECT COUNT(*) FROM purchase pc WHERE pc.product_id = p.id) AS total_sales, 
    (SELECT SUM(p.price * pc.quantity) FROM purchase pc WHERE pc.product_id = p.id) AS total_revenue 
FROM product p
JOIN product_category pcg ON p.id = pcg.product_id
JOIN category c ON pcg.category_id = c.id
JOIN manufacturer m ON p.manufacturer_id = m.id
JOIN supplier s ON p.supplier_id = s.id
WHERE p.price > 20
ORDER BY total_revenue DESC
LIMIT 10;
```
**explain:**

|id |select_type       |table|partitions|type  |possible_keys                                        |key                     |key_len|ref                    |rows|filtered|Extra                                                                    |
|---|------------------|-----|----------|------|-----------------------------------------------------|------------------------|-------|-----------------------|----|--------|-------------------------------------------------------------------------|
|1  |PRIMARY           |m    |          |index |PRIMARY                                              |manufacturer_name_unique|1022   |                       |3   |100.0   |Using index; Using temporary; Using filesort                             |
|1  |PRIMARY           |p    |          |range |PRIMARY,idx_product_manufacturer,idx_product_supplier|idx_product_supplier    |5      |                       |9   |9.09    |Using index condition; Using where; Using join buffer (Block Nested Loop)|
|1  |PRIMARY           |s    |          |eq_ref|PRIMARY                                              |PRIMARY                 |4      |shop_db.p.supplier_id  |1   |100.0   |                                                                         |
|1  |PRIMARY           |pcg  |          |ref   |PRIMARY,fk_product_category_category                 |PRIMARY                 |4      |shop_db.p.id           |1   |100.0   |Using index                                                              |
|1  |PRIMARY           |c    |          |eq_ref|PRIMARY                                              |PRIMARY                 |4      |shop_db.pcg.category_id|1   |100.0   |                                                                         |
|3  |DEPENDENT SUBQUERY|pc   |          |ref   |fk_purchase_product                                  |fk_purchase_product     |5      |shop_db.p.id           |1   |100.0   |                                                                         |
|2  |DEPENDENT SUBQUERY|pc   |          |ref   |fk_purchase_product                                  |fk_purchase_product     |5      |shop_db.p.id           |1   |100.0   |Using index                                                              |

#### Анализ EXPLAIN'а:
1) На верхнем уровне видим, что база **_Using temporary; Using filesort_** создаёт
временную таблицу и самостоятельно её сортирует (без опоры на индекс или т.п.), что
добавляет накладных расходов.  
**Идея:** убрать сортировку внутрь подзапроса?  
2) _**Using join buffer (Block Nested Loop)**_ похоже, используется блочное слияние
без использования индекса. Плюс фильтруются все строки.
**Идея:** рассмотреть добавление индекса, по которому производится range-фильтрация
у нас единственный вариант это price
3) DEPENDENT SUBQUERY - говорит о том, что подзапросы выполняются для каждой строки
резалтсета, что ресурсоёмко.
**Идея:** Использовать JOIN вместо подзапросов.

**explain analyze:**  
-> Limit: 10 row(s)  (actual time=2.025..2.025 rows=4 loops=1)  
-> Sort row IDs: <temporary>.total_revenue DESC, limit input to 10 row(s) per chunk  (actual time=2.024..2.025 rows=4 loops=1)  
-> Table scan on <temporary>  (actual time=0.001..0.002 rows=4 loops=1)  
-> Temporary table  (actual time=2.001..2.002 rows=4 loops=1)  
-> Nested loop inner join  (cost=6.86 rows=0) (actual time=1.676..1.705 rows=4 loops=1)  
-> Nested loop inner join  (cost=5.83 rows=0) (actual time=1.305..1.329 rows=4 loops=1)  
-> Nested loop inner join  (cost=2.81 rows=0) (actual time=0.842..0.859 rows=4 loops=1)  
-> Inner hash join (p.manufacturer_id = m.id)  (cost=2.54 rows=0) (actual time=0.728..0.740 rows=4 loops=1)  
-> Filter: (p.price > 20.00)  (cost=0.29 rows=1) (actual time=0.081..0.089 rows=4 loops=1)  
-> Index range scan on p using idx_product_supplier, with index condition: ((p.supplier_id is not null) and (p.id is not null))  (cost=0.29 rows=9) (actual time=0.077..0.083 rows=9 loops=1)  
-> Hash  
-> Index scan on m using manufacturer_name_unique  (cost=1.30 rows=3) (actual time=0.626..0.631 rows=3 loops=1)  
-> Single-row index lookup on s using PRIMARY (id=p.supplier_id)  (cost=0.12 rows=1) (actual time=0.029..0.029 rows=1 **loops=4**)  
-> Index lookup on pcg using PRIMARY (product_id=p.id)  (cost=1.03 rows=1) (actual time=0.117..0.117 rows=1 **loops=4**)  
-> Single-row index lookup on c using PRIMARY (id=pcg.category_id)  (cost=0.37 rows=1) (actual time=0.093..0.093 rows=1 **loops=4**)  
-> Select #2 (subquery in projection; dependent)  
-> Aggregate: count(0)  (actual time=0.010..0.010 rows=1 loops=4)  
-> Index lookup on pc using fk_purchase_product (product_id=p.id)  (cost=0.36 rows=1) (actual time=0.008..0.009 rows=1 **loops=4**)  
-> Select #3 (subquery in projection; dependent)  
-> Aggregate: sum((p.price * pc.quantity))  (actual time=0.008..0.008 rows=1 loops=4)  
-> Index lookup on pc using fk_purchase_product (product_id=p.id)  (cost=0.40 rows=1) (actual time=0.005..0.006 rows=1 **loops=4**)  
#### Анализ EXPLAIN ANALYZE'а
1) Вдобавок ко всему, что уже обозначено в анализе **EXPLAIN**, как Table scan временной таблицы
(что на большом объёме было бы накладно), видно loops=4, что подчёркивает неэффективность
подзапросов.
2) Используются слияния по индексу и index-lookup, что неплохо
3) manufacturer_name_unique - используется странный индекс по имени
**Идея:** после первоначального тюнинга посмотреть, останется ли этот индекс
и исследовать далее, если покажется, что он может давать замедление

**explain format=json:**
```json 
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "10.05"
    },
    "ordering_operation": {
      "using_temporary_table": true,
      "using_filesort": true,
      "cost_info": {
        "sort_cost": "3.00"
      },
      "nested_loop": [
        {
          "table": {
            "table_name": "m",
            "access_type": "index",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "manufacturer_name_unique",
            "used_key_parts": [
              "name"
            ],
            "key_length": "1022",
            "rows_examined_per_scan": 3,
            "rows_produced_per_join": 3,
            "filtered": "100.00",
            "using_index": true,
            "cost_info": {
              "read_cost": "1.00",
              "eval_cost": "0.30",
              "prefix_cost": "1.30",
              "data_read_per_join": "3K"
            },
            "used_columns": [
              "id",
              "name"
            ]
          }
        },
        {
          "table": {
            "table_name": "p",
            "access_type": "range",
            "possible_keys": [
              "PRIMARY",
              "idx_product_manufacturer",
              "idx_product_supplier"
            ],
            "key": "idx_product_supplier",
            "used_key_parts": [
              "supplier_id"
            ],
            "key_length": "5",
            "rows_examined_per_scan": 9,
            "rows_produced_per_join": 2,
            "filtered": "9.09",
            "index_condition": "((`shop_db`.`p`.`supplier_id` is not null) and (`shop_db`.`p`.`id` is not null))",
            "using_join_buffer": "Block Nested Loop",
            "cost_info": {
              "read_cost": "1.75",
              "eval_cost": "0.30",
              "prefix_cost": "4.15",
              "data_read_per_join": "3K"
            },
            "used_columns": [
              "id",
              "name",
              "price",
              "manufacturer_id",
              "supplier_id"
            ],
            "attached_condition": "((`shop_db`.`p`.`manufacturer_id` = `shop_db`.`m`.`id`) and (`shop_db`.`p`.`price` > 20.00))"
          }
        },
        {
          "table": {
            "table_name": "s",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "id"
            ],
            "key_length": "4",
            "ref": [
              "shop_db.p.supplier_id"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 2,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "1.00",
              "eval_cost": "0.30",
              "prefix_cost": "5.45",
              "data_read_per_join": "3K"
            },
            "used_columns": [
              "id",
              "name"
            ]
          }
        },
        {
          "table": {
            "table_name": "pcg",
            "access_type": "ref",
            "possible_keys": [
              "PRIMARY",
              "fk_product_category_category"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "product_id"
            ],
            "key_length": "4",
            "ref": [
              "shop_db.p.id"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 2,
            "filtered": "100.00",
            "using_index": true,
            "cost_info": {
              "read_cost": "0.75",
              "eval_cost": "0.30",
              "prefix_cost": "6.50",
              "data_read_per_join": "47"
            },
            "used_columns": [
              "product_id",
              "category_id"
            ]
          }
        },
        {
          "table": {
            "table_name": "c",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "id"
            ],
            "key_length": "4",
            "ref": [
              "shop_db.pcg.category_id"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 2,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "0.25",
              "eval_cost": "0.30",
              "prefix_cost": "7.05",
              "data_read_per_join": "3K"
            },
            "used_columns": [
              "id",
              "name"
            ]
          }
        }
      ],
      "select_list_subqueries": [
        {
          "dependent": true,
          "cacheable": false,
          "query_block": {
            "select_id": 3,
            "cost_info": {
              "query_cost": "1.26"
            },
            "table": {
              "table_name": "pc",
              "access_type": "ref",
              "possible_keys": [
                "fk_purchase_product"
              ],
              "key": "fk_purchase_product",
              "used_key_parts": [
                "product_id"
              ],
              "key_length": "5",
              "ref": [
                "shop_db.p.id"
              ],
              "rows_examined_per_scan": 1,
              "rows_produced_per_join": 1,
              "filtered": "100.00",
              "cost_info": {
                "read_cost": "1.14",
                "eval_cost": "0.11",
                "prefix_cost": "1.26",
                "data_read_per_join": "54"
              },
              "used_columns": [
                "product_id",
                "quantity"
              ]
            }
          }
        },
        {
          "dependent": true,
          "cacheable": false,
          "query_block": {
            "select_id": 2,
            "cost_info": {
              "query_cost": "1.11"
            },
            "table": {
              "table_name": "pc",
              "access_type": "ref",
              "possible_keys": [
                "fk_purchase_product"
              ],
              "key": "fk_purchase_product",
              "used_key_parts": [
                "product_id"
              ],
              "key_length": "5",
              "ref": [
                "shop_db.p.id"
              ],
              "rows_examined_per_scan": 1,
              "rows_produced_per_join": 1,
              "filtered": "100.00",
              "using_index": true,
              "cost_info": {
                "read_cost": "1.00",
                "eval_cost": "0.11",
                "prefix_cost": "1.11",
                "data_read_per_join": "54"
              },
              "used_columns": [
                "product_id"
              ]
            }
          }
        }
      ]
    }
  }
}
```

#### Анализ EXPLAIN FORMAT=JSON'а
1) Точно так же тут видно using_filesort на временной таблице, это уже обсуждали
2) Опять же, видно низкую фильтрацию по цене при доступе к 
_"key": "idx_product_supplier", ... "filtered": "9.09"_
3) Те же "Block Nested Loop" и  
"dependent": true,  
"cacheable": false

Попробуем учесть наши идеи и произвести...
## Улучшение запроса
Попробуем так:

```sql 
SELECT 
        p.id AS product_id, 
        p.name AS product_name, 
        m.name AS manufacturer_name, 
        s.name AS supplier_name,
        c.name AS category_name, 
        COALESCE(pc_data.total_sales, 0) AS total_sales,
        COALESCE(pc_data.total_revenue, 0) AS total_revenue
    FROM product p
    JOIN product_category pcg ON p.id = pcg.product_id
    JOIN category c ON pcg.category_id = c.id
    JOIN manufacturer m ON p.manufacturer_id = m.id
    JOIN supplier s ON p.supplier_id = s.id
    LEFT JOIN (
        SELECT 
            product_id, 
        	COUNT(*) AS total_sales, 
        	SUM(product.price * quantity) AS total_revenue
    	FROM purchase join product on purchase.product_id = product.id 
        GROUP BY product_id
    ) AS pc_data ON p.id = pc_data.product_id
    WHERE p.price > 20
    ORDER BY total_revenue DESC
    LIMIT 10
) AS sorted_results;
```
**Результат EXPLAIN:**

|id |select_type|table     |partitions|type  |possible_keys                                                          |key                     |key_len|ref                        |rows|filtered|Extra                                             |
|---|-----------|----------|----------|------|-----------------------------------------------------------------------|------------------------|-------|---------------------------|----|--------|--------------------------------------------------|
|1  |PRIMARY    |<derived2>|          |ALL   |                                                                       |                        |       |                           |6   |100.0   |                                                  |
|2  |DERIVED    |m         |          |index |PRIMARY                                                                |manufacturer_name_unique|1022   |                           |3   |100.0   |Using index; Using temporary; Using filesort      |
|2  |DERIVED    |s         |          |index |PRIMARY                                                                |supplier_name_unique    |1022   |                           |3   |100.0   |Using index; Using join buffer (Block Nested Loop)|
|2  |DERIVED    |p         |          |ref   |PRIMARY,idx_product_manufacturer,idx_product_supplier,product_price_idx|idx_product_manufacturer|5      |shop_db.m.id               |2   |13.64   |Using where                                       |
|2  |DERIVED    |pcg       |          |ref   |PRIMARY,fk_product_category_category                                   |PRIMARY                 |4      |shop_db.p.id               |1   |100.0   |Using index                                       |
|2  |DERIVED    |c         |          |eq_ref|PRIMARY                                                                |PRIMARY                 |4      |shop_db.pcg.category_id    |1   |100.0   |                                                  |
|2  |DERIVED    |<derived3>|          |ref   |<auto_key0>                                                            |<auto_key0>             |5      |shop_db.p.id               |2   |100.0   |                                                  |
|3  |DERIVED    |purchase  |          |ALL   |fk_purchase_product                                                    |                        |       |                           |8   |100.0   |Using where; Using temporary                      |
|3  |DERIVED    |product   |          |eq_ref|PRIMARY                                                                |PRIMARY                 |4      |shop_db.purchase.product_id|1   |100.0   |                                                  |
