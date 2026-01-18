package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GoodsDeliveryLine {
    private Long gdnLineId;
    private Long gdnId;
    private Long soLineId;
    private Long transferLineId;
    private Long variantId;
    private BigDecimal qtyRequired;
    private BigDecimal qtyPicked;
    private BigDecimal qtyPacked;
    private BigDecimal qtyShipped;
}
