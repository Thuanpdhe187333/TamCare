package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class GoodsReceipt {
    private Long grnId;
    private String grnNumber;
    private Long poId;
    private String poNumber;
    private String supplierName;
    private Long warehouseId;
    private String status;
    private Long createdBy;
    private Long approvedBy;
    private LocalDateTime createdAt;
    private LocalDateTime approvedAt;
    private String deliveredBy;
    private LocalDateTime receivedAt;
    private String note;
}
