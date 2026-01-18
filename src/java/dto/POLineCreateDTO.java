package dto;

import lombok.*;
import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
@NoArgsConstructor
@Getter
@Setter
public class POLineCreateDTO {
    private long variantId;
    private BigDecimal qty;
    private BigDecimal unitPrice;
    private BigDecimal taxRate;
    private String currency;

    public POLineCreateDTO(long variantId, BigDecimal qty, BigDecimal unitPrice, BigDecimal taxRate, String currency) {
        this.variantId = variantId;
        this.qty = qty;
        this.unitPrice = unitPrice;
        this.taxRate = taxRate;
        this.currency = currency;
    }
}