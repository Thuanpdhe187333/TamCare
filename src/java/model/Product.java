package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Product {

    private Long productId;
    private String sku;
    private String name;
    private Long categoryId;
    private Long baseUomId;
    private String barcode;
    private BigDecimal weight;
    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private LocalDateTime createdAt;
}
