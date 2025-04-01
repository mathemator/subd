package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.mathemator.lapland.api.OrderDto;
import ru.mathemator.lapland.entity.*;
import ru.mathemator.lapland.repository.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.*;

@Service
@RequiredArgsConstructor
public class CheckoutService {

    Random random = new Random();

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final InventoryRepository inventoryRepository;
    private final CustomerRepository customerRepository;
    private final ShopRepository shopRepository;

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }


    @Transactional
    public OrderDto checkout(Map<Integer, Integer> cart, Integer loginId) {
        Customer customer = customerRepository.findById(Long.valueOf(loginId)).orElseThrow(() -> new RuntimeException("No such customer"));

        List<Shop> allShops = shopRepository.findAll();
        Shop shop = allShops.get(random.nextInt(allShops.size()));

        Set<Inventory> inventories = shop.getInventories();

        BigDecimal price = BigDecimal.ZERO;

        Map<Product, Integer> map = new HashMap<>();

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Inventory inventory = inventories.stream().filter(i -> i.getProduct().getId().equals(entry.getKey()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("No such product"));
            if (inventory.getQuantity() - entry.getValue() < 0) {
                throw new RuntimeException("Not enough inventory");
            }

            Product product = inventory.getProduct();
            Double multiplier =
                    switch (customer.getLoyaltyStatus()) {
                        case BRONZE -> 0.97;
                        case SILVER -> 0.95;
                        case GOLD -> 0.93;
                    };

            price = price.add(product.getPrice().multiply(BigDecimal.valueOf(entry.getValue()))
                    .multiply(new BigDecimal(multiplier)));

            inventory.setQuantity(inventory.getQuantity() - entry.getValue());
            inventoryRepository.save(inventory);
            map.put(product, entry.getValue());
        }

        Order order = Order.builder()
                .orderDate(Instant.now())
                .customer(customer)
                .shop(shop)
                .totalAmount(price)
                .build();

        Order savedOrder = orderRepository.save(order);

        for (Map.Entry<Product, Integer> entry : map.entrySet()) {
            OrderItem orderItem = OrderItem.builder()
                    .id(OrderItemId.builder()
                            .orderId(savedOrder.getId())
                            .productId(entry.getKey().getId()).build())
                    .quantity(entry.getValue())
                    .order(savedOrder)
                    .product(entry.getKey())
                    .build();
            orderItemRepository.save(orderItem);
        }

        return OrderDto.builder().id(savedOrder.getId()).build();
    }
}
