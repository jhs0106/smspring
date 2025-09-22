package edu.sm.app.dto;

import lombok.*;

import java.util.List;


@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class MyTest {
    Long id;
    String title;
    String content;
    String writer;
    String searchType; // 검색 조건 타입 (예: title, content)
    String keyword;    // 검색 키워드
    List<Long> ids;    // 여러 ID를 담을 리스트 (foreach 테스트용)
}
