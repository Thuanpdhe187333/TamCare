package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StockAdjustmentLine {
    private Long adjLineId;
    private Long adjId;
    private Long slotId;
    private Long variantId;
    private String condition;
    private BigDecimal qtyDelta;
}
