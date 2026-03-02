package dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ShipmentDTO {
    private Long shipmentId;
    private String shipmentNumber;
    private Long gdnId;
    private String gdnNumber;
    private String soNumber;
    private Long customerId;
    private String customerName;
    private String shipToAddress;
    private LocalDateTime requestedShipDate;
    private Long carrierId;
    private String carrierName;
    private String shipmentType;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime pickedUpAt;
    private LocalDateTime deliveredAt;
    private String trackingCode;
    private String note;
}
