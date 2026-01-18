package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class TranferOrder {
    private Long transferId;
    private String transferNumber;
    private Long fromWarehouseId;
    private Long toWarehouseId;
    private LocalDate plannedDate;
    private String reason;
    private String status;
    private Long createdBy;
    private Long approvedBy;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;
}
