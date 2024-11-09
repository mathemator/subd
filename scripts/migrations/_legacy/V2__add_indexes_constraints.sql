-- Добавление уникальных ограничений на название категорий, производителей и поставщиков
ALTER TABLE Category
ADD CONSTRAINT category_name_unique UNIQUE (name);

ALTER TABLE Manufacturer
ADD CONSTRAINT manufacturer_name_unique UNIQUE (name);

ALTER TABLE Supplier
ADD CONSTRAINT supplier_name_unique UNIQUE (name);

-- Добавление ограничения на поле price в таблице Product, чтобы цена не могла быть отрицательной
ALTER TABLE Product
ADD CONSTRAINT product_price_nonnegative CHECK (price >= 0);

-- Добавление ограничения на формат email в таблице Customer
ALTER TABLE Customer
ADD CONSTRAINT customer_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- Добавление индексов для оптимизации запросов

-- Индексы для Foreign Key полей в таблице Product
CREATE INDEX IF NOT EXISTS idx_product_manufacturer ON Product(manufacturer_id);
CREATE INDEX IF NOT EXISTS idx_product_supplier ON Product(supplier_id);

-- Индексы на поле name для ускорения поиска по категориям, производителям и поставщикам
CREATE INDEX IF NOT EXISTS idx_category_name ON Category(name);
CREATE INDEX IF NOT EXISTS idx_manufacturer_name ON Manufacturer(name);
CREATE INDEX IF NOT EXISTS idx_supplier_name ON Supplier(name);
CREATE INDEX IF NOT EXISTS idx_product_name ON Product(name);

-- Индекс на поле email для ускорения поиска по электронной почте покупателей
CREATE INDEX IF NOT EXISTS idx_customer_email ON Customer(email);
