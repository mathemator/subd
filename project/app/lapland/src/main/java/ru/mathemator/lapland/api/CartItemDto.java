package ru.mathemator.lapland.api;

public record CartItemDto(
    ProductDto product,
    Integer quantity) {};