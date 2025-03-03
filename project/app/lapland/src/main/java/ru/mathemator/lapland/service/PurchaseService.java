package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.mathemator.lapland.api.PurchaseDto;
import ru.mathemator.lapland.repository.PurchaseItemRepository;
import ru.mathemator.lapland.repository.PurchaseRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PurchaseService {

    private final PurchaseItemRepository purchaseItemRepository;
    private final PurchaseRepository purchaseRepository;

    public List<PurchaseDto> getPurchasePage(Integer lastId, int size) {
        lastId = lastId == null ? 0 : lastId;
        return purchaseRepository.findByIdGreaterThanOrderByIdAsc(lastId, size)
                .map(p -> PurchaseDto.builder()
                        .id(p.getId())
                        .customerName(p.getCustomer().getName())
                        .purchaseDate(p.getPurchaseDate())
                        .build())
                .toList();
    }

//    public Slice<PurchaseItemDto> getPurchasePage(Integer purchaseId, int page, int size) {
//
//        Pageable pageable = PageRequest.of(page, size);
//        return purchaseItemRepository.findByIdPurchaseId(purchaseId, pageable)
//                .map(p -> PurchaseItemDto.builder()
//                        .id(p.getId().getPurchaseId())
//                        .name(p.getProduct().getName())
//                        .customerName(p.getPurchase().getCustomer().getName())
//                        .purchaseDate(p.getPurchase().getPurchaseDate())
//                        .build());
//    }
}
