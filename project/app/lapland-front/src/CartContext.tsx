import { createContext, useContext, useState, useEffect, ReactNode } from "react";

// Тип товара
// Типы для контекста
interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

interface CartContextType {
  items: CartItem[];
  setItems: (items: CartItem[]) => void; // ❗️ Должен быть здесь
  addItemToCart: (item: CartItem) => void;
  removeItemFromCart: (id: string) => void;
  totalQuantity: number;
  setTotalQuantity: (quantity: number) => void;
}

const CartContext = createContext<CartContextType | undefined>(undefined);

export const useCart = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within a CartProvider');
  }
  return context;
};

interface CartProviderProps {
  children: ReactNode;
}

export const CartProvider: React.FC<CartProviderProps> = ({ children }) => {
  const [items, setItems] = useState<CartItem[]>(() => {
    // Загружаем данные из localStorage при инициализации
    const storedItems = localStorage.getItem("cartItems");
    return storedItems ? JSON.parse(storedItems) : [];
  });
  const [totalQuantity, setTotalQuantity] = useState<number>(() => {
    // Загружаем количество товаров из localStorage
    const storedQuantity = localStorage.getItem("totalQuantity");
    return storedQuantity ? Number(storedQuantity) : 0;
  });

  useEffect(() => {
    // Сохраняем данные в localStorage при изменении items или totalQuantity
    localStorage.setItem("cartItems", JSON.stringify(items));
    localStorage.setItem("totalQuantity", totalQuantity.toString());
  }, [items, totalQuantity]);

  const addItemToCart = (item: CartItem) => {
      console.log("Добавляем товар в корзину:", item);
    const newItems = [...items];
    const existingItem = newItems.find((i) => i.id === item.id);
    if (existingItem) {
        console.log("Обновляем количество товара в корзине:", existingItem);
      existingItem.quantity += item.quantity;
    } else {
      newItems.push(item);
    }
    setItems(newItems);

    // Обновляем количество товаров
    const newTotalQuantity = newItems.reduce((total, item) => total + item.quantity, 0);
    console.log("Обновленное количество товаров:", newTotalQuantity);
    setTotalQuantity(newTotalQuantity);
  };

  const removeItemFromCart = (id: string) => {
    const newItems = items.filter((item) => item.id !== id);
    setItems(newItems);

    // Обновляем количество товаров
    const newTotalQuantity = newItems.reduce((total, item) => total + item.quantity, 0);
    setTotalQuantity(newTotalQuantity);
  };


  return (
    <CartContext.Provider
      value={{ items, setItems, addItemToCart, removeItemFromCart, totalQuantity, setTotalQuantity }}
    >
      {children}
    </CartContext.Provider>
  );
};
