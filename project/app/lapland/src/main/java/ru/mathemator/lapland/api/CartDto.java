package ru.mathemator.lapland.api;

import lombok.Data;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@Data
public class CartDto {
    private Map<String, CartItemDto> items = new HashMap<>();
    private BigDecimal totalPrice = BigDecimal.ZERO;

//    public void addItem(String name, CartItemDto item) {
//        items.put(name, item);
//        totalPrice = totalPrice.add(item.price().multiply(BigDecimal.valueOf(item.quantity())));
//    }
}