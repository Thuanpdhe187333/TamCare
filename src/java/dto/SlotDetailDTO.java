package dto;

import java.math.BigDecimal;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SlotDetailDTO {
    private Long slotId;
    private String slotCode;
    private Integer rowNo;
    private Integer colNo;
    private String status;
    private BigDecimal maxCapacity;
    private String capacityUom;
    private BigDecimal usedCapacity;
    private BigDecimal availableCapacity;
    private List<SlotProductDTO> products;
    private Boolean isEmpty;
}
