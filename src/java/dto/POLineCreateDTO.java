package dto;

import java.math.BigDecimal;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class POLineCreateDTO {
    private long variantId;
    private BigDecimal qty;
    private BigDecimal unitPrice;
    private String currency;
}
