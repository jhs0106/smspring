package edu.sm.app.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class LoggerService2 {
    public void save2(String data){
        log.info(data);
    }
}
