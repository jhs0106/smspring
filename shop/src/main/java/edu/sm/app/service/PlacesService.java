package edu.sm.app.service;

import edu.sm.app.dto.Places;
import edu.sm.app.dto.Search;
import edu.sm.common.frame.SmService;
import edu.sm.app.repository.PlacesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PlacesService implements SmService<Places, Integer> {
    final PlacesRepository placesRepository;

    public List<Places> findByAddrAndType(Search search){
        return  placesRepository.findByAddrAndType(search);
    }

    @Override
    public void register(Places places) throws Exception {

    }

    @Override
    public void modify(Places places) throws Exception {

    }

    @Override
    public void remove(Integer integer) throws Exception {

    }

    @Override
    public List<Places> get() throws Exception {
        return List.of();
    }

    @Override
    public Places get(Integer integer) throws Exception {
        return null;
    }
}
