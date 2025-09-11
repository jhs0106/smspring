package edu.sm.Product;


import edu.sm.app.dto.Product;
import edu.sm.app.dto.ProductSearch;
import edu.sm.app.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
@Slf4j
class SearchTests {

    @Autowired
    ProductService productService;

    @Test
    void contextLoads() throws Exception {
        List<Product> list = null;

        ProductSearch productSearch = ProductSearch.builder().
                productName("반")
                .minPrice(11000).
                maxPrice(20000).
                build();
        list = productService.searchProductList(productSearch);
        list.forEach((p)->{p.toString();});
    }

}