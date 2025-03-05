package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.mathemator.lapland.api.OrderDto;
import ru.mathemator.lapland.repository.OrderItemRepository;
import ru.mathemator.lapland.repository.OrderRepository;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderItemRepository orderItemRepository;
    private final OrderRepository orderRepository;

    public List<OrderDto> getOrderPage(Integer lastId, int size) {
        lastId = lastId == null ? 0 : lastId;
        return orderRepository.findByIdGreaterThanOrderByIdAsc(lastId, size)
                .map(p -> OrderDto.builder()
                        .id(p.getId())
                        .customerName(p.getCustomer().getName())
                        .orderDate(p.getOrderDate())
                        .build())
                .toList();
    }

//    public Slice<OrderItemDto> getOrderPage(Integer orderId, int page, int size) {
//
//        Pageable pageable = PageRequest.of(page, size);
//        return orderItemRepository.findByIdOrderId(orderId, pageable)
//                .map(p -> OrderItemDto.builder()
//                        .id(p.getId().getOrderId())
//                        .name(p.getProduct().getName())
//                        .customerName(p.getOrder().getCustomer().getName())
//                        .orderDate(p.getOrder().getOrderDate())
//                        .build());
//    }
}
