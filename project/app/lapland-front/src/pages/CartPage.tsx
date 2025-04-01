import { useState, useEffect } from 'react';
import { useConfig } from '../ConfigContext';
import { useCart } from "../CartContext"; // Импортируем контекст
import './css/CartPage.css';

interface ProductDto {
  id: number;
  name: string;
  price: string;
}

interface CartItemDto {
  product: ProductDto;
  quantity: number;
}

function CartPage() {
  const { serverUrl } = useConfig();
  const [message, setMessage] = useState('');
  const [cart, setCart] = useState<Map<string, CartItemDto>>(new Map());
  const { items, setItems, setTotalQuantity, removeItemFromCart } = useCart(); // Получаем необходимые функции из контекста

  // Загружаем корзину при монтировании компонента
  useEffect(() => {
    fetch(`${serverUrl}/lapland/cart/view`, {
      credentials: "include"
    })
      .then((response) => response.json())
      .then((data) => {
        const cartItems = new Map<string, CartItemDto>();
        let totalItems = 0;

        Object.entries(data as Record<string, CartItemDto>).forEach(([productName, cartItem]: [string, CartItemDto]) => {
          const { product, quantity } = cartItem;
          cartItems.set(productName, { product, quantity });
          totalItems += cartItem.quantity;
        });

        setCart(cartItems);
        setTotalQuantity(totalItems);
      })
      .catch((error) => console.error("Ошибка загрузки корзины:", error));
  }, [serverUrl, setTotalQuantity]);

  // Подсчитываем итоговую стоимость
  const totalPrice = Array.from(cart.values()).reduce((total, { product, quantity }) => {
    return total + (parseFloat(product.price) * quantity);
  }, 0);

  // Функция для удаления товара из корзины
  const removeItem = async (id: number) => {
    // Находим товар в корзине
    const productToRemove = items.find((item) => String(item.id) == String(id));

    if (productToRemove) {
      // Удаляем товар из корзины
      const updatedCart = items.filter((item) => String(item.id) !== String(id));
      removeItemFromCart(productToRemove.id)

      // Обновляем общее количество товаров в корзине
      const newTotalQuantity = updatedCart.reduce((total, item) => total + item.quantity, 0);
      setTotalQuantity(newTotalQuantity);

      const updatedUiCart = new Map(cart);
      updatedUiCart.delete(productToRemove.name); // Удаляем товар по имени
      setCart(updatedUiCart); // Обновляем состояние
        // Обновляем общее количество товаров в корзине
//         setTotalQuantity(updatedCart.size);
      // Делаем запрос на сервер для удаления товара
      try {
        const response = await fetch(`${serverUrl}/lapland/cart/remove/${productToRemove.id}`, {
          method: 'POST',
          credentials: "include",
          headers: {
            'Content-Type': 'application/json',
          },
        });

        if (response.ok) {
          console.log(`Товар "${productToRemove.name}" успешно удалён из корзины на сервере.`);
        } else {
          console.error('Ошибка при удалении товара с сервера');
        }
      } catch (error) {
        console.error('Ошибка при выполнении запроса', error);
      }
    } else {
      console.error('Товар не найден в корзине');
    }
  };

  const handlePurchase = async () => {
    try {
      const response = await fetch(`${serverUrl}/lapland/cart/checkout`, {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (response.ok) {
          console.log(response)
        const result = await response.text(); // Получаем ответ сервера
        setItems([]); // Очищаем корзину в интерфейсе
        setTotalQuantity(0);
        setCart(new Map());
        setMessage(`Покупка успешна: ${result}`);
      } else {
        setMessage("Ошибка при оформлении покупки.");
      }
    } catch (error) {
      console.log(error);
      setMessage("Ошибка сети. Попробуйте снова.");
    }
  };

  return (
    <div>
      <h1>Корзина</h1>
      {cart.size === 0 ? (
        <p>Корзина пуста</p>
      ) : (
        <>
          <div>
            {Array.from(cart.entries()).map(([_, { product, quantity }]) => (
              <div key={product.id} className="cart-item">
                <h2>{product.name}</h2>
                <p>Цена: {product.price} ₽</p>
                <p>Количество: {quantity}</p>
                <button onClick={() => removeItem(product.id)}>Удалить</button>
              </div>
            ))}
          </div>
          <div className="total-price">
            <h3>Итого: {totalPrice.toFixed(2)} ₽</h3>
          </div>
          <button onClick={handlePurchase} className="buy-button">
            Купить
          </button>
        </>
      )}
      <p>{message}</p>
    </div>
  );
}

export default CartPage;
