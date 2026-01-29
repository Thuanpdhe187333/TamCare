package model;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GoodsReceiptLine {
    private Long grnLineId;
    private Long grnId;
    private Long poLineId;
    private Long variantId;
    private String sku;
    private String productName;
    private BigDecimal qtyExpected;
    private BigDecimal qtyReceived;
    private BigDecimal qtyGood;
    private BigDecimal qtyMissing;
    private BigDecimal qtyDamaged;
    private BigDecimal qtyExtra;
    private BigDecimal unitPrice;
    private String note;
}
