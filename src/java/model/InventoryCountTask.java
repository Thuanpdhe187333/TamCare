package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class InventoryCountTask {
    private Long countTaskId;
    private Long countId;
    private Long assignedTo;
    private Long assignedBy;
    private String status;
    private LocalDateTime assignedAt;
    private LocalDateTime doneAt;
}
