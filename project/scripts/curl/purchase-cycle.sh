while true; do
    echo "$(date) → Отправляем запрос..."
    curl -X POST "http://host.docker.internal:8080/lapland/make-random-purchase" -H "Content-Type: application/json" -d '{}'
    echo "$(date) → Запрос отправлен! Ждём 120 секунд..."
    sleep 120
done