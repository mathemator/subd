DELIMITER //

CREATE PROCEDURE update_product_categories(
    IN p_product_name VARCHAR(255),
    IN p_price DECIMAL(12,2),
    IN p_manufacturer_id INT,
    IN p_supplier_id INT,
    IN p_attributes JSON,
    IN p_categories JSON
)
BEGIN
    DECLARE cat_name VARCHAR(255);
    DECLARE cat_id INT;
    DECLARE product_id INT;
    DECLARE finished INT DEFAULT 0;

    -- Курсор для работы с JSON
    DECLARE cur CURSOR FOR
        SELECT JSON_UNQUOTE(json_extract(value, '$'))
        FROM JSON_TABLE(p_categories, '$[*]' COLUMNS (value JSON PATH '$')) AS jt;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    -- Начало транзакции
    START TRANSACTION;

    -- Проверяем, существует ли продукт
    IF NOT EXISTS (SELECT 1 FROM product WHERE name = p_product_name
        AND manufacturer_id = p_manufacturer_id
        AND supplier_id = p_supplier_id) THEN
    INSERT INTO product (name, price, manufacturer_id, supplier_id, attributes)
        VALUES (p_product_name, p_price, p_manufacturer_id, p_supplier_id, p_attributes);
    ELSE
        UPDATE product
        SET price = p_price,
            manufacturer_id = p_manufacturer_id,
            supplier_id = p_supplier_id,
            attributes = p_attributes
        WHERE name = p_product_name;
    END IF;

    -- Получаем ID продукта
    SELECT id INTO product_id FROM product WHERE name = p_product_name;

    -- Открываем курсор для обработки категорий
    OPEN cur;

    fetch_loop: LOOP
        FETCH cur INTO cat_name;
        IF finished THEN
            LEAVE fetch_loop;
        END IF;

        -- Проверяем, существует ли категория, если нет — добавляем
        IF NOT EXISTS (SELECT 1 FROM category WHERE name = cat_name) THEN
            INSERT INTO category (name) VALUES (cat_name);
        END IF;

        -- Получаем ID категории
        SELECT id INTO cat_id FROM category WHERE name = cat_name;

        -- Проверяем связь категории и продукта
        IF NOT EXISTS (SELECT 1 FROM productcategory WHERE product_id = product_id AND category_id = cat_id) THEN
            INSERT INTO productcategory (product_id, category_id) VALUES (product_id, cat_id);
        END IF;
    END LOOP;

    CLOSE cur;

    -- Подтверждение транзакции
    COMMIT;
END//

DELIMITER ;
