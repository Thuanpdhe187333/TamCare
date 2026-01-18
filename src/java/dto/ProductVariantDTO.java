package dto;

import lombok.*;

import lombok.Getter;
import lombok.Setter;
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
