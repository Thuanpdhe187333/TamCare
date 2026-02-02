package dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductInventoryListDTO {
    private Long productId;
    private String sku;
    private String name;
    private String barcode;
    private LocalDateTime createdAt;
    
    // Inventory information
    private Long variantId;
    private String variantSku;
    private BigDecimal totalQtyOnHand;
    private BigDecimal totalQtyAvailable;
    private String slotCode;
    private String zoneCode;
    private String zoneName;
    private String condition;
    private String warehouseCode;
    private String warehouseName;
}
