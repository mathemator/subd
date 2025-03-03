# Используем официальный образ Node.js в качестве базового
FROM node:18 AS build

# Установим рабочую директорию в контейнере
WORKDIR /app

# Копируем package.json и package-lock.json (если есть) в контейнер
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем все файлы проекта в контейнер
COPY . .

# Собираем проект для продакшн
RUN npm run build

# Для диагностики: выводим содержимое каталога после сборки
RUN ls -la /app

# Второй этап: создание конечного образа для работы
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа в папку с веб-ресурсами Nginx
COPY --from=build /app/dist /usr/share/nginx/html
# Копируем кастомный конфиг Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт для веб-сервера
EXPOSE 80

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]
