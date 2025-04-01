package ru.mathemator.lapland.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.mathemator.lapland.entity.Order;

public interface OrderRepository extends JpaRepository<Order, Long> {
    Slice<Order> findByIdGreaterThanOrderByIdAsc(Integer orderId, Pageable pageable);

    @Query("""
            from Order p
              join fetch p.customer c
            where p.id > :lastId
            order by p.id asc
            limit :size
            """)
    Slice<Order> findByIdGreaterThanOrderByIdAsc(Integer lastId, int size);

}
