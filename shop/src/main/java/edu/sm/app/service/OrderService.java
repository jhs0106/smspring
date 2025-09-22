package edu.sm.app.service;

import edu.sm.app.dto.Order;
import edu.sm.app.repository.OrderRepository;
import edu.sm.common.frame.SmService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class OrderService implements SmService<Order, Integer> {

    final OrderRepository orderRepository;

    @Override
    public void register(Order order) throws Exception {
        orderRepository.insert(order);
    }

    @Override
    public void modify(Order order) throws Exception {
        orderRepository.update(order);
    }

    @Override
    public void remove(Integer integer) throws Exception {
        orderRepository.delete(integer);
    }

    @Override
    public List<Order> get() throws Exception {
        return orderRepository.selectAll();
    }

    @Override
    public Order get(Integer integer) throws Exception {
        return orderRepository.select(integer);
    }

    // Chart3용 - 월별 매출 합계/평균만
    public List<Map<String, Object>> getMonthlySalesSum() throws Exception {
        return orderRepository.getMonthlySalesSum();
    }

    public List<Map<String, Object>> getMonthlySalesAvg() throws Exception {
        return orderRepository.getMonthlySalesAvg();
    }

    // 카테고리별 월 매출 합계/평균
    public List<Map<String, Object>> getCategoryMonthlySalesSum() throws Exception {
        return orderRepository.getCategoryMonthlySalesSum();
    }

    public List<Map<String, Object>> getCategoryMonthlySalesAvg() throws Exception {
        return orderRepository.getCategoryMonthlySalesAvg();
    }
}