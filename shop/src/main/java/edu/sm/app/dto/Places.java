package edu.sm.app.dto;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Places {
    int id;
    String name;
    int category;
    double lat;
    double lng;

}
