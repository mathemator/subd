import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Home from "./pages/Home";
import Catalog from "./pages/Catalog";
import Purchases from "./pages/Purchases";
import ProductPage from "./pages/ProductPage";
import About from "./pages/About";
import { ConfigProvider } from './ConfigContext'; // Импортируем провайдер
import './App.css';

function App() {
  return (
    <ConfigProvider>
      <Router>
        <header className="header">
          <nav>
            <ul>
              <li><Link to="/">Главная</Link></li>
              <li><Link to="/catalog">Каталог</Link></li>
              <li><Link to="/purchases">История покупок</Link></li>
              <li><Link to="/about">О нас</Link></li>
            </ul>
          </nav>
        </header>

        <div className="wrapper">
          <div className="sidebar-left">
            <img src="/img/dog.jpg" alt="Dog" />
          </div>

          <div className="main-content">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/catalog" element={<Catalog />} />
              <Route path="/purchases" element={<Purchases />} />
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
    </ConfigProvider>
  );
}

export default App;
