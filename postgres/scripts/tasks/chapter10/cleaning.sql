TRUNCATE TABLE
    purchase_data.purchase,
    product_data.product_category,
    product_data.product,
    product_data.category,
    product_data.manufacturer,
    product_data.supplier,
    customer_data.customer
RESTART IDENTITY; -- Сбрасываем последовательности ID
commit;