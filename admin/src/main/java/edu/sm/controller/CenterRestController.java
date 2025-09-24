package edu.sm.controller;


import edu.sm.app.dto.Cust;
import edu.sm.app.dto.CustSearch;
import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch;
import edu.sm.app.service.CustService;
import edu.sm.app.service.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Random;

@RestController
@Slf4j
@RequiredArgsConstructor
public class CenterRestController {
    final CustService custService;
    final ProductService productService;

    @RequestMapping("/areachart")
    public Object areachart() throws Exception {
        JSONArray jsonArray = new JSONArray();
        Random r = new Random();
        for(int i = 0; i < 12; i++){
            jsonArray.add(r.nextInt(33)+1);
        }
        return jsonArray;

    }

    @RequestMapping("/piechart")
    public Object piechart() throws Exception {
        JSONArray jsonArray2 = new JSONArray();
        Random r = new Random();
        for(int i = 0; i < 3; i++){
            jsonArray2.add(r.nextInt(100)+1);
        }
        return jsonArray2;

    }

}
