package model;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class UserRole {
    private Long userId;
    private Long roleId;
    private LocalDateTime assignedAt;
}
