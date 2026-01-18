package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class Packing {
    private Long packId;
    private Long gdnId;
    private String status;
    private Long packedBy;
    private LocalDateTime packedAt;
    private String packageLabel;
}
