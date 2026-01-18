package dto;

import lombok.*;
import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SupplierDTO {
    private long supplierId;
    private String code;
    private String name;
}
