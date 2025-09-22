package edu.sm.app.repository;

import edu.sm.app.dto.Order;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface OrderRepository extends SmRepository<Order, Integer> {
    // Chart3용 - 월별 매출 합계/평균
    List<Map<String, Object>> getMonthlySalesSum() throws Exception;
    List<Map<String, Object>> getMonthlySalesAvg() throws Exception;

    // 카테고리별 월 매출 합계/평균
    List<Map<String, Object>> getCategoryMonthlySalesSum() throws Exception;
    List<Map<String, Object>> getCategoryMonthlySalesAvg() throws Exception;
}