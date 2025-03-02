package ru.mathemator.lapland.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import ru.mathemator.lapland.entity.PurchaseItem;

public interface PurchaseItemRepository extends JpaRepository<PurchaseItem, Integer> {


    Slice<PurchaseItem> findByIdPurchaseId(Integer purchaseId, Pageable pageable);
}
