-- Создание таблицеспейса для данных
CREATE ROLE replication_user REPLICATION LOGIN PASSWORD 'replication_password';
CREATE TABLESPACE shop_ts LOCATION '/mnt/shop_ts';
