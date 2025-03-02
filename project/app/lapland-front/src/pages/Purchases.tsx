import React, { useEffect, useState } from "react";

interface Purchase {
  id: number;
  customerName: string;
  purchaseDate: string;
}

const Purchases: React.FC = () => {
  const [purchases, setPurchases] = useState<Purchase[]>([]);
  const [lastId, setLastId] = useState<number | null>(null);
  const [hasMore, setHasMore] = useState(true);
  const [isLoading, setIsLoading] = useState(false);

  const fetchPurchases = async (newLastId: number | null) => {
      console.log("fetchPurchases called with lastId:", newLastId);
    if (isLoading) return; // предотвращаем повторные запросы
    setIsLoading(true);

    try {
      const url = new URL(`${import.meta.env.VITE_API_URL}/lapland/purchases`);
      if (newLastId !== null) url.searchParams.append("lastId", (newLastId - 1).toString()); // Запрашиваем id - 1
      url.searchParams.append("size", "10");

      const response = await fetch(url.toString());
      if (!response.ok) throw new Error("Ошибка при загрузке данных");

      const data = await response.json();
      if (!data || !Array.isArray(data)) throw new Error("Некорректные данные");

      setPurchases(data);
      setLastId(data.length > 0 ? data[data.length - 1].id  + 1: null);
      setHasMore(data.length === 10);
    } catch (error) {
      console.error("Ошибка:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchPurchases(null); // Загружаем первую страницу при монтировании
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
          {purchases.map((purchase) => (
            <tr key={purchase.id}>
              <td>{purchase.id}</td>
              <td>{purchase.customerName}</td>
              <td>{new Date(purchase.purchaseDate).toLocaleString()}</td>
            </tr>
          ))}
        </tbody>
      </table>

      {!isLoading && (
        <button
          onClick={() => fetchPurchases((lastId ?? 0)-20)}
          disabled={(lastId ?? 0) <= 11 || isLoading}
        >
          Предыдущие
        </button>
      )}
      {hasMore && !isLoading && (
        <button
          onClick={() => fetchPurchases(lastId)}
        >
          Следующие
        </button>
      )}
    </div>
  );
};

export default Purchases;
