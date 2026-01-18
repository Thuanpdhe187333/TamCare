package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Permission {
    private Long permissionId;
    private String code;
    private String name;
}
