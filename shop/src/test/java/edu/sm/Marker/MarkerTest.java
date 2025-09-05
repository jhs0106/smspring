package edu.sm.Marker;

import edu.sm.app.dto.Marker;
import edu.sm.app.repository.MarkerRepository;
import edu.sm.app.service.MarkerService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
@SpringBootTest
@Slf4j
public class MarkerTest {
    @Autowired
    MarkerService markerService;

    @Test
    void contextLoads() {
        try{
            List<Marker> list = markerService.get();
            list.forEach((data)->{log.info(data.toString());});

            Marker marker = markerService.get(101);
            log.info(marker.toString());

            List<Marker> list2 = markerService.findByLoc(200);
            list2.forEach((data)->log.info(data.toString()));

        }catch(Exception e){
            e.printStackTrace();
        }
    }


//    void update() {
//        Marker marker = Marker.builder().target(108).title("서울국립중앙박물관").img("ss80.jpg").lat(37.523877).lng(126.980477).loc(100).build();
//        try {
//            markerService.modify(marker);
//            log.info("Update End ------------------------------------------");
//        } catch (Exception e) {
//            log.info("Error Test ...");
//            e.printStackTrace();
//        }
//    }
//    void get() {
//        Marker marker = null;
//        try {
//            marker= markerService.get(108);
//            if(marker != null){
//                log.info(marker.toString());
//            }
//            log.info("Select End ------------------------------------------");
//
//        } catch (Exception e) {
//            log.info("Error Test ...");
//            e.printStackTrace();
//        }
//    }

//    void getall() {
//        List<Marker> list = null;
//        try {
//            list = markerService.get();
//            list.forEach(marker -> log.info(marker.toString()));
//            log.info("Select All End ------------------------------------------");
//
//        } catch (Exception e) {
//            log.info("Error Test ...");
//            e.printStackTrace();
//        }
//    }

//    void insert() {
//        Marker marker = Marker.builder().target(108).title("서울국립중앙박물관").img("ss90.jpg").lat(37.523877).lng(126.980477).loc(100).build();
//        try {
//            markerService.register(marker);
//            log.info("Insert End ------------------------------------------");
//        } catch (Exception e) {
//            log.info("Error Insert Test ...");
//            e.printStackTrace();
//        }
//    }

}
