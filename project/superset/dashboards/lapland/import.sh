#!/bin/bash

# Настройки Superset
SUPERSET_HOST="http://superset:8089"  # Адрес Superset (замени, если нужно)
SUPERSET_USER="admin"  # Логин
SUPERSET_PASSWORD="admin"  # Пароль

# Получение токена аутентификации
TOKEN_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"username": "'$SUPERSET_USER'", "password": "'$SUPERSET_PASSWORD'", "provider": "db", "refresh": true}' \
  $SUPERSET_HOST/api/v1/security/login)

TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

# Проверяем, получили ли мы токен
if [ -z "$TOKEN" ]; then
  echo "Ошибка: не удалось получить токен аутентификации"
  exit 1
fi

curl -v -s -X 'POST' "$SUPERSET_HOST/api/v1/dashboard/import/" \
  -H "Authorization: Bearer $TOKEN" \
  -H "accept: application/json" \
  -H "Content-Type: multipart/form-data" \
  -F "formData=@/app/dashboard_archive/lapland/dashboard_export_20250223T110851.zip;type=application/zip" \
  -F 'passwords={"databases/PostgreSQL.yaml": "lapland"}' \

echo "Импорт завершен!"
