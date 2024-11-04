-- Создание таблицы категорий
CREATE TABLE IF NOT EXISTS Category (
                                        id SERIAL PRIMARY KEY,
                                        name VARCHAR(255) NOT NULL
    );

COMMENT ON TABLE Category IS 'Таблица для хранения категорий продуктов';
COMMENT ON COLUMN Category.name IS 'Название категории';

-- Создание таблицы производителей
CREATE TABLE IF NOT EXISTS Manufacturer (
                                            id SERIAL PRIMARY KEY,
                                            name VARCHAR(255) NOT NULL
    );

COMMENT ON TABLE Manufacturer IS 'Таблица для хранения производителей продуктов';
COMMENT ON COLUMN Manufacturer.name IS 'Название производителя';

-- Создание таблицы поставщиков
CREATE TABLE IF NOT EXISTS Supplier (
                                        id SERIAL PRIMARY KEY,
                                        name VARCHAR(255) NOT NULL
    );

COMMENT ON TABLE Supplier IS 'Таблица для хранения поставщиков';
COMMENT ON COLUMN Supplier.name IS 'Название поставщика';

-- Создание таблицы продуктов
CREATE TABLE IF NOT EXISTS Product (
                                       id SERIAL PRIMARY KEY,
                                       name VARCHAR(255) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    manufacturer_id INT REFERENCES Manufacturer(id),
    supplier_id INT REFERENCES Supplier(id)
    );

COMMENT ON TABLE Product IS 'Таблица для хранения продуктов';
COMMENT ON COLUMN Product.name IS 'Название продукта';
COMMENT ON COLUMN Product.price IS 'Цена продукта';
COMMENT ON COLUMN Product.manufacturer_id IS 'Идентификатор производителя';
COMMENT ON COLUMN Product.supplier_id IS 'Идентификатор поставщика';

-- Создание таблицы для хранения покупателей
CREATE TABLE IF NOT EXISTS Customer (
                                        id SERIAL PRIMARY KEY,
                                        name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
    );

COMMENT ON TABLE Customer IS 'Таблица для хранения покупателей';
COMMENT ON COLUMN Customer.name IS 'Имя покупателя';
COMMENT ON COLUMN Customer.email IS 'Электронная почта покупателя';

-- Создание таблицы для покупок
CREATE TABLE IF NOT EXISTS Purchase (
                                        id SERIAL PRIMARY KEY,
                                        customer_id INT REFERENCES Customer(id),
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

COMMENT ON TABLE Purchase IS 'Таблица для хранения покупок';
COMMENT ON COLUMN Purchase.customer_id IS 'Идентификатор покупателя';
COMMENT ON COLUMN Purchase.purchase_date IS 'Дата и время покупки';

-- Создание таблицы связи между продуктами и категориями
CREATE TABLE IF NOT EXISTS ProductCategory (
    product_id INT REFERENCES Product(id),
    category_id INT REFERENCES Category(id),
    PRIMARY KEY (product_id, category_id)
    );

COMMENT ON TABLE ProductCategory IS 'Таблица связи между продуктами и категориями';
COMMENT ON COLUMN ProductCategory.product_id IS 'Идентификатор продукта';
COMMENT ON COLUMN ProductCategory.category_id IS 'Идентификатор категории';
