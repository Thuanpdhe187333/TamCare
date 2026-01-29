package dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GoodsReceiptListDTO {
    private Long grnId;
    private String grnNumber;
    private String supplierName;
    private String status;
    private String creatorName;
    private String poNumber;
    private LocalDateTime createdAt;
}
