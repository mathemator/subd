package ru.mathemator.lapland;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.mathemator.lapland.api.CartItemDto;
import ru.mathemator.lapland.api.OrderDto;
import ru.mathemator.lapland.api.ProductDto;
import ru.mathemator.lapland.entity.Customer;
import ru.mathemator.lapland.service.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/lapland")
@RequiredArgsConstructor
@Slf4j
public class LaplandController {

    @Autowired
    private HttpSession session;

    private final RandomService randomService;
    private final CustomerService customerService;
    private final ProductService productService;
    private final CartService cartService;
    private final OrderService orderService;
    private final CheckoutService checkoutService;

    @GetMapping("/")
    public String index() {
        return "Hello, Lapland!";
    }

    @GetMapping("/product/{id}")
    public ProductDto product(@PathVariable Integer id) {
        return productService.getProduct(id);
    }

    @GetMapping("/orders")
    public List<OrderDto> getOrders(
            @RequestParam(required = false) Integer lastId,
            @RequestParam(defaultValue = "10") int size) {

        return orderService.getOrderPage(lastId, size);
    }

    @GetMapping("/products")
    public Page<ProductDto> getProducts(@RequestParam(defaultValue = "0") int page,
                                        @RequestParam(defaultValue = "10") int size) {
        return productService.getProductsPage(page, size);
    }

    @PostMapping("/make-random-order")
    public ResponseEntity<OrderDto> makRandomOrder() {
        log.info("Запрос на создание случайной покупки");
        OrderDto orderDto = randomService.makeRandomOrder();
        log.info("Запрос на создание случайной покупки выполнен");
        return ResponseEntity.ok()
                .body(orderDto);
    }

    // Добавление продукта в корзину
    @PostMapping("cart/add/{productId}")
    public ResponseEntity<String> addToCart(@PathVariable Integer productId) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        cart.put(productId, cart.getOrDefault(productId, 0) + 1); // Увеличиваем количество товара
        session.setAttribute("cart", cart);

        return ResponseEntity.ok("Товар добавлен в корзину");
    }

    // Добавление продукта в корзину
    @PostMapping("cart/remove/{productId}")
    public ResponseEntity<String> removeFromCart(@PathVariable Integer productId) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
        }

        cart.remove(productId); // Увеличиваем количество товара
        session.setAttribute("cart", cart);

        return ResponseEntity.ok("Товар удалён из корзины");
    }

    // Получение корзины
    @GetMapping("cart/view")
    public ResponseEntity<Map<String, CartItemDto>> viewCart() {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        return ResponseEntity.ok(cartService.getCart(cart));
    }

    // Получение корзины
    @GetMapping("cart/count")
    public ResponseEntity<Integer> cartCount() {
        Map<Long, Integer> cart = (Map<Long, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }
        return ResponseEntity.ok(cart.size());
    }

    @PostMapping("login/{id}")
    public ResponseEntity<String> login(@PathVariable Integer id) {

        Customer byId = customerService.getById(id);
        if(byId == null){
            return ResponseEntity.badRequest().body("Пользователь не найден");
        } else {
            session.setAttribute("loginId", id);
            return ResponseEntity.ok("Здравствуйте, " + byId.getName() + "!");
        }
    }

    // Очистка корзины
    @PostMapping("cart/checkout")
    public ResponseEntity<String> clearCart() {
        if(session.getAttribute("loginId") == null) {
            return ResponseEntity.badRequest().body("Вы не авторизованы");
        } else {
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if(cart == null || cart.isEmpty()){
                return ResponseEntity.badRequest().body("Корзина пуста");
            }
            checkoutService.checkout(cart, (Integer) session.getAttribute("loginId"));
            session.removeAttribute("cart");
        }
        return ResponseEntity.ok("Поздравляем, ваш заказ оформлен!");
    }
}
