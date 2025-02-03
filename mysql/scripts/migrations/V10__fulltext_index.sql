CREATE INDEX idx_purchase_purchase_date ON purchase (purchase_date);

ALTER TABLE product ADD COLUMN tags_text TEXT
    GENERATED ALWAYS AS (
        CONCAT(COALESCE(JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.color')), ''), ' ',
         COALESCE(JSON_UNQUOTE(JSON_EXTRACT(attributes, '$.material')), ''))
    ) STORED;

ALTER TABLE product ADD COLUMN description TEXT;

UPDATE product SET description = 'A wireless mouse for all your computer needs.' WHERE id = 1;
UPDATE product SET description = 'A stylish electric kettle for your kitchen.' WHERE id = 2;
UPDATE product SET description = 'A durable soccer ball for outdoor games.' WHERE id = 3;
UPDATE product SET description = 'An exciting adventure novel to enjoy during your free time.' WHERE id = 4;
UPDATE product SET description = 'Comfortable T-shirt in red cotton fabric.' WHERE id = 5;
UPDATE product SET description = 'Classic blue jeans made from durable fabric.' WHERE id = 6;
UPDATE product SET description = 'A black jacket for all seasons.' WHERE id = 7;
UPDATE product SET description = 'Smartphone with a large 6.5-inch screen and 5000mAh battery.' WHERE id = 8;
UPDATE product SET description = 'A bicycle with a lightweight aluminum frame and 21-speed gears.' WHERE id = 9;
UPDATE product SET description = 'Colorful children\'s toy made from safe plastic material.' WHERE id = 10;

INSERT INTO product
(id, name, price, manufacturer_id, supplier_id, `attributes`, description)
VALUES(11, 'Cat\'s Mouse Toy', 4.99, 1, 3, '{"material": "textile", "color": "blue"}', 'Your cat will love it. 100% safe');

CREATE FULLTEXT INDEX product_fulltext_idx ON product (name, description, tags_text);
