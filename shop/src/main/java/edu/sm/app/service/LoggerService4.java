package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class LoggerService4 {
    public void save4(String data){
        log.info(data);
    }
}
