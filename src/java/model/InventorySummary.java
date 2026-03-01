package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class InventorySummary {
    private Long invSummaryId;
    private Long warehouseId;
    private Long variantId;
    private String condition;
    private BigDecimal qtyOnHand;
    private BigDecimal qtyReserved;
    private BigDecimal qtyAvailable;
    private LocalDateTime updatedAt;
}
