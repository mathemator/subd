package ru.mathemator.lapland.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.Category;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}
