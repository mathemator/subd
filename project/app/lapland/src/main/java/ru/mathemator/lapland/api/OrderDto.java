package ru.mathemator.lapland.api;

import lombok.*;
import lombok.experimental.Accessors;

import java.time.Instant;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@Accessors(chain = true)
@Builder(toBuilder = true)
public class OrderDto {

    private Long id;
    private String customerName;
    private Instant orderDate;

}
