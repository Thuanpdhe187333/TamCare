package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class PickWave {
    private Long waveId;
    private Long gdnId;
    private String status;
    private Long createdBy;
    private LocalDateTime createdAt;
}
