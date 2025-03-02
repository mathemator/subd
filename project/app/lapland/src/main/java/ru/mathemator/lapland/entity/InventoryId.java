package ru.mathemator.lapland.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;

@EqualsAndHashCode
@Embeddable
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@Accessors(chain = true)
@Builder(toBuilder = true)
public class InventoryId implements Serializable {
    private static final long serialVersionUID = -4091997025495495767L;
    @Column(name = "shop_id", nullable = false)
    private Integer shopId;

    @Column(name = "product_id", nullable = false)
    private Integer productId;
}