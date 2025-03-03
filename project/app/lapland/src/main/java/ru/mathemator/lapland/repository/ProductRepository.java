package ru.mathemator.lapland.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.mathemator.lapland.entity.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    Page<Product> findAll(Pageable pageable);
}
