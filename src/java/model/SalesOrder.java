package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@Setter
public class SalesOrder {
    private Long soId;
    private String soNumber;
    private Long customerId;
    private LocalDate requestedShipDate;
    private String shipToAddress;
    private String status;
    private Long importedBy;
    private LocalDateTime importedAt;
    private String note;
}
