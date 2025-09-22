package edu.sm.app.repository;

import edu.sm.app.dto.MyTest;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MyTestRepository {
    List<MyTest> findMyTest(MyTest id);

    List<MyTest> findMyTestTrim(MyTest id);

    int updateMyTest(MyTest myTest);

    List<MyTest> findMyTestByIds(MyTest id);
}
