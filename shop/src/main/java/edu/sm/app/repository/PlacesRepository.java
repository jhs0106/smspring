package edu.sm.app.repository;


import edu.sm.app.dto.Places;
import edu.sm.app.dto.Search;
import edu.sm.common.frame.SmRepository;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
@Mapper
public interface PlacesRepository extends SmRepository<Places, Integer>{
    List<Places> findByAddrAndType(Search search);
}