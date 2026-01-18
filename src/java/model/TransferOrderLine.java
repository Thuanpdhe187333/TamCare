package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TransferOrderLine {
    private Long transferLineId;
    private Long transferId;
    private Long variantId;
    private BigDecimal qtyRequested;
    private BigDecimal qtyDispatched;
}
