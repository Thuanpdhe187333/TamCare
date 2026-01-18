package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class InventoryTxn {
    private Long txnId;
    private LocalDateTime txnAt;
    private String txnType;
    private Long warehouseId;
    private Long fromSlotId;
    private Long toSlotId;
    private Long variantId;
    private String condition;
    private BigDecimal qtyDelta;
    private String refDocType;
    private Long refDocId;
    private String note;
    private Long createdBy;
}
