package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class Warehouse {
    private Long warehouseId;
    private String code;
    private String name;
    private String address;
    private String status;
    private LocalDateTime createdAt;
}
