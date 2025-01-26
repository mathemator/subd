## LOAD DATA загрузка .csv

```sql
LOAD DATA INFILE '/var/lib/mysql-files/chapter26/new_products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(name, attributes, price);
```
### Результат общей выборки:
| ID | Product                 | Price | Category | Subcategory | Attributes                               |
|----|-------------------------|-------|----------|-------------|------------------------------------------|
| 1  | Wireless Mouse          | 25.99 | 2        | 3           |                                          |
| 2  | Electric Kettle         | 45.00 | 1        | 1           |                                          |
| 3  | Soccer Ball             | 20.00 | 3        | 2           |                                          |
| 4  | Novel: Adventure Tales  | 15.00 |          | 3           |                                          |
| 5  | T-shirt                 | 19.99 | 1        | 1           | {"size": "M", "color": "red", "material": "cotton"} |
| 6  | Jeans                   | 49.99 |          |             | {"size": "L", "color": "blue"}           |
| 7  | Jacket                  | 99.99 |          |             | {"size": "M", "color": "black"}          |

## использование команды mysqlimport
```bash
mysqlimport --local --default-character-set=utf8mb4 --fields-terminated-by=',' --fields-enclosed-by='"' --lines-terminated-by='\n' --columns='name,manufacturer_id,supplier_id,price' --user=root --password=root shop_db /var/lib/mysql-files/chapter26/product.csv
mysqlimport: [Warning] Using a password on the command line interface can be insecure.
shop_db.product: Records: 2  Deleted: 0  Skipped: 0  Warnings: 0
```
### Результат общей выборки:
| ID | Product                 | Price | Category | Subcategory | Attributes                               |
|----|-------------------------|-------|----------|-------------|------------------------------------------|
| 1  | Wireless Mouse          | 25.99 | 2        | 3           |                                          |
| 2  | Electric Kettle         | 45.00 | 1        | 1           |                                          |
| 3  | Soccer Ball             | 20.00 | 3        | 2           |                                          |
| 4  | Novel: Adventure Tales  | 15.00 |          | 3           |                                          |
| 5  | T-shirt                 | 19.99 | 1        | 1           | {"size": "M", "color": "red", "material": "cotton"} |
| 6  | Jeans                   | 49.99 |          |             | {"size": "L", "color": "blue"}           |
| 7  | Jacket                  | 99.99 |          |             | {"size": "M", "color": "black"}          |
| 9  | Pullover with a deer    | 79.99 | 1        | 1           |                                          |
| 10 | Doge baseball cap       | 89.99 | 3        | 2           |                                          |
