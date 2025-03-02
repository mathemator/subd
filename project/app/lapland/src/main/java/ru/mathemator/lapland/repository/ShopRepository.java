package ru.mathemator.lapland.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.Shop;

public interface ShopRepository extends JpaRepository<Shop, Long> {
}
