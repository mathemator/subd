package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import ru.mathemator.lapland.api.ProductDto;
import ru.mathemator.lapland.repository.ProductRepository;

@Service
@RequiredArgsConstructor
public class ProductService {

    private final ProductRepository productRepository;

    public ProductDto getProduct(Integer id) {
        return productRepository.findById(id)
                .map(p -> ProductDto.builder()
                        .id(p.getId())
                        .name(p.getName())
                        .price(p.getPrice())
                        .description(p.getDescription())
                        .characteristics(p.getCharacteristics())
                        .build()).orElseThrow();
    }

    public Page<ProductDto> getProductsPage(int page, int size) {

        Pageable pageable = PageRequest.of(page, size);
        return productRepository.findAll(pageable)
                .map(p -> ProductDto.builder()
                        .id(p.getId())
                        .name(p.getName())
                        .price(p.getPrice())
                        .build());
    }
}
