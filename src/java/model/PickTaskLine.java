package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PickTaskLine {
    private Long pickLineId;
    private Long pickTaskId;
    private Long gdnLineId;
    private Long fromSlotId;
    private BigDecimal qtyToPick;
    private BigDecimal qtyPicked;
    private String pickStatus;
    private String note;
}
