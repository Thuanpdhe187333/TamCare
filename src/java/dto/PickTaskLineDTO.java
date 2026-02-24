package dto;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PickTaskLineDTO {
    private Long pickTaskLineId;
    private Long gdnLineId;
    private Long variantId;
    private String variantSku;
    private String productName;
    private String color;
    private String size;
    private BigDecimal qtyRequired;
    private BigDecimal qtyPicked;
    private String slotCode;
    private String zoneCode;
}
