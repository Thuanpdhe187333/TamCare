package dto;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PickTaskLineDTO {
    private Long pickTaskLineId;
    private Long pickTaskId;
    private Long gdnLineId;
    private Long fromSlotId;
    private String slotCode;
    private String zoneCode;
    private Long variantId;
    private String variantSku;
    private String productName;
    private String color;
    private String size;
    private BigDecimal qtyToPick;
    private BigDecimal qtyPicked;
    private String pickStatus;
    private String note;
}
