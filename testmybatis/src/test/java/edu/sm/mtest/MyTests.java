package edu.sm.mtest;

import edu.sm.app.repository.MyTestRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class TestmybatisApplicationTests {

    @Autowired
    private MyTestRepository myTestRepository;
    @Test
    void contextLoads() {
    }

}
