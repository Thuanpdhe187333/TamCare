package dto;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
@ToString
@Getter
@Setter
public class ProductListDTO {
    private Long productId;
    private String sku;
    private String name;
    private String barcode;
    private LocalDateTime createdAt;
}
