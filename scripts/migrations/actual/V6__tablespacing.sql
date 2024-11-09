ALTER TABLE customer_data.customer SET TABLESPACE shop_ts;

ALTER INDEX customer_data.customer_email_key SET TABLESPACE shop_ts;
ALTER INDEX customer_data.customer_pkey SET TABLESPACE shop_ts;
ALTER INDEX customer_data.idx_customer_email SET TABLESPACE shop_ts;

ALTER TABLE product_data.category SET TABLESPACE shop_ts;
ALTER TABLE product_data.manufacturer SET TABLESPACE shop_ts;
ALTER TABLE product_data.product SET TABLESPACE shop_ts;
ALTER TABLE product_data.productcategory SET TABLESPACE shop_ts;
ALTER TABLE product_data.supplier SET TABLESPACE shop_ts;

ALTER INDEX product_data.idx_manufacturer_name SET TABLESPACE shop_ts;
ALTER INDEX product_data.manufacturer_name_unique SET TABLESPACE shop_ts;
ALTER INDEX product_data.manufacturer_pkey SET TABLESPACE shop_ts;
ALTER INDEX product_data.idx_product_manufacturer SET TABLESPACE shop_ts;
ALTER INDEX product_data.idx_product_name SET TABLESPACE shop_ts;
ALTER INDEX product_data.idx_product_supplier SET TABLESPACE shop_ts;
ALTER INDEX product_data.product_pkey SET TABLESPACE shop_ts;
ALTER INDEX product_data.productcategory_pkey SET TABLESPACE shop_ts;
ALTER INDEX product_data.idx_supplier_name SET TABLESPACE shop_ts;
ALTER INDEX product_data.supplier_name_unique SET TABLESPACE shop_ts;
ALTER INDEX product_data.supplier_pkey SET TABLESPACE shop_ts;
ALTER INDEX product_data.category_name_unique SET TABLESPACE shop_ts;
ALTER INDEX product_data.category_pkey SET TABLESPACE shop_ts;
ALTER INDEX product_data.idx_category_name SET TABLESPACE shop_ts;

ALTER TABLE purchase_data.purchase SET TABLESPACE shop_ts;
ALTER INDEX purchase_data.purchase_pkey SET TABLESPACE shop_ts;