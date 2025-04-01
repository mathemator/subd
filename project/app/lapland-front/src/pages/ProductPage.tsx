import { useEffect } from "react";
import { useState } from "react";
import { useParams } from "react-router-dom";
import { useConfig } from '../ConfigContext'; // Импортируем хук
import { useCart } from '../CartContext'; // Импортируем хук
import './css/ProductPage.css';


// Интерфейс для описания структуры товара
interface Product {
  id: string;
  name: string;
  price: number;
  description: string;
  characteristics?: { [key: string]: string }; // Характеристики товара, где ключ — строка, а значение — строка
}

function ProductPage() {
  const { serverUrl } = useConfig(); // Получаем значение переменной окружения
  const { id } = useParams(); // Получаем id из URL
  const { addItemToCart } = useCart(); // Получаем функцию для добавления товара в корзину
  const [product, setProduct] = useState<Product | null>(null);
  const [isAdded, setIsAdded] = useState(false);
  const [loading, setLoading] = useState(true); // Состояние загрузки

  // Получаем данные о товаре с сервера
  useEffect(() => {
    fetch(`${serverUrl}/lapland/product/${id}`, {
      credentials: "include"
    })
      .then((res) => res.json())
      .then((data) => {
        setProduct(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Ошибка загрузки товара:", error);
        setLoading(false);
      });
  }, [id]);

  const handleAddToCart = async () => {
    if (!product) return;

    const cartItem = {
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1
    };

    // Добавляем товар в корзину через контекст
    addItemToCart(cartItem);
    setIsAdded(true); // Устанавливаем, что товар добавлен

    // Отправляем данные на сервер, чтобы обновить корзину на сервере
    try {
      const response = await fetch(`${serverUrl}/lapland/cart/add/${product.id}`, {
        method: 'POST',
        credentials: "include",
        headers: {
          'Content-Type': 'application/json',
        }
      });

      if (!response.ok) {
        console.error("Ошибка при добавлении товара на сервер");
      }
    } catch (error) {
      console.error("Произошла ошибка при отправке данных на сервер", error);
    }
  };

  if (loading) {
    return <div>Загрузка...</div>;
  }

  return (
      <div>
        <h1>{product && product.name}</h1>
        <p>Цена: {product && product.price} ₽</p>
        <p>Описание: {product && product.description}</p>
        {product && product.characteristics && Object.keys(product.characteristics).length > 0 && (
          <table className="characteristics-table">
            <tbody>
              {product && Object.entries(product.characteristics).map(([key, value]) => (
                <tr key={key}>
                  <td className="char-key">{key}</td>
                  <td className="char-value">{String(value)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        <button onClick={handleAddToCart}>
          {isAdded ? "Товар добавлен в корзину" : "Добавить в корзину"}
        </button>
      </div>
    );
}

export default ProductPage;
