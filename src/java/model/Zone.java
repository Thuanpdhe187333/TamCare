package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Zone {
    private Long zoneId;
    private Long warehouseId;
    private String code;
    private String name;
    private String zoneType;
    private String status;
}
