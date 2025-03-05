package ru.mathemator.lapland.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.OrderItem;

public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {


    Slice<OrderItem> findByIdOrderId(Integer orderId, Pageable pageable);
}
