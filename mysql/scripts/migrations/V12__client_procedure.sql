CREATE PROCEDURE get_products(
    IN p_category_id INT,
    IN p_price_min DECIMAL(10,2),
    IN p_price_max DECIMAL(10,2),
    IN p_manufacturer INT,
    IN p_additional_params JSON,
    IN p_sort_field VARCHAR(50),
    IN p_sort_order VARCHAR(4),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE offset_value INT;
    SET offset_value = (p_page_number - 1) * p_page_size;

    SET @sql_query = 'SELECT * FROM product p join product_category pcg on p.id = pcg.product_id join category c on pcg.category_id = c.id WHERE 1=1';

    -- Фильтрация
    IF p_category_id IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND c.id = ', p_category_id);
    END IF;

    IF p_price_min IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND price >= ', p_price_min);
    END IF;

    IF p_price_max IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND price <= ', p_price_max);
    END IF;

    IF p_manufacturer IS NOT NULL THEN
        SET @sql_query = CONCAT(@sql_query, ' AND manufacturer_id = ''', p_manufacturer, '''');
    END IF;

    -- Фильтрация по JSON (доп. параметры)
    IF JSON_LENGTH(p_additional_params) > 0 THEN
        SET @sql_query = CONCAT(@sql_query,
           ' AND JSON_CONTAINS(attributes, \'', p_additional_params, '\')');
    END IF;

    -- Сортировка
    IF p_sort_field IS NOT NULL AND p_sort_order IN ('ASC', 'DESC') THEN
        SET @sql_query = CONCAT(@sql_query, ' ORDER BY ', p_sort_field, ' ', p_sort_order);
    ELSE
        SET @sql_query = CONCAT(@sql_query, ' ORDER BY name ASC');
    END IF;

    -- Пагинация
    SET @sql_query = CONCAT(@sql_query, ' LIMIT ', p_page_size, ' OFFSET ', offset_value);

    -- Выполнение динамического SQL
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END