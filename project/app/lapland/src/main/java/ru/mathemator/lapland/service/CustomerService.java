package ru.mathemator.lapland.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import ru.mathemator.lapland.entity.Customer;
import ru.mathemator.lapland.repository.CustomerRepository;

@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository customerRepository;

    public Customer getById(Integer id) {
        return customerRepository.findById(Long.valueOf(id)).orElse(null);
    }
}
