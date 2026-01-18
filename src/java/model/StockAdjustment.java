package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class StockAdjustment {
    private Long adjId;
    private String adjNumber;
    private Long warehouseId;
    private Long countId;
    private String reason;
    private String status;
    private Long createdBy;
    private Long approvedBy;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;
    private String note;
}
