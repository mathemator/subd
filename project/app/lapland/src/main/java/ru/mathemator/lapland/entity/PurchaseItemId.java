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
public class PurchaseItemId implements Serializable {
    private static final long serialVersionUID = -4707075457440322883L;
    @Column(name = "purchase_id", nullable = false)
    private Long purchaseId;

    @Column(name = "product_id", nullable = false)
    private Integer productId;

}