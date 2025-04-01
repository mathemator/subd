package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.mathemator.lapland.api.CartItemDto;
import ru.mathemator.lapland.api.ProductDto;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CartService {

    private final ProductService productService;

    public Map<String, CartItemDto> getCart(Map<Integer, Integer> cart) {
        if (cart == null) {
            cart = new HashMap<>();
        }

        Map<String, CartItemDto> cartDto = new HashMap<>();
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Integer productId = entry.getKey();
            Integer quantity = entry.getValue();

            ProductDto product = productService.getProduct(productId);  // Получаем продукт по ID

            CartItemDto cartItem = new CartItemDto(product, quantity);

            // Сериализуем товар в строку по имени продукта, но можно и по другому ключу
            cartDto.put(product.getName(), cartItem);  // Ключ — это название продукта
        }
        return cartDto;
    }
}
