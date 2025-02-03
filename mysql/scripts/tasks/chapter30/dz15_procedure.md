## Примеры вызовов процедур

#### Получение товаров
С доп. параметрами:
```sql
 CALL get_products(NULL, 
 NULL, 
 NULL, 
 NULL, 
 '{"color": "red"}', 
 NULL, 
 NULL, 
 1, 10);
```
**Результат:**

| id | name    | price | manufacturer_id | supplier_id | attributes                                          | tags_text  | description                               | product_id | category_id | id | name |
|----|---------|-------|-----------------|-------------|-----------------------------------------------------|------------|-------------------------------------------|------------|-------------|----|------|
| 5  | T-shirt | 19.99 | 1               | 1           | {"size": "M", "color": "red", "material": "cotton"} | red cotton | Comfortable T-shirt in red cotton fabric. |            |             |    |      |

С сортировкой по цене, конкретная категория:
```sql
 CALL shop_db.get_products(
    1,       
    NULL,    
    NULL,    
    NULL,    
    NULL,    
    'price', 
    'ASC',   
    1,       
    10       
);
```
**Результат:**

| id | name           | price  | manufacturer_id | supplier_id | attributes                                   | tags_text | description                                                  | product_id | category_id | id | name        |
|----|----------------|--------|-----------------|-------------|----------------------------------------------|-----------|--------------------------------------------------------------|------------|-------------|----|-------------|
| 1  | Wireless Mouse | 25.99  | 2               | 3           |                                              |           | A wireless mouse for all your computer needs.                | 1          | 1           | 1  | Electronics |
| 8  | Smartphone     | 699.99 | 2               | 1           | {"screen": "6.5 inch", "battery": "5000mAh"} |           | Smartphone with a large 6.5-inch screen and 5000mAh battery. | 8          | 1           | 1  | Electronics |

#### Получение заказов

```sql 
CALL get_orders(
    '2020-01-01 00:00:00', 
    '2026-02-01 23:59:59', 
    'product_id'           
);
```
**Результат:**

| id | order_count | total_revenue |
|----|------------|--------------|
| 1  | 2          | 77.97        |
| 2  | 1          | 45.00        |
| 4  | 1          | 45.00        |
| 8  | 1          | 699.99       |
| 9  | 1          | 299.99       |
| 5  | 1          | 39.98        |
| 10 | 1          | 44.97        |
