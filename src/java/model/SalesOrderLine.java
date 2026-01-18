package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SalesOrderLine {
    private Long soLineId;
    private Long soId;
    private Long variantId;
    private BigDecimal qtyOrdered;
    private BigDecimal unitPrice;
    private BigDecimal discount;
}
