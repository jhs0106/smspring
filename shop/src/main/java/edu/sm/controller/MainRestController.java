package edu.sm.controller;


import edu.sm.util.FileUploadUtil;
import edu.sm.util.WeatherUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {
    @Value("${app.key.wkey}")
    String wkey;

    @RequestMapping("/getwt1")
    public Object getwt1(@RequestParam("loc") String loc) throws IOException, ParseException {
        return WeatherUtil.getWeather(loc, wkey);
    }
    @RequestMapping("/getwt2")
    public Object getwt2(@RequestParam("loc") String loc, @RequestParam("loc2") String loc2) throws IOException, ParseException {
        Object weather1 = WeatherUtil.getWeather(loc, wkey);
        Object weather2 = WeatherUtil.getWeatherForecast(loc2, wkey);
        Map<String, Object> result = new HashMap<>();
        result.put("weather1", weather1);
        result.put("weather2", weather2);
        return result;
    }

    @RequestMapping("/saveaudio")
    public Object savewaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "OK";
    }

    @RequestMapping("/saveimg")
    public Object saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "성공적으로 사진이 전송되었습니다.";
    }
}
