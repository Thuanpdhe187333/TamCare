package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class StockMove {
    private Long moveId;
    private String moveNumber;
    private Long warehouseId;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
}
