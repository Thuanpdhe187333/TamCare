package dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GDNListDTO {
    private Long gdnId;
    private String gdnNumber;
    private String soNumber;
    private String customerName;
    private String status;
    private String creatorName;
    private LocalDateTime createdAt;
    private LocalDateTime confirmedAt;
}
