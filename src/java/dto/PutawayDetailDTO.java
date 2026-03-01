package dto;

import java.math.BigDecimal;

public class PutawayDetailDTO {
    private String sku;
    private String productName;
    private String slotCode;
    private String zoneName;
    private String zoneCode;
    private String type;
    private BigDecimal qtyPutaway;

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSlotCode() {
        return slotCode;
    }

    public void setSlotCode(String slotCode) {
        this.slotCode = slotCode;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    public BigDecimal getQtyPutaway() {
        return qtyPutaway;
    }

    public void setQtyPutaway(BigDecimal qtyPutaway) {
        this.qtyPutaway = qtyPutaway;
    }

    public String getZoneCode() {
        return zoneCode;
    }

    public void setZoneCode(String zoneCode) {
        this.zoneCode = zoneCode;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
