create DATABASE IF NOT EXISTS people;
USE people;

CREATE TABLE init_customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(20),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    correspondence_language VARCHAR(10),
    birth_date VARCHAR(10),
    gender VARCHAR(10),
    marital_status VARCHAR(20),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    city VARCHAR(50),
    street VARCHAR(100),
    building_number VARCHAR(10)
);

LOAD DATA INFILE '/var/lib/mysql-files/some_customers.csv'
INTO TABLE init_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(title,
first_name,
last_name,
correspondence_language,
birth_date,
gender,
marital_status,
country,
postal_code,
region,
city,
street,
building_number);

-- Создаем таблицу титулов (г-н, г-жа и т. д.)
CREATE TABLE titles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);

-- Создаем таблицу полов
CREATE TABLE genders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL
);

-- Создаем таблицу языков
CREATE TABLE languages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL
);

-- Создаем таблицу семейного положения
CREATE TABLE marital_statuses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) UNIQUE NOT NULL
);

-- Создаем таблицу стран
CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NULL,
    code CHAR(2) UNIQUE NOT NULL
);

-- Создаем таблицу регионов
CREATE TABLE regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    country_id INT NULL
);

CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region_id INT NULL,
    country_id INT NULL
);

-- Создаем таблицу улиц
CREATE TABLE streets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city_id INT NULL
);

-- Создаем таблицу адресов
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    postal_code VARCHAR(20) NOT NULL,
    street_id INT NULL,
    building_number VARCHAR(10) NULL
);

-- Создаем таблицу клиентов
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE,
    gender_id INT,
    marital_status_id INT,
    language_id INT
);

-- Создаем таблицу связей клиентов и адресов
CREATE TABLE customer_addresses (
    customer_id INT NOT NULL,
    address_id INT NOT NULL
);

-- Перенос данных из init_customers в новые таблицы
INSERT INTO titles (name)
SELECT DISTINCT title FROM init_customers WHERE title IS NOT NULL AND title <> '';

INSERT INTO genders (name)
SELECT DISTINCT gender FROM init_customers WHERE gender IS NOT NULL AND gender <> '';

INSERT INTO languages (name)
SELECT DISTINCT correspondence_language FROM init_customers WHERE correspondence_language IS NOT NULL AND correspondence_language <> '';

INSERT INTO marital_statuses (name)
SELECT DISTINCT marital_status FROM init_customers WHERE marital_status IS NOT NULL AND marital_status <> '';

INSERT INTO countries (code)
SELECT DISTINCT country FROM init_customers WHERE country IS NOT NULL AND country <> '';

INSERT INTO regions (name, country_id)
SELECT DISTINCT ic.region, c.id FROM init_customers ic
LEFT JOIN countries c ON ic.country = c.code WHERE ic.region IS NOT NULL AND ic.region <> '';

INSERT INTO cities (name, region_id, country_id)
SELECT DISTINCT ic.city, r.id, c.id FROM init_customers ic
LEFT JOIN regions r ON ic.region = r.name
LEFT JOIN countries c on ic.country = c.code
WHERE ic.city IS NOT NULL AND ic.city <> '';

INSERT INTO streets (name, city_id)
SELECT DISTINCT ic.street, ci.id FROM init_customers ic
LEFT JOIN cities ci ON ic.city = ci.name WHERE ic.street IS NOT NULL AND ic.street <> '';

INSERT INTO addresses (postal_code, street_id, building_number)
SELECT DISTINCT ic.postal_code, s.id, ic.building_number FROM init_customers ic
LEFT JOIN streets s ON ic.street = s.name WHERE ic.postal_code <> '' OR ic.building_number IS NOT NULL OR ic.building_number <> '';

INSERT INTO customers (title_id, first_name, last_name, birth_date, gender_id, marital_status_id, language_id)
SELECT DISTINCT t.id, ic.first_name, ic.last_name,
CASE
    WHEN ic.birth_date IS NULL or ic.birth_date = '' THEN NULL
    ELSE STR_TO_DATE(ic.birth_date, '%Y-%m-%d')
  END AS birth_date,
g.id, ms.id, l.id FROM init_customers ic
LEFT JOIN titles t ON ic.title = t.name
LEFT JOIN genders g ON ic.gender = g.name
LEFT JOIN marital_statuses ms ON ic.marital_status = ms.name
LEFT JOIN languages l ON ic.correspondence_language = l.name
WHERE ic.first_name <> '' OR ic.last_name <> '';

INSERT INTO customer_addresses (customer_id, address_id)
SELECT c.id, a.id FROM (
    SELECT DISTINCT first_name, last_name, postal_code FROM init_customers
    WHERE (first_name <> '' or last_name <> '') AND postal_code IS NOT NULL AND postal_code <> ''
) ic
JOIN customers c ON ic.first_name = c.first_name AND ic.last_name = c.last_name
JOIN addresses a ON ic.postal_code = a.postal_code;

ALTER TABLE init_customers ENGINE=ndbcluster;

ALTER TABLE titles ENGINE=ndbcluster;
ALTER TABLE genders ENGINE=ndbcluster;
ALTER TABLE languages ENGINE=ndbcluster;
ALTER TABLE marital_statuses ENGINE=ndbcluster;
ALTER TABLE countries ENGINE=ndbcluster;
ALTER TABLE cities ENGINE=ndbcluster;
ALTER TABLE streets ENGINE=ndbcluster;
ALTER TABLE addresses ENGINE=ndbcluster;
ALTER TABLE customers ENGINE=ndbcluster;
ALTER TABLE customer_addresses ENGINE=ndbcluster;