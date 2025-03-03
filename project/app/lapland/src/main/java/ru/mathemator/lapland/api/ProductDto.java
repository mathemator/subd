package ru.mathemator.lapland.api;

import lombok.*;
import lombok.experimental.Accessors;

import java.math.BigDecimal;
import java.util.Map;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@Accessors(chain = true)
@Builder(toBuilder = true)
public class ProductDto {

    private Integer id;

    private String name;

    private BigDecimal price;

    private String description;

    private Map<String, Object> characteristics;

}
