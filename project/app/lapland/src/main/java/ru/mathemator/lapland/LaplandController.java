package ru.mathemator.lapland;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import ru.mathemator.lapland.api.ProductDto;
import ru.mathemator.lapland.api.OrderDto;
import ru.mathemator.lapland.service.ProductService;
import ru.mathemator.lapland.service.OrderService;
import ru.mathemator.lapland.service.RandomService;

import java.util.List;

@RestController
@RequestMapping("/lapland")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
@Slf4j
public class LaplandController {

    private final RandomService randomService;
    private final ProductService productService;
    private final OrderService orderService;

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
}
