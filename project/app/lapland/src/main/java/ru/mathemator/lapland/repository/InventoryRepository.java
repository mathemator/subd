package ru.mathemator.lapland.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.Inventory;

public interface InventoryRepository extends JpaRepository<Inventory, Integer> {
}
