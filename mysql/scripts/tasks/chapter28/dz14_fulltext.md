## Добавление индексов
Хорошей идеей показалось добавить индекс в покупки по датам - для аналитики может пригодиться.
Ниже результаты для 
```sql
explain select * from purchase where purchase_date = '2025-02-01'
```
без индекса и с индексом:

| id | select_type | table    | partitions | type | possible_keys                  | key                              | key_len | ref   | rows | filtered | Extra         |
|----|------------|---------|------------|------|--------------------------------|---------------------------------|---------|------|------|----------|---------------|
| 1  | SIMPLE     | purchase |            | ALL  |                                |                                 |         |      | 8    | 12.5     | Using where   |
| 1  | SIMPLE     | purchase |            | ref  | idx_purchase_purchase_date     | idx_purchase_purchase_date      | 5       | const | 1    | 100.0    |               |

## Задание с полнотекстовым индексом
Был добавлен полнотекстовый индекс (см. скрипт миграции) на имя, описание и некоторые 
"значимые атрибуты" - цвет и материал, взятые для примера.
В зависимости от бизнес-модели можно было придумать как-то ещё...
Ниже результаты выполнения explain для запросов типа 
```sql 
explain 
select * from product
where UPPER(name) like '%BLUE%' 
or UPPER(description) like '%BLUE%'
or UPPER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.color')), '')) like '%BLUE%'
or UPPER(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.material')), '')) like '%BLUE%';
```
Запрос был подогнан под **результат**:

| id  | name              | price | manufacturer_id | supplier_id | attributes                                | description                                        | tags_text       |
|----|------------------|-------|----------------|------------|------------------------------------------|------------------------------------------------|--------------|
| 6  | Jeans           | 49.99 |                |            | {"size": "L", "color": "blue"}          | Classic blue jeans made from durable fabric. | blue         |
| 11 | Cat's Mouse Toy | 4.99  | 1              | 3          | {"color": "blue", "material": "textile"} | Your cat will love it. 100% safe.            | blue textile |


Тут ясно, что запрос довольно кривенький, и при большем числе значимых
атрибутов такой запрос будет давать большую нагрузку на процессор 
и медленно работать на больших размерах таблицы.
Для сравнения был выбран запрос после добавления индекса:
```sql
EXPLAIN 
SELECT * FROM product 
WHERE MATCH(name, description, tags_text) AGAINST('blue cat mouse' IN NATURAL LANGUAGE MODE);
```
**Результат** шире засчёт "похожих по смыслу":

| id  | name              | price | manufacturer_id | supplier_id | attributes                                | description                                        | tags_text       |
|----|------------------|-------|----------------|------------|------------------------------------------|------------------------------------------------|--------------|
| 11 | Cat's Mouse Toy | 4.99  | 1              | 3          | {"color": "blue", "material": "textile"} | Your cat will love it. 100% safe.            | blue textile |
| 1  | Wireless Mouse  | 25.99 | 2              | 3          |                                          | A wireless mouse for all your computer needs. |              |
| 6  | Jeans           | 49.99 |                |            | {"size": "L", "color": "blue"}          | Classic blue jeans made from durable fabric. | blue         |
**Explain:**

| id | select_type | table   | partitions | type      | possible_keys        | key                   | key_len | ref   | rows | filtered | Extra                                |
|----|------------|---------|------------|----------|----------------------|-----------------------|--------|------|------|----------|------------------------------------|
| 1  | SIMPLE     | product |            | fulltext | product_fulltext_idx | product_fulltext_idx  | 0      | const | 1    | 100.0    | Using where; Ft_hints: sorted |
