CREATE PROCEDURE get_orders(
    IN p_start_date DATETIME,
    IN p_end_date DATETIME,
    IN p_group_by VARCHAR(50)
)
BEGIN
    SET @group_column_full = '';

    IF p_group_by = 'product_id' THEN
       	SET @group_column_full = 'p.id';
    ELSEIF p_group_by = 'category_id' THEN
        SET @group_column_full = 'c.id';
    ELSEIF p_group_by = 'manufacturer_id' THEN
        SET @group_column_full = 'p.manufacturer_id';
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid group_by parameter';
    END IF;

    SET @sql_query = CONCAT(
        'SELECT ', @group_column_full, ', COUNT(*) AS order_count, SUM(price * quantity) AS total_revenue
        FROM purchase pc
        	join product p on pc.product_id = p.id
        	join product_category pcg on p.id = pcg.product_id
        	join category c on pcg.category_id = c.id
        WHERE purchase_date BETWEEN ''', p_start_date, ''' AND ''', p_end_date, '''
        GROUP BY ', @group_column_full
    );

    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END