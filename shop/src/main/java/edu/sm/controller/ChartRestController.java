package edu.sm.controller;


import com.opencsv.CSVReader;
import edu.sm.app.service.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ChartRestController {
    final OrderService  orderService;

    @Value("${app.dir.logsdirRead}")
    String dir;

    @RequestMapping("/chart3_category_Sum")
    public Object chart3CategorySum() throws Exception {
        JSONObject result = new JSONObject();

        List<Map<String, Object>> data = orderService.getCategoryMonthlySalesSum();

        // 월 순서를 보장하기 위한 맵
        Map<String, Integer> monthOrder = new HashMap<>();
        monthOrder.put("January", 1); monthOrder.put("February", 2); monthOrder.put("March", 3);
        monthOrder.put("April", 4); monthOrder.put("May", 5); monthOrder.put("June", 6);
        monthOrder.put("July", 7); monthOrder.put("August", 8); monthOrder.put("September", 9);
        monthOrder.put("October", 10); monthOrder.put("November", 11); monthOrder.put("December", 12);

        // 카테고리별 월별 데이터 저장
        Map<String, Map<String, Number>> categoryMonthData = new HashMap<>();
        Set<String> allMonths = new TreeSet<>((a, b) ->
                monthOrder.getOrDefault(a, 0).compareTo(monthOrder.getOrDefault(b, 0)));

        for(Map<String, Object> item : data) {
            String categoryName = (String) item.get("cate_name");
            String monthName = (String) item.get("month_name");
            Number sales = (Number) item.get("total_sales");

            allMonths.add(monthName);

            if(!categoryMonthData.containsKey(categoryName)) {
                categoryMonthData.put(categoryName, new HashMap<>());
            }
            categoryMonthData.get(categoryName).put(monthName, sales);
        }

        // 시리즈 데이터 생성
        JSONArray series = new JSONArray();
        for(String category : categoryMonthData.keySet()) {
            JSONObject seriesItem = new JSONObject();
            seriesItem.put("name", category);

            JSONArray categoryData = new JSONArray();
            for(String month : allMonths) {
                Number value = categoryMonthData.get(category).get(month);
                categoryData.add(value != null ? value : 0);
            }
            seriesItem.put("data", categoryData);
            series.add(seriesItem);
        }

        JSONArray categories = new JSONArray();
        categories.addAll(allMonths);

        result.put("categories", categories);
        result.put("series", series);

        return result;
    }

    @RequestMapping("/chart3_category_Avg")
    public Object chart3CategoryAvg() throws Exception {
        JSONObject result = new JSONObject();

        List<Map<String, Object>> data = orderService.getCategoryMonthlySalesAvg();

        // 월 순서를 보장하기 위한 맵
        Map<String, Integer> monthOrder = new HashMap<>();
        monthOrder.put("January", 1); monthOrder.put("February", 2); monthOrder.put("March", 3);
        monthOrder.put("April", 4); monthOrder.put("May", 5); monthOrder.put("June", 6);
        monthOrder.put("July", 7); monthOrder.put("August", 8); monthOrder.put("September", 9);
        monthOrder.put("October", 10); monthOrder.put("November", 11); monthOrder.put("December", 12);

        // 카테고리별 월별 데이터 저장
        Map<String, Map<String, Number>> categoryMonthData = new HashMap<>();
        Set<String> allMonths = new TreeSet<>((a, b) ->
                monthOrder.getOrDefault(a, 0).compareTo(monthOrder.getOrDefault(b, 0)));

        for(Map<String, Object> item : data) {
            String categoryName = (String) item.get("cate_name");
            String monthName = (String) item.get("month_name");
            Number avgSales = (Number) item.get("avg_sales");

            allMonths.add(monthName);

            if(!categoryMonthData.containsKey(categoryName)) {
                categoryMonthData.put(categoryName, new HashMap<>());
            }
            categoryMonthData.get(categoryName).put(monthName, avgSales);
        }

        // 시리즈 데이터 생성
        JSONArray series = new JSONArray();
        for(String category : categoryMonthData.keySet()) {
            JSONObject seriesItem = new JSONObject();
            seriesItem.put("name", category);

            JSONArray categoryData = new JSONArray();
            for(String month : allMonths) {
                Number value = categoryMonthData.get(category).get(month);
                categoryData.add(value != null ? value : 0);
            }
            seriesItem.put("data", categoryData);
            series.add(seriesItem);
        }

        JSONArray categories = new JSONArray();
        categories.addAll(allMonths);

        result.put("categories", categories);
        result.put("series", series);

        return result;
    }

    @RequestMapping("/chart2_1")
    public Object chart2_1() throws Exception{
        //[[],[]]
        JSONArray jsonArray = new JSONArray();
        String [] nation = {"Kor", "Eng", "Jap", "Chn", "Usa"};
        Random random = new Random();
        for(int i=0; i<nation.length; i++){
            JSONArray jsonArray1 = new JSONArray();
            jsonArray1.add(nation[i]);
            jsonArray1.add(random.nextInt(100)+1);
            jsonArray.add(jsonArray1);
        }
        return jsonArray;
    }

    @RequestMapping("/chart2_2")
    public Object chart2_2() throws Exception{
        //{cate:[], data:[]}
        JSONObject jsonObject = new JSONObject();
        String arr [] = {"0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69",
                "70-79", "80-89", "90+"};
        jsonObject.put("cate", arr);
        JSONArray jsonArray = new JSONArray();
        Random random = new Random();
        for(int i=0; i<arr.length; i++){
            jsonArray.add(random.nextInt(100)+1);
        }
        jsonObject.put("data", jsonArray);
        return jsonObject;
    }

    @RequestMapping("/chart2_3")
    public Object chart2_3() throws Exception{
        //text
        CSVReader reader = new CSVReader(new InputStreamReader(new FileInputStream(dir+"click.log"), "UTF-8"));
        String[] line;
        reader.readNext();  // 헤더 건너뜀

        StringBuffer sb = new StringBuffer();
        while ((line = reader.readNext()) != null) {
            sb.append(line[2]+" ");
        }

        return sb.toString();
    }
    @RequestMapping("/chart2_4")
    public Object chart2_4() throws Exception {
        //[]
        JSONObject result = new JSONObject();

        //{}
        JSONArray mainSeriesData = new JSONArray();
        String[] names = {"Samsung", "Apple", "LG", "Other"};
        double[] values = {66.0, 28.0, 4.0, 2.0};

        for(int i = 0; i < names.length; i++) {
            JSONObject obj = new JSONObject();
            obj.put("name", names[i]);
            obj.put("y", values[i]);
            if (!names[i].equals("Other")) {
                obj.put("drilldown", names[i]);
            } else {
                obj.put("drilldown", null);
            }
            mainSeriesData.add(obj);
        }
        //  [{}]
        JSONArray series = new JSONArray();
        JSONObject seriesObj = new JSONObject();
        seriesObj.put("name", "제조사");
        seriesObj.put("colorByPoint", true);
        seriesObj.put("data", mainSeriesData);
        series.add(seriesObj);

        JSONArray drilldownSeries = new JSONArray();

        // Samsung 드릴다운 데이터
        JSONObject samsungDrilldown = new JSONObject();
        samsungDrilldown.put("name", "Samsung");
        samsungDrilldown.put("id", "Samsung");
        JSONArray samsungData = new JSONArray();
        samsungData.add(new JSONArray() {{ add("Galaxy S Series"); add(30.0); }});
        samsungData.add(new JSONArray() {{ add("Galaxy Z Series"); add(20.0); }});
        samsungData.add(new JSONArray() {{ add("Galaxy A Series"); add(16.0); }});
        samsungDrilldown.put("data", samsungData);
        drilldownSeries.add(samsungDrilldown);
        // Apple 드릴다운 데이터
        JSONObject appleDrilldown = new JSONObject();
        appleDrilldown.put("name", "Apple");
        appleDrilldown.put("id", "Apple");
        JSONArray appleData = new JSONArray();
        appleData.add(new JSONArray() {{ add("iPhone Pro"); add(18.0); }});
        appleData.add(new JSONArray() {{ add("iPhone Regular"); add(10.0); }});
        appleDrilldown.put("data", appleData);
        drilldownSeries.add(appleDrilldown);

        // LG 드릴다운 데이터
        JSONObject lgDrilldown = new JSONObject();
        lgDrilldown.put("name", "LG");
        lgDrilldown.put("id", "LG");
        JSONArray lgData = new JSONArray();
        lgData.add(new JSONArray() {{ add("LG Velvet"); add(2.0); }});
        lgData.add(new JSONArray() {{ add("LG Wing"); add(1.0); }});
        lgData.add(new JSONArray() {{ add("기타 LG 모델"); add(1.0); }});
        lgDrilldown.put("data", lgData);
        drilldownSeries.add(lgDrilldown);

        // JSON 객체 추가
        result.put("series", series);
        result.put("drilldownSeries", drilldownSeries);

        return result;
    }


    @RequestMapping("/chart1")
    public Object chart1() throws Exception{
        //[]
        JSONArray jsonArray = new JSONArray();

        //{}
        JSONObject jsonObject1 = new JSONObject();
        JSONObject jsonObject2 = new JSONObject();
        JSONObject jsonObject3 = new JSONObject();
        jsonObject1.put("name", "Korea");
        jsonObject2.put("name", "Japan");
        jsonObject3.put("name", "USA");
        //[]
        JSONArray data1Array = new JSONArray();
        JSONArray data2Array = new JSONArray();
        JSONArray data3Array = new JSONArray();
        Random random = new Random();
        for(int i = 0; i < 12; i++){
            data1Array.add(random.nextInt(100)+1);
            data2Array.add(random.nextInt(100)+1);
            data3Array.add(random.nextInt(100)+1);
        }
        jsonObject1.put("data", data1Array);
        jsonObject2.put("data", data2Array);
        jsonObject3.put("data", data3Array);


        jsonArray.add(jsonObject1);
        jsonArray.add(jsonObject2);
        jsonArray.add(jsonObject3);
        return jsonArray;
    }


}
