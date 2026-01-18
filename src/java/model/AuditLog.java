package model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AuditLog {
    private Long auditId;
    private Long userId;
    private String action;
    private String entityName;
    private Long entityId;
    private String metadataJson; // json -> String
    private java.time.LocalDateTime createdAt;
}
