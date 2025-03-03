import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import './ProductPage.css';
import { useConfig } from '../ConfigContext'; // Импортируем хук

// Интерфейс для описания структуры товара
interface Product {
  id: string;
  name: string;
  price: number;
  description: string;
  characteristics?: { [key: string]: string }; // Характеристики товара, где ключ — строка, а значение — строка
}

function ProductPage() {
  const { id } = useParams(); // Получаем id из URL
  const [product, setProduct] = useState<Product | null>(null); // Типизируем состояние
  const [loading, setLoading] = useState(true);
  const { serverUrl } = useConfig(); // Получаем значение переменной окружения

  useEffect(() => {
    fetch(`${serverUrl}/lapland/product/${id}`) // Подставь свой URL
      .then((res) => res.json())
      .then((data) => {
        setProduct(data);
        setLoading(false);
      })
      .catch((error) => console.error("Ошибка загрузки товара:", error));
  }, [id]);

  if (loading) return <p>Загрузка...</p>;
  if (!product) return <p>Товар не найден.</p>;

  return (
    <div>
      <h1>{product.name}</h1>
      <p>Цена: {product.price} ₽</p>
      <p>Описание: {product.description}</p>
      {product.characteristics && Object.keys(product.characteristics).length > 0 && (
        <table className="characteristics-table">
          <tbody>
            {Object.entries(product.characteristics).map(([key, value]) => (
              <tr key={key}>
                <td className="char-key">{key}</td>
                <td className="char-value">{value}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default ProductPage;
