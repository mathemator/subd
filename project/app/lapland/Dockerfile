# 1. Используем официальный образ OpenJDK (JRE 17)
FROM eclipse-temurin:21-jre AS runtime

# 2. Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# 3. Копируем JAR-файл в контейнер
COPY build/libs/lapland-0.2.jar app.jar

# 4. Указываем команду запуска приложения
CMD ["java", "-jar", "app.jar"]
