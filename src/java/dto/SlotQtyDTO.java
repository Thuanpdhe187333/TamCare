package dto;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SlotQtyDTO {
    private Long slotId;
    private String slotCode;
    private Long zoneId;
    private String zoneCode;
    private BigDecimal qtyAvailable;
}
