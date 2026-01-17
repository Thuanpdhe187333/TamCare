package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PurchaseOrderLine {

    private Long poLineId;
    private Long poId;
    private Long variantId;
    private BigDecimal qtyOrdered;
    private BigDecimal unitPrice;
    private BigDecimal taxRate;
    private String currency;
}
