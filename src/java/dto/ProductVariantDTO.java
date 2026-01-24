package dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class ProductVariantDTO {

    private long variantId;
    private String variantSku;
    private String productSku;
    private String productName;
}
