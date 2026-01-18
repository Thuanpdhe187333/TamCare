package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class StockMoveLine {
    private Long moveLineId;
    private Long moveId;
    private Long variantId;
    private Long fromSlotId;
    private Long toSlotId;
    private BigDecimal qtyMoved;
    private LocalDateTime movedAt;
    private Long movedBy;
}
