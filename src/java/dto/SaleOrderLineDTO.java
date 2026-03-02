/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
/**
 *
 * @author HungTran
 */
public class SaleOrderLineDTO {
    private Long soLineId;
    private Long soId;
    private Long variantId;
    private String variantSku;
    private Long productId;
    private String productSku;
    private String productName;
    private String color;
    private String size;
    private String barcode;
    private BigDecimal orderedQty;
    private BigDecimal unitPrice;
    private BigDecimal discount;
}
