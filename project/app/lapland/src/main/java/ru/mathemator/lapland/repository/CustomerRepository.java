package ru.mathemator.lapland.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
}
