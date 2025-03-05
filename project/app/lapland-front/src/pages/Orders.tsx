import React, { useEffect, useState } from "react";

interface Order {
  id: number;
  customerName: string;
  orderDate: string;
}

const Orders: React.FC = () => {
  const [orders, setOrders] = useState<Order[]>([]);
  const [lastId, setLastId] = useState<number | null>(null);
  const [hasMore, setHasMore] = useState(true);
  const [isLoading, setIsLoading] = useState(false);

  const fetchOrders = async (newLastId: number | null) => {
      console.log("fetchOrders called with lastId:", newLastId);
    if (isLoading) return; // предотвращаем повторные запросы
    setIsLoading(true);

    try {
      const url = new URL(`${import.meta.env.VITE_API_URL}/lapland/orders`);
      if (newLastId !== null) url.searchParams.append("lastId", (newLastId - 1).toString()); // Запрашиваем id - 1
      url.searchParams.append("size", "10");

      const response = await fetch(url.toString());
      if (!response.ok) throw new Error("Ошибка при загрузке данных");

      const data = await response.json();
      if (!data || !Array.isArray(data)) throw new Error("Некорректные данные");

      setOrders(data);
      setLastId(data.length > 0 ? data[data.length - 1].id  + 1: null);
      setHasMore(data.length === 10);
    } catch (error) {
      console.error("Ошибка:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders(null); // Загружаем первую страницу при монтировании
  }, []);

  return (
    <div>
      <h1>🛒 История покупок</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Клиент</th>
            <th>Дата покупки</th>
          </tr>
        </thead>
        <tbody>
          {orders.map((order) => (
            <tr key={order.id}>
              <td>{order.id}</td>
              <td>{order.customerName}</td>
              <td>{new Date(order.orderDate).toLocaleString()}</td>
            </tr>
          ))}
        </tbody>
      </table>

      {!isLoading && (
        <button
          onClick={() => fetchOrders((lastId ?? 0)-20)}
          disabled={(lastId ?? 0) <= 11 || isLoading}
        >
          Предыдущие
        </button>
      )}
      {hasMore && !isLoading && (
        <button
          onClick={() => fetchOrders(lastId)}
        >
          Следующие
        </button>
      )}
    </div>
  );
};

export default Orders;
