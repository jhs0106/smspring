package edu.sm.controller;

import edu.sm.app.dto.Marker;
import edu.sm.app.dto.Places; // Places DTO 추가
import edu.sm.app.dto.Search;  // Search DTO 추가
import edu.sm.app.service.MarkerService;
import edu.sm.app.service.PlacesService; // PlacesService 추가
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List; // List 추가
import java.util.Map;
import java.util.Random;

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/map")
public class MapController {
    final MarkerService markerService;
    final PlacesService placesService;

    String dir = "map/";



    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir+"center");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/go")
    public String go(Model model, @RequestParam("target") int target) throws Exception {
        Marker marker = null;
        marker = markerService.get(target);
        model.addAttribute("marker", marker);
        model.addAttribute("center", dir+"go");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/map1")
    public String map1(Model model) {
        model.addAttribute("center", dir+"map1");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/map2")
    public String map2(Model model) {
        model.addAttribute("center", dir+"map2");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/map3")
    public String map3(Model model) {
        model.addAttribute("center", dir+"map3");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/map4")
    public String map4(Model model) {
        model.addAttribute("center", dir+"map4");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/map5")
    public String map5(Model model) {
        model.addAttribute("center", dir+"map5");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/map6")
    public String map6(Model model) {
        model.addAttribute("center", dir+"map6");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/map7")
    public String map7(Model model) {
        model.addAttribute("center", dir+"map7");
        model.addAttribute("left", dir+"left");
        return "index";
    }
    @RequestMapping("/map8")
    public String map8(Model model) {
        model.addAttribute("center", dir+"map8");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @GetMapping("/randommarker")
    @ResponseBody // 중요! JSP 뷰를 찾지 않고, 리턴된 객체를 JSON 데이터로 변환하여 응답합니다.
    public Map<String, Double> getRandomMarker() {
        Map<String, Double> markerData = new HashMap<>();
        Random random = new Random();

        // 대한민국의 대략적인 위도, 경도 범위 내에서 랜덤 값 생성
        // 위도(latitude): 33.0 ~ 38.0
        double lat = 33.0 + (38.0 - 33.0) * random.nextDouble();
        // 경도(longitude): 126.0 ~ 129.0
        double lng = 126.0 + (129.0 - 126.0) * random.nextDouble();

        markerData.put("lat", lat);
        markerData.put("lng", lng);

        return markerData;
    }

}