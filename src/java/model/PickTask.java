package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class PickTask {
    private Long pickTaskId;
    private Long waveId;
    private Long assignedTo;
    private Long assignedBy;
    private String status;
    private LocalDateTime assignedAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
}
