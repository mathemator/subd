package ru.mathemator.lapland.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.Accessors;

import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(name = "shop", schema = "business")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@Setter
@Accessors(chain = true)
@Builder(toBuilder = true)
public class Shop {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "name", nullable = false, length = Integer.MAX_VALUE)
    private String name;

    @Column(name = "location", nullable = false, length = Integer.MAX_VALUE)
    private String location;

    @OneToMany(mappedBy = "shop")
    @JsonIgnore
    private Set<Inventory> inventories = new LinkedHashSet<>();

    @OneToMany(mappedBy = "shop")
    @JsonIgnore
    private Set<Purchase> purchases = new LinkedHashSet<>();
}