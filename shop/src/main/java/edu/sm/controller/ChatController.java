package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@Slf4j
@RequestMapping("/chat")
public class ChatController {

    @Value("${app.url.websocketurl}")
    String WebSocketUrl;

    String dir = "chat/";
    @RequestMapping("")
    public String main(Model model) {
        model.addAttribute("center", dir+"center");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/chat1")
    public String chat1(Model model) {
        model.addAttribute("websocketurl", WebSocketUrl);
        model.addAttribute("center", dir+"chat1");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/chat2")
    public String char2(Model model) {
        model.addAttribute("websocketurl", WebSocketUrl);
        model.addAttribute("center", dir+"chat2");
        model.addAttribute("left", dir+"left");
        return "index";
    }

    @RequestMapping("/chat3")
    public String chat3(Model model) {
        model.addAttribute("websocketurl", WebSocketUrl);
        model.addAttribute("center", dir+"chat3");
        model.addAttribute("left", dir+"left");
        return "index";
    }

}