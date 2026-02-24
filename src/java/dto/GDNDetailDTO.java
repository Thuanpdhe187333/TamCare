package dto;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GDNDetailDTO {
    private Long gdnId;
    private String gdnNumber;
    private Long warehouseId;
    private Long soId;
    private String soNumber;
    private Long customerId;
    private String customerName;
    private String customerAddress;
    private String gdnType;
    private String status;
    private Long createdBy;
    private String creatorName;
    private LocalDateTime createdAt;
    private LocalDateTime confirmedAt;
    private List<GDNLineDTO> lines;
}
