import { Link } from 'react-router-dom';
import { useCart } from '../CartContext'; // Импортируем хук
import { useEffect } from 'react';
import './css/Header.css';

function Header() {
  const { totalQuantity } = useCart(); // Получаем количество товаров из контекста

  // Загрузка количества товаров из localStorage при инициализации
  useEffect(() => {
    const savedCartItemCount = localStorage.getItem('totalQuantity');
    if (savedCartItemCount) {
      // Если есть сохранённое значение, устанавливаем его
      localStorage.setItem('totalQuantity', savedCartItemCount);
    } else {
      // Если нет сохранённого значения, устанавливаем из контекста
      localStorage.setItem('totalQuantity', totalQuantity.toString());
    }
  }, [totalQuantity]); // Обновляем значение при изменении totalQuantity

  return (
    <header className="header">
      <nav>
        <ul>
          <li><Link to="/">Главная</Link></li>
          <li><Link to="/catalog">Каталог</Link></li>
          <li><Link to="/orders">История покупок</Link></li>
          <li><Link to="/about">О нас</Link></li>
        </ul>
      </nav>
      {/* Кнопка корзины */}
      <div className="cart-container">
        <Link to="/cart" className="cart-link">
          <span className="cart-icon"></span>
          <span className="cart-text">Корзина</span>
          <span className="cart-count">{totalQuantity}</span>
        </Link>
      </div>
    </header>
  );
}

export default Header;
