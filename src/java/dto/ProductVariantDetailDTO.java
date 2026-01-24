package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductVariantDetailDTO {
    private Long variantId;
    private String variantSku;
    private String color;
    private String size;
    private String barcode;
    private String status;
}
