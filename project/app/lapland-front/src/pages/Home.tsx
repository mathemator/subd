import { useState } from 'react';
import { useConfig } from '../ConfigContext'; // Импортируем хук

function Home() {
      const [message, setMessage] = useState('');
      const [loginMessage, setLoginMessage] = useState('');
      const [id, setId] = useState("");
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

  const handleSubmitId = async () => {
      if (!id.trim()) {
        setLoginMessage("Введите корректный ID");
        return;
      }

      try {
        const response = await fetch(`${serverUrl}/lapland/login/${id}`, {
          method: "POST",
          credentials: "include",
          headers: {
            "Content-Type": "application/json",
          },
        });

        if (response.ok) {
            const result = await response.text();
            console.log("ответ: " + result);
          localStorage.setItem("userId", id);
          setLoginMessage(result);
        } else {
            const result = await response.text();
          setLoginMessage(result);
        }
      } catch (error) {
        setLoginMessage("Ошибка.");
      }
    };

  return (
    <div>
      <h1>Добро пожаловать в Лап-Ландию!</h1>
      <p>Выберите каталог, чтобы увидеть список товаров.</p>

      <h1>Или 🐶</h1>
      <button onClick={handleOrder}>Лотерейная покупка!</button>
      <p>{message}</p>

      <h2>Введите ваш ID:</h2>
      <input
        type="text"
        value={id}
        onChange={(e) => setId(e.target.value)}
        placeholder="Введите ID"
      />
      <button onClick={handleSubmitId}>Сохранить ID</button>
      <p>{loginMessage}</p>
    </div>
  );
}

export default Home;
