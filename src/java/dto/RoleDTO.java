package dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RoleDTO {
    private Long roleId;
    private String name;
    private String description;
}
