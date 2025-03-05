package ru.mathemator.lapland.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import ru.mathemator.lapland.entity.sub.LoyaltyStatus;

import java.math.BigDecimal;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name = "customer", schema = "business", indexes = {
        @Index(name = "customer_email_key", columnList = "email", unique = true),
        @Index(name = "idx_customer_phone", columnList = "phone", unique = true)
}, uniqueConstraints = {
        @UniqueConstraint(name = "customer_phone_key", columnNames = {"phone"})
})
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@Accessors(chain = true)
@Builder(toBuilder = true)
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "bonus_points", nullable = false, precision = 10, scale = 2)
    private BigDecimal bonusPoints;

    @Column(name = "name", nullable = false, length = Integer.MAX_VALUE)
    private String name;

    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY)
    @JsonIgnore
    private Set<Order> orders = new LinkedHashSet<>();

    @Column(name = "email", columnDefinition = "email_domain")
    private String email;

    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "loyalty_status")
    private LoyaltyStatus loyaltyStatus;

    @Column(name = "phone", columnDefinition = "phone_domain")
    private String phone;

}