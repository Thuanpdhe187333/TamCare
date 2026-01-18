/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PurchaseOrderDetailDTO {

    private long poLineId;
    private long productId;
    private String productName;
    private long variantId;
    private String variantSku;
    private String color;
    private String size;
    private String barcode;
    private String variantStatus;
    private BigDecimal orderedQty;
    private BigDecimal unitPrice;
    private BigDecimal lineAmount;
}
