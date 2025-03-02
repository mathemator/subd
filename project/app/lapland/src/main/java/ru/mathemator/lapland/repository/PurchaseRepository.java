package ru.mathemator.lapland.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ru.mathemator.lapland.entity.Purchase;

public interface PurchaseRepository extends JpaRepository<Purchase, Long> {
    Slice<Purchase> findByIdGreaterThanOrderByIdAsc(Integer purchaseId, Pageable pageable);

    @Query("""
            from Purchase p
              join fetch p.customer c
            where p.id > :lastId
            order by p.id asc
            limit :size
            """)
    Slice<Purchase> findByIdGreaterThanOrderByIdAsc(Integer lastId, int size);

}
