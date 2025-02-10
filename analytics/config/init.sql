CREATE DATABASE IF NOT EXISTS dump_db;
USE dump_db;

CREATE USER IF NOT EXISTS 'dump_user'@'%' IDENTIFIED BY 'dump_password';
ALTER USER 'dump_user'@'%' IDENTIFIED BY 'dump_password';

GRANT ALL PRIVILEGES ON dump_db.* TO 'dump_user'@'%';
GRANT SUPER ON *.* TO 'dump_user'@'%';
FLUSH PRIVILEGES;