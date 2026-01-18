package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class GoodsDeliveryNote {
    private Long gdnId;
    private String gdnNumber;
    private Long warehouseId;
    private Long soId;
    private Long transferId;
    private String gdnType;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime confirmedAt;
}
