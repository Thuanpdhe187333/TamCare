package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InventoryCountLine {
    private Long countLineId;
    private Long countTaskId;
    private Long slotId;
    private Long variantId;
    private String condition;
    private BigDecimal qtySystem;
    private BigDecimal qtyActual;
    private BigDecimal qtyDiff;
    private String note;
}
