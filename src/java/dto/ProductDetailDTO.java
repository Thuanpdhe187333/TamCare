package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductDetailDTO {
    private Long productId;
    private String sku;
    private String name;
    private Long categoryId;
    private String categoryName;
    private Long baseUomId;
    private String uomName;
    private String barcode;
    private BigDecimal weight;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private LocalDateTime createdAt;
    private List<ProductVariantDetailDTO> variants;
}
