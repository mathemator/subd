CREATE DATABASE IF NOT EXISTS shop_db;
USE shop_db;

CREATE USER 'shop_user'@'%' IDENTIFIED BY 'shop_password';

GRANT ALL PRIVILEGES ON shop_db.* TO 'shop_user'@'%';
FLUSH PRIVILEGES;

CREATE TABLE customer (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE category (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    UNIQUE KEY category_name_unique (name)
) ENGINE = InnoDB;

CREATE INDEX idx_category_name on category (name);

CREATE TABLE manufacturer (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    UNIQUE KEY manufacturer_name_unique (name)
) ENGINE = InnoDB;

CREATE INDEX idx_manufacturer_name on manufacturer (name);

CREATE TABLE supplier (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    UNIQUE KEY supplier_name_unique (name)
) ENGINE = InnoDB;

CREATE INDEX idx_supplier_name ON supplier (name);

CREATE TABLE product (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Ограничение CHECK поддерживается начиная с MySQL 8.0.16
    manufacturer_id INT DEFAULT NULL,
    supplier_id INT DEFAULT NULL,
    CONSTRAINT fk_product_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id),
    CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id)
) ENGINE = InnoDB;

CREATE INDEX idx_product_manufacturer ON product (manufacturer_id);

CREATE INDEX idx_product_name ON product (name);

CREATE INDEX idx_product_supplier ON product (supplier_id);

CREATE TABLE productcategory (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    CONSTRAINT fk_productcategory_category FOREIGN KEY (category_id) REFERENCES category(id),
    CONSTRAINT fk_productcategory_product FOREIGN KEY (product_id) REFERENCES product(id) ON delete CASCADE
) ENGINE = InnoDB;

CREATE TABLE purchase (
    id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    customer_id INT DEFAULT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    product_id INT DEFAULT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_purchase_customer FOREIGN KEY (customer_id) REFERENCES customer(id) ON delete CASCADE,
    CONSTRAINT fk_purchase_product FOREIGN KEY (product_id) REFERENCES product(id) ON delete CASCADE
) ENGINE = InnoDB;

