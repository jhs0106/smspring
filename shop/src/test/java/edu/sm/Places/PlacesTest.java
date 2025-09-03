package edu.sm.Places;

import edu.sm.app.dto.Places;
import edu.sm.app.dto.Search;
import edu.sm.app.repository.PlacesRepository;
import edu.sm.app.service.PlacesService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
@SpringBootTest
@Slf4j
public class PlacesTest {
    @Autowired
    PlacesService placesService;

    @Test
    void contextLoads() {
        try{
            // 1. 검색 조건을 담을 Search 객체 생성
            Search search = new Search();

            // 2. 검색에 필요한 값 설정
            search.setAddr("탕정면"); // 주소에 포함될 단어
            search.setType(10); // 카테고리
            List<Places> list = placesService.findByAddrAndType(search);
            list.forEach((data)->log.info(data.toString()));

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
