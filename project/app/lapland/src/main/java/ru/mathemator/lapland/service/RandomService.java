package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ru.mathemator.lapland.api.PurchaseDto;
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

    private final PurchaseRepository purchaseRepository;
    private final PurchaseItemRepository purchaseItemRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final InventoryRepository inventoryRepository;
    private final CustomerRepository customerRepository;
    private final ShopRepository shopRepository;

    public List<Purchase> getAllPurchases() {
        return purchaseRepository.findAll();
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }



    @Transactional
    public PurchaseDto makeRandomPurchase() {
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
        Purchase purchase = Purchase.builder()
                .purchaseDate(Instant.now())
                .customer(customer)
                .shop(shop)
                .totalAmount(price)
                .build();
        Purchase savedPurchase = purchaseRepository.save(purchase);

        PurchaseItem purchaseItem = PurchaseItem.builder()
                .id(PurchaseItemId.builder()
                        .purchaseId(savedPurchase.getId())
                        .productId(product.getId()).build())
                .quantity(quantity)
                .purchase(savedPurchase)
                .product(product)
                .build();
        purchaseItemRepository.save(purchaseItem);
        inventory.setQuantity(inventory.getQuantity() - quantity);
        inventoryRepository.save(inventory);

        return PurchaseDto.builder().id(savedPurchase.getId()).build();
    }
}
