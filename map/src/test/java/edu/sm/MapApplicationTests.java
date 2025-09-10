package edu.sm;

import edu.sm.app.dto.Anything;
import edu.sm.app.service.AnythingService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class MapApplicationTests {

    @Autowired
    private AnythingService anythingservice;

    @Test
    void findByAddressTest() { // 테스트 메소드 이름을 명확하게 변경
        try {
            // 1. 검색에 필요한 주소 값 설정
            String searchAddress = "탕정면";

            // 2. 수정한 서비스 메소드 호출
            List<Anything> list = anythingservice.findByAddress(searchAddress);


            // 4. 결과 출력
            log.info("검색 결과 {}개", list.size());
            list.forEach((data) -> log.info(data.toString()));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

