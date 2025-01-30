LOAD DATA INFILE '/var/lib/mysql-files/chapter26/new_products.csv'
INTO TABLE product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(name, attributes, price);