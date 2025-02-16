#!/bin/bash
set -e

echo "🐱приветик"

chmod 644 /etc/mysql/conf.d/custom.cnf
chown mysql:mysql /etc/mysql/conf.d/custom.cnf

# Запускаем MySQL в фоновом режиме
docker-entrypoint.sh mysqld --init-file /etc/mysql/conf.d/init.sql &

# Ждем, пока MySQL полностью запустится
echo "⏳ Ждем запуск MySQL..."
until mysqladmin ping --silent; do
    sleep 1
done

# Восстанавливаем дамп
mysql -u dump_user -pdump_password dump_db < /mnt/dump/bet.dmp

echo "🐱 загрузили дамп!"
# Держим контейнер активным
tail -f /dev/null
