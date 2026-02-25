package dto;

import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PickWaveDTO {
    private Long waveId;
    private Long gdnId;
    private String gdnNumber;
    private String status;
    private Long createdBy;
    private String createdByName;
    private LocalDateTime createdAt;
    private List<PickTaskDTO> tasks;
}
