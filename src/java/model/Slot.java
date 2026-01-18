package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Slot {
    private Long slotId;
    private Long zoneId;
    private String code;
    private Integer rowNo;
    private Integer colNo;
    private BigDecimal maxCapacity;
    private String capacityUom;
    private String status;
}
