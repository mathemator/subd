import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useConfig } from '../ConfigContext'; // Импортируем хук

// Интерфейс для описания структуры товара
interface Product {
  id: string;
  name: string;
  price: number;
}

// Интерфейс для описания структуры ответа с API
interface ProductPageData {
  content: Product[];  // Список товаров на странице
  totalPages: number;  // Общее количество страниц
}

const Catalog = () => {
  const [products, setProducts] = useState<Product[]>([]); // Типизируем состояние товаров
  const [page, setPage] = useState<number>(0); // Типизируем состояние страницы
  const [totalPages, setTotalPages] = useState<number>(1); // Типизируем состояние общего числа страниц
  const navigate = useNavigate(); // используем хук для навигации
  const { serverUrl } = useConfig(); // Получаем значение переменной окружения

  const handleRowClick = (id: string) => {
    navigate(`/product/${id}`); // переходим на страницу товара по id
  };

  useEffect(() => {
    fetch(`${serverUrl}/lapland/products?page=${page}&size=10`)
      .then((response) => response.json())
      .then((data: ProductPageData) => { // Типизируем ответ от API
        setProducts(data.content);
        setTotalPages(data.totalPages);
      })
      .catch((error) => console.error("Ошибка загрузки товаров:", error));
  }, [page, serverUrl]); // Добавляем зависимость от serverUrl для корректного использования

  const handlePageChange = (newPage: number) => {
    if (newPage >= 0 && newPage < totalPages) {
      setPage(newPage);
    }
  };

  return (
    <div>
      <h1>Каталог товаров</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Название</th>
            <th>Цена</th>
          </tr>
        </thead>
        <tbody>
          {products.map((product) => (
            <tr
              key={product.id}
              onClick={() => handleRowClick(product.id)}
              style={{ cursor: 'pointer' }}
            >
              <td>{product.id}</td>
              <td>{product.name}</td>
              <td>{product.price}</td>
            </tr>
          ))}
        </tbody>
      </table>
      <div>
        <button onClick={() => handlePageChange(page - 1)} disabled={page <= 0}>
          Предыдущая
        </button>
        <span>Страница {page + 1} из {totalPages}</span>
        <button onClick={() => handlePageChange(page + 1)} disabled={page >= totalPages - 1}>
          Следующая
        </button>
      </div>
    </div>
  );
};

export default Catalog;
