package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class PutAwayOrder {
    private Long putawayId;
    private Long grnId;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
}
