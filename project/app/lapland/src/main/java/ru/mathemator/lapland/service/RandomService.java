package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.mathemator.lapland.api.OrderDto;
import ru.mathemator.lapland.entity.*;
import ru.mathemator.lapland.repository.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class RandomService {

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
    public OrderDto makeRandomOrder() {
        List<Customer> allCustomers = customerRepository.findAll();
        Customer customer = allCustomers.get(random.nextInt(allCustomers.size()));

        List<Shop> allShops = shopRepository.findAll();
        Shop shop = allShops.get(random.nextInt(allShops.size()));

        Set<Inventory> inventories = shop.getInventories();
        Inventory inventory = new ArrayList<>(inventories).get(random.nextInt(inventories.size()));
        Product product = inventory.getProduct();

        int quantity = 1;

        if (inventory.getQuantity() - quantity < 0) {
            throw new RuntimeException("Not enough inventory");
        }

        Double multiplier =
                switch (customer.getLoyaltyStatus()) {
                    case BRONZE -> 0.97;
                    case SILVER -> 0.95;
                    case GOLD -> 0.93;
                };

        BigDecimal price = product.getPrice().multiply(new BigDecimal(multiplier));
        Order order = Order.builder()
                .orderDate(Instant.now())
                .customer(customer)
                .shop(shop)
                .totalAmount(price)
                .build();
        Order savedOrder = orderRepository.save(order);

        OrderItem orderItem = OrderItem.builder()
                .id(OrderItemId.builder()
                        .orderId(savedOrder.getId())
                        .productId(product.getId()).build())
                .quantity(quantity)
                .order(savedOrder)
                .product(product)
                .build();
        orderItemRepository.save(orderItem);
        inventory.setQuantity(inventory.getQuantity() - quantity);
        inventoryRepository.save(inventory);

        return OrderDto.builder().id(savedOrder.getId()).build();
    }
}
