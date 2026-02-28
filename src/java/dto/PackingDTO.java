package dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PackingDTO {
    private Long packId;
    private Long gdnId;
    private String gdnNumber;
    private String status;
    private Long packedBy;
    private String packedByName;
    private LocalDateTime packedAt;
    private String packageLabel;
}
