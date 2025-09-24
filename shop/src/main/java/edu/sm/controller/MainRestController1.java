package edu.sm.controller;

// 필요한 클래스들을 임포트합니다.
import edu.sm.app.dto.ChartDataDto;
import edu.sm.app.service.LoggerService1;
import edu.sm.app.service.LoggerService2;
import edu.sm.app.service.LoggerService3;
import edu.sm.app.service.LoggerService4;
import edu.sm.sse.SseEmitters;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import java.io.IOException;

@RequiredArgsConstructor
@RestController
@Slf4j
public class MainRestController1 {
    private final LoggerService1 loggerService1;
    private final LoggerService2 loggerService2;
    private final LoggerService3 loggerService3;
    private final LoggerService4 loggerService4;

    private final SseEmitters sseEmitters;

    @GetMapping(value = "/connect/{id}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter connect(@PathVariable String id) {
        SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
        sseEmitters.add(id, emitter);
        try {
            emitter.send(SseEmitter.event().name("connect").data("connect successful!"));
        } catch (IOException e) {
            emitter.completeWithError(e);
        }
        return emitter;
    }


    @GetMapping("/savedata1")
    public String saveData1(@RequestParam("data") String data) {
        loggerService1.save1(data);
        sseEmitters.sendToGroup("chart", "chart-update", new ChartDataDto("A", data));

        return "OK";
    }

    @GetMapping("/savedata2")
    public String saveData2(@RequestParam("data") String data) {
        loggerService2.save2(data);
        sseEmitters.sendToGroup("chart", "chart-update", new ChartDataDto("B", data));
        return "OK";
    }

    @GetMapping("/savedata3")
    public String saveData3(@RequestParam("data") String data) {
        loggerService3.save3(data);
        sseEmitters.sendToGroup("chart", "chart-update", new ChartDataDto("C", data));
        return "OK";
    }

    @GetMapping("/savedata4")
    public String saveData4(@RequestParam("data") String data) {
        loggerService4.save4(data);
        sseEmitters.sendToGroup("chart", "chart-update", new ChartDataDto("D", data));
        return "OK";
    }
}