package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class PutawayLine {
    private Long putawayLineId;
    private Long putawayId;
    private Long grnLineId;
    private Long toSlotId;
    private BigDecimal qtyPutaway;
    private Long performedBy;
    private LocalDateTime performedAt;
}
