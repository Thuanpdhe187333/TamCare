package dto;

import java.util.List;
import lombok.Data;

@Data
public class UserRequest {
    private String username;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String status;
    private Long warehouseId;
    private List<Long> roleIds;
}
