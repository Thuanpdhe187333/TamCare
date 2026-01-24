package dto;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SlotProductDTO {
    private Long variantId;
    private String variantSku;
    private String productName;
    private String productSku;
    private String condition;
    private BigDecimal qtyOnHand;
    private BigDecimal qtyReserved;
    private BigDecimal qtyAvailable;
}
