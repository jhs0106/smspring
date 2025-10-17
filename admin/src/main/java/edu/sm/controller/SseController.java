package edu.sm.controller;

import java.io.IOException;

import edu.sm.app.dto.AiMsg;
import edu.sm.app.springai.service3.AiImageService;
import edu.sm.sse.SseEmitters;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import java.time.Instant;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
public class SseController {

    private final SseEmitters sseEmitters;
    private final AiImageService aiImageService;


    @GetMapping(value = "/connect/{id}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public ResponseEntity<SseEmitter> connect(@PathVariable("id") String clientId ) {
        SseEmitter emitter = new SseEmitter();
        sseEmitters.add(clientId,emitter);
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data(clientId)
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return ResponseEntity.ok(emitter);
    }
    @GetMapping("/count")
    public void count(@RequestParam("num")int num) {
        sseEmitters.count(num);
        //return ResponseEntity.ok().build();
    }

    @RequestMapping("/aimsg")
    public void msg(@RequestParam("msg")String msg){
        log.info("msg:"+msg);
        sseEmitters.msg(msg);
    }

//    @RequestMapping(value = "/aiimage", method = RequestMethod.POST, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
//    public ResponseEntity<String> receiveImage(@RequestParam("image") MultipartFile image) throws IOException {
//        if (image == null || image.isEmpty()) {
//            log.warn("AI browser image received with no data.");
//            return ResponseEntity.badRequest().body("이미지가 비어 있습니다.");
//        }
//
//        String contentType = image.getContentType();
//        if (contentType == null || contentType.isBlank()) {
//            contentType = MediaType.IMAGE_PNG_VALUE;
//        }
//
//
//        byte[] bytes = image.getBytes();
//        log.info("AI browser image received: name={}, size={} bytes", image.getOriginalFilename(), bytes.length);
//
//
//
//        String prompt = "촬영된 이미지를 분석해서 어떤 상황인지 간단히 설명해줘.";
//        String analysis = aiImageService.imageAnalysis2(prompt, contentType, bytes);
//        log.info("LLM analysis completed: {}", analysis);
//
//        Map<String, Object> payload = new HashMap<>();
//        String base64Image = Base64.getEncoder().encodeToString(bytes);
//        String dataUrl = "data:" + contentType + ";base64," + base64Image;
//        payload.put("image", dataUrl);
//        payload.put("analysis", analysis);
//        payload.put("filename", image.getOriginalFilename());
//        payload.put("contentType", contentType);
//        payload.put("receivedAt", Instant.now().toString());
//
//        sseEmitters.msg(payload);
//        return ResponseEntity.ok("이미지를 성공적으로 분석했습니다.");
//
//    }

    @RequestMapping("/aimsg2")
    public void msg( @RequestParam(value="attach", required = false) MultipartFile attach) throws IOException {
        log.info(attach.getOriginalFilename());
        String base64File = Base64.getEncoder().encodeToString(attach.getBytes());
        log.info(base64File);
        String result = aiImageService.imageAnalysis2("이미지를 분석해줘",attach.getContentType(), attach.getBytes());
        AiMsg aiMsg = AiMsg.builder()
                .result(result)
                .base64File(base64File)
                .build();
        sseEmitters.msg(aiMsg);

    }

}
