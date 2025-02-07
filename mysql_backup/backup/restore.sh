#!/bin/bash
set -e

echo "🐱 Создаём директорию с нужной файловой системой"
mkdir -p /mnt/mysql_data

echo "🐱 Расшифровываем бэкап..."
openssl des3 -d -salt -k "password" -in /backup/backup_des.xbstream.gz.des3 | gunzip > /tmp/backup.xbstream

echo "🐱 Распаковываем xbstream..."
mkdir -p /tmp/extract
xbstream -x < /tmp/backup.xbstream -C /tmp/extract

echo "🐱 Подготавливаем файлы InnoDB..."
xtrabackup --prepare --target-dir=/tmp/extract

echo "🐱 Останавливаем MySQL..."
mysqladmin -uroot --skip-password shutdown || true

echo "🐱 Восстанавливаем файлы..."
rm -rf /mnt/mysql_data/*
xtrabackup --copy-back --target-dir=/tmp/extract
chown -R mysql:mysql /mnt/mysql_data
chmod -R 755 /mnt/mysql_data

echo "🐱 Запускаем MySQL..."
service mysql restart

echo "🐱 Результат задачи в файл в подмонтированной директории..."
mysql -uroot world --skip-password -e "SELECT COUNT(*) FROM world.city WHERE countrycode = 'RUS';" >> /backup/result.txt

# Держим контейнер активным
#tail -f /dev/null
