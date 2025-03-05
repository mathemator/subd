import { useState } from 'react';
import { useConfig } from '../ConfigContext'; // Импортируем хук

function Home() {
      const [message, setMessage] = useState('');
        const { serverUrl } = useConfig(); // Получаем значение переменной окружения

      const handleOrder = async () => {
        try {
          const response = await fetch(`${serverUrl}/lapland/make-random-order`, {
            method: 'POST',
          });
          if (response.ok) {
            const data = await response.json();
            setMessage('Покупка успешна, id: ' + data.id);
          } else {
            setMessage('Ошибка при совершении покупки');
          }
        } catch (error) {
          setMessage('Ошибка при связи с сервером');
        }
      };

  return (
    <div>
      <h1>Добро пожаловать в Лап-Ландию!</h1>
      <p>Выберите каталог, чтобы увидеть список товаров.</p>

      <h1>Или 🐶</h1>
      <button onClick={handleOrder}>Совершить случайную покупку</button>
      <p>{message}</p>
    </div>
  );
}

export default Home;
