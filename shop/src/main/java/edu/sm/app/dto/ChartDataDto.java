package edu.sm.app.dto;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class ChartDataDto {
    private String source; // 데이터 출처 (A, B, C, D)
    private String value;  // 실제 데이터 값
}