package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Order {
    int orderId;
    int productId;
    int cateId;
    LocalDateTime orderDate;
    int orderQt;
}
