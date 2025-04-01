import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { CartProvider } from "./CartContext";
import { ConfigProvider } from './ConfigContext'; // Импортируем провайдер
import CartPage from "./pages/CartPage"; // Импортируем компонент корзины
import Home from "./pages/Home";
import Catalog from "./pages/Catalog";
import Orders from "./pages/Orders";
import ProductPage from "./pages/ProductPage";
import About from "./pages/About";
import Header from './pages/Header'; // Подключаем компонент заголовка
import './App.css';


function App() {
  return (
    <ConfigProvider>
    <CartProvider>
      <Router>
        <Header /> {/* Добавляем компонент Header */}

        <div className="wrapper">
          <div className="sidebar-left">
            <img src="/img/dog.jpg" alt="Dog" />
          </div>

          <div className="main-content">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/catalog" element={<Catalog />} />
              <Route path="/orders" element={<Orders />} />
              <Route path="/cart" element={<CartPage />} /> {/* Новый маршрут для корзины */}
              <Route path="/product/:id" element={<ProductPage />} />
              <Route path="/about" element={<About />} />
            </Routes>
          </div>

          <div className="sidebar-right">
            <img src="/img/cat.jpg" alt="Cat" />
          </div>
        </div>

        <footer className="footer">
          <p>© Санёк, 2025</p>
        </footer>
      </Router>
      </CartProvider>
    </ConfigProvider>
  );
}

export default App;
