package dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PurchaseOrderListDTO {
    private Long poId;
    private String poNumber;

    private Long supplierId;
    private String supplierName;

    private LocalDate expectedDeliveryDate;
    private String status;

    private Long importedBy;
    private String importedByUsername;
    private LocalDateTime importedAt;
}
