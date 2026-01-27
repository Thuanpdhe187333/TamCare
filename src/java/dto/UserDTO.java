package dto;

import java.time.LocalDateTime;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDTO {
    private Long userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String status;
    private Long warehouseId;
    private String roleNames;
    private LocalDateTime createdAt;
    private Boolean isDeleted;
}
