package edu.sm.controller;

import edu.sm.app.dto.Anything;
import edu.sm.app.service.AnythingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MapRestController {
    final AnythingService anythingService;
    private double lat;
    private double lng;

    @RequestMapping("/getshop")
    public Object getshop(@RequestParam("lat") double lat, @RequestParam("lng") double lng) throws Exception{
        List<Anything> Shops = anythingService.findShopsWithinRadius(lat, lng, 3.0);

        return Shops;
    }


}
