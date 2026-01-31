package dto;

import java.util.List;
import lombok.Data;

@Data
public class PermissionRequest {
    private String code;
    private String name;
    private List<Long> roleIds;
}
