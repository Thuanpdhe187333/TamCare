package dto;

import java.util.List;
import lombok.Data;

@Data
public class RoleRequest {
    private String name;
    private String description;
    private List<Long> permissionIds;
}
