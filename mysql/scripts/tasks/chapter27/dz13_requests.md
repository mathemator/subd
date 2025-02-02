# Примеры запросов с агрегацией 

### GROUP BY: Запрос количества в штуках купленных товаров по покупателям
```sql
select pc.customer_id, c.name, sum(quantity) from
purchase pc left join product p on pc.product_id = p.id left join customer c on pc.customer_id = c.id
group by customer_id;
```
#### Результат:
| customer_id | name           | sum(quantity) |
|------------|---------------|--------------|
| 1          | Alice Johnson  | 5            |
| 2          | Bob Smith      | 2            |
| 3          | Charlie Brown  | 7            |

### HAVING: Запрос количеств купленных по категориям товаров, с агрегированным числом больше 1 (например, отсекаем случайные, устаревшие значения категорий) 
```sql 
select c.id, c.name ,  sum(pch.quantity) as cnt
from category c
join product_category pcg on c.id = pcg.category_id
join product p on pcg.product_id = p.id
join purchase pch on p.id = pch.product_id
group by c.id
having cnt > 1
order by cnt desc;
```
#### Результат: 
| id | name        | cnt |
|----|------------|-----|
| 1  | Electronics | 4   |
| 6  | Toys        | 3   |
| 4  | Books       | 3   |
| 5  | Clothing    | 2   |

### WITH ROLLUP, GROUPING: Запрос с агрегацией по покупателям и датам с подытогами и общей тотал-суммой
```sql 
SELECT 
    if(grouping(pc.customer_id), 'итог', pc.customer_id) as customer_id,
    DATE(pc.purchase_date) AS purchase_day, 
    SUM(p.price * pc.quantity) AS total_spent
FROM purchase pc
JOIN product p ON pc.product_id = p.id
GROUP BY pc.customer_id, purchase_day WITH ROLLUP
ORDER BY pc.customer_id desc, purchase_day desc;
```
#### Результат:
| customer_id | purchase_day | total_spent |
|-------------|-------------|-------------|
| 3           | 2025-02-05  | 44.97       |
| 3           | 2025-02-02  | 299.99      |
| 3           | 2024-11-27  | 45.00       |
| 3           |             | 389.96      |
| 2           | 2025-02-01  | 699.99      |
| 2           | 2024-11-26  | 45.00       |
| 2           |             | 744.99      |
| 1           | 2025-02-06  | 25.99       |
| 1           | 2025-01-29  | 39.98       |
| 1           | 2024-11-25  | 51.98       |
| 1           |             | 117.95      |
| **Итог**    |             | **1,252.90** |