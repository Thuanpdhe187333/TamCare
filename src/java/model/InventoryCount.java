package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class InventoryCount {
    private Long countId;
    private String countNumber;
    private Long warehouseId;
    private String scopeType;
    private String status;
    private LocalDateTime plannedAt;
    private LocalDateTime startedAt;
    private LocalDateTime finishedAt;
    private Boolean freezeTransactions;
    private Long createdBy;
    private String note;
}
