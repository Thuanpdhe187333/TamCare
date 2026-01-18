package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class InventoryBalance {
    private Long invBalanceId;
    private Long warehouseId;
    private Long slotId;
    private Long variantId;
    private String condition;
    private BigDecimal qtyOnHand;
    private BigDecimal qtyReserved;
    private BigDecimal qtyAvailable;
    private LocalDateTime updatedAt;
}
