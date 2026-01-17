package model;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {

    private Long userId;
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private String status;
    private Long warehouseId;
    private Long createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;
    private String lastLoginIp;
    private Boolean isDeleted;
}
