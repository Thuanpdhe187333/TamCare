<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="dto.SlotDetailDTO"%>
<%@page import="model.Zone"%>
<%@page import="dto.ProductVariantDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
    List<SlotDetailDTO> slots = (List<SlotDetailDTO>) request.getAttribute("slots");
    Zone zone = (Zone) request.getAttribute("zone");
    Long warehouseId = (Long) request.getAttribute("warehouseId");
    List<ProductVariantDTO> variants = (List<ProductVariantDTO>) request.getAttribute("variants");
    
    // Tính toán maxRow và maxCol
    int maxRow = 0;
    int maxCol = 0;
    
    if (slots != null && !slots.isEmpty()) {
        for (SlotDetailDTO slot : slots) {
            if (slot.getRowNo() != null && slot.getRowNo() > maxRow) {
                maxRow = slot.getRowNo();
            }
            if (slot.getColNo() != null && slot.getColNo() > maxCol) {
                maxCol = slot.getColNo();
            }
        }
    }
    
    // Set vào request attribute để JSTL có thể sử dụng
    request.setAttribute("maxRow", maxRow);
    request.setAttribute("maxCol", maxCol);
%>

<t:layout title="Zone Layout - ${zone.code}">
    <style>
    .slot-grid-container {
        margin: 20px 0;
        padding: 20px;
        background-color: #f8f9fa;
        border-radius: 8px;
    }
    
    .screen-indicator {
        background-color: #000;
        color: white;
        text-align: center;
        padding: 10px;
        margin-bottom: 20px;
        border-radius: 4px;
        font-weight: bold;
        letter-spacing: 2px;
    }
    
    .slot-grid {
        display: grid;
        gap: 8px;
        justify-content: center;
    }
    
    .slot-item {
        width: 80px;
        height: 80px;
        border: 2px solid #dee2e6;
        border-radius: 8px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s;
        position: relative;
        font-size: 11px;
        text-align: center;
        padding: 4px;
    }
    
    .slot-item:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        z-index: 10;
    }
    
    /* Slot trống - nổi bật */
    .slot-item.empty {
        background-color: #d1ecf1;
        border-color: #0dcaf0;
        animation: pulse 2s infinite;
        box-shadow: 0 0 10px rgba(13, 202, 240, 0.5);
    }
    
    @keyframes pulse {
        0%, 100% { box-shadow: 0 0 10px rgba(13, 202, 240, 0.5); }
        50% { box-shadow: 0 0 20px rgba(13, 202, 240, 0.8); }
    }
    
    /* Slot có hàng */
    .slot-item.occupied {
        background-color: #d4edda;
        border-color: #28a745;
        color: #155724;
    }
    
    /* Slot bị block */
    .slot-item.blocked {
        background-color: #f8d7da;
        border-color: #dc3545;
        color: #721c24;
        cursor: not-allowed;
        opacity: 0.6;
    }
    
    /* Slot đầy */
    .slot-item.full {
        background-color: #fff3cd;
        border-color: #ffc107;
        color: #856404;
    }
    
    .slot-code {
        font-weight: bold;
        font-size: 10px;
        margin-bottom: 2px;
    }
    
    .slot-info {
        font-size: 9px;
        color: #666;
    }
    
    .row-label {
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #495057;
        min-width: 30px;
    }
    
    .col-header {
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #495057;
        min-height: 30px;
    }
    
    .legend {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        margin: 20px 0;
    }
    
    .legend-item {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .legend-color {
        width: 30px;
        height: 30px;
        border-radius: 4px;
        border: 2px solid;
    }
    
    .instructions {
        background-color: #e7f3ff;
        border-left: 4px solid #0d6efd;
        padding: 15px;
        margin: 20px 0;
        border-radius: 4px;
    }
</style>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-0">
                Zone Layout: <span class="badge bg-info"><c:out value="${zone.code}" /></span>
                <c:out value="${zone.name}" />
            </h4>
            <small class="text-muted">Type: <c:out value="${zone.zoneType}" /></small>
        </div>
        <a href="${pageContext.request.contextPath}/warehouse-layout?warehouseId=${warehouseId}" 
           class="btn btn-secondary">Back</a>
    </div>

    <!-- Legend -->
    <div class="legend">
        <div class="legend-item">
            <div class="legend-color empty" style="background-color: #d1ecf1; border-color: #0dcaf0;"></div>
            <span>Empty Slot (Available)</span>
        </div>
        <div class="legend-item">
            <div class="legend-color occupied" style="background-color: #d4edda; border-color: #28a745;"></div>
            <span>Occupied Slot</span>
        </div>
        <div class="legend-item">
            <div class="legend-color full" style="background-color: #fff3cd; border-color: #ffc107;"></div>
            <span>Full Slot</span>
        </div>
        <div class="legend-item">
            <div class="legend-color blocked" style="background-color: #f8d7da; border-color: #dc3545;"></div>
            <span>Blocked Slot</span>
        </div>
    </div>

    <!-- Instructions -->
    <div class="instructions">
        <strong>Instructions:</strong>
        <ul class="mb-0">
            <li>Click on a slot to view details and manage products in that slot</li>
            <li>Empty slots (light blue) will be highlighted for easy recognition</li>
            <li>Occupied slots are green, full slots are yellow, blocked slots are red</li>
        </ul>
    </div>

    <!-- Slot Grid -->
    <div class="slot-grid-container">
        <div class="screen-indicator">OPERATION AREA</div>
        
        <c:if test="${empty slots}">
            <div style="text-align: center; padding: 40px; color: #6c757d; background-color: #f8f9fa; border-radius: 8px; margin: 20px 0;">
                <h5>No slots in this zone</h5>
                <p>Please go back and create slots for this zone first.</p>
                <a href="${pageContext.request.contextPath}/warehouse-layout?warehouseId=${warehouseId}" class="btn btn-primary">Back</a>
            </div>
        </c:if>
        
        <c:if test="${not empty slots}">
        <c:set var="maxColValue" value="${maxCol > 0 ? maxCol : 10}" />
        <c:set var="maxRowValue" value="${maxRow > 0 ? maxRow : 8}" />
        <div class="slot-grid" id="slotGrid" style="grid-template-columns: 30px repeat(${maxColValue}, 80px); grid-template-rows: 30px repeat(${maxRowValue}, 80px);">
            <!-- Header row -->
            <div></div>
            <c:if test="${maxCol > 0}">
            <c:forEach var="col" begin="1" end="${maxCol}">
            <div class="col-header">${col}</div>
            </c:forEach>
            </c:if>
            
            <!-- Slot rows -->
            <c:if test="${maxRow > 0}">
            <c:forEach var="row" begin="1" end="${maxRow}">
                <c:set var="rowCharIndex" value="${row - 1}" />
                <c:set var="rowChar" value="" />
                <c:choose>
                    <c:when test="${rowCharIndex == 0}"><c:set var="rowChar" value="A" /></c:when>
                    <c:when test="${rowCharIndex == 1}"><c:set var="rowChar" value="B" /></c:when>
                    <c:when test="${rowCharIndex == 2}"><c:set var="rowChar" value="C" /></c:when>
                    <c:when test="${rowCharIndex == 3}"><c:set var="rowChar" value="D" /></c:when>
                    <c:when test="${rowCharIndex == 4}"><c:set var="rowChar" value="E" /></c:when>
                    <c:when test="${rowCharIndex == 5}"><c:set var="rowChar" value="F" /></c:when>
                    <c:when test="${rowCharIndex == 6}"><c:set var="rowChar" value="G" /></c:when>
                    <c:when test="${rowCharIndex == 7}"><c:set var="rowChar" value="H" /></c:when>
                    <c:when test="${rowCharIndex == 8}"><c:set var="rowChar" value="I" /></c:when>
                    <c:when test="${rowCharIndex == 9}"><c:set var="rowChar" value="J" /></c:when>
                    <c:when test="${rowCharIndex == 10}"><c:set var="rowChar" value="K" /></c:when>
                    <c:when test="${rowCharIndex == 11}"><c:set var="rowChar" value="L" /></c:when>
                    <c:when test="${rowCharIndex == 12}"><c:set var="rowChar" value="M" /></c:when>
                    <c:when test="${rowCharIndex == 13}"><c:set var="rowChar" value="N" /></c:when>
                    <c:when test="${rowCharIndex == 14}"><c:set var="rowChar" value="O" /></c:when>
                    <c:when test="${rowCharIndex == 15}"><c:set var="rowChar" value="P" /></c:when>
                    <c:when test="${rowCharIndex == 16}"><c:set var="rowChar" value="Q" /></c:when>
                    <c:when test="${rowCharIndex == 17}"><c:set var="rowChar" value="R" /></c:when>
                    <c:when test="${rowCharIndex == 18}"><c:set var="rowChar" value="S" /></c:when>
                    <c:when test="${rowCharIndex == 19}"><c:set var="rowChar" value="T" /></c:when>
                    <c:when test="${rowCharIndex == 20}"><c:set var="rowChar" value="U" /></c:when>
                    <c:when test="${rowCharIndex == 21}"><c:set var="rowChar" value="V" /></c:when>
                    <c:when test="${rowCharIndex == 22}"><c:set var="rowChar" value="W" /></c:when>
                    <c:when test="${rowCharIndex == 23}"><c:set var="rowChar" value="X" /></c:when>
                    <c:when test="${rowCharIndex == 24}"><c:set var="rowChar" value="Y" /></c:when>
                    <c:otherwise><c:set var="rowChar" value="Z" /></c:otherwise>
                </c:choose>
                <div class="row-label">${rowChar}</div>
                <c:forEach var="col" begin="1" end="${maxCol}">
                    <c:set var="slot" value="${null}" />
                    <c:forEach items="${slots}" var="s">
                        <c:if test="${s.rowNo == row && s.colNo == col}">
                            <c:set var="slot" value="${s}" />
                        </c:if>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${slot != null}">
                            <c:set var="slotClass" value="" />
                            <c:choose>
                                <c:when test="${slot.status == 'BLOCKED'}">
                                    <c:set var="slotClass" value="blocked" />
                                </c:when>
                                <c:when test="${slot.isEmpty}">
                                    <c:set var="slotClass" value="empty" />
                                </c:when>
                                <c:when test="${slot.maxCapacity != null && slot.usedCapacity >= slot.maxCapacity}">
                                    <c:set var="slotClass" value="full" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="slotClass" value="occupied" />
                                </c:otherwise>
                            </c:choose>
                            <div class="slot-item ${slotClass}"
                                 data-slot-id="${slot.slotId}"
                                 onclick="openSlotDetail(${slot.slotId})">
                                <div class="slot-code"><c:out value="${slot.slotCode}" /></div>
                                <c:choose>
                                    <c:when test="${!slot.isEmpty}">
                                        <div class="slot-info">
                                            ${fn:length(slot.products)} SP<br>
                                            <c:choose>
                                                <c:when test="${slot.usedCapacity != null}">
                                                    <fmt:formatNumber value="${slot.usedCapacity}" minFractionDigits="0" maxFractionDigits="2" />
                                                </c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="slot-info">Empty</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 80px; height: 80px;"></div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </c:forEach>
            </c:if>
        </div>
        </c:if>
    </div>

    <!-- Modal chi tiết Slot -->
    <div class="modal fade" id="slotDetailModal" tabindex="-1" aria-labelledby="slotDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="slotDetailModalLabel">Chi tiết Slot</h5>
                    <button type="button" class="btn-close-modal" onclick="closeSlotDetailModal()" aria-label="Close" style="background: none; border: none; font-size: 24px; color: #dc3545; cursor: pointer; padding: 0; width: 30px; height: 30px; line-height: 30px; text-align: center;">×</button>
                </div>
            <div class="modal-body" id="slotDetailContent">
                <div class="text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <script>
    const warehouseId = ${warehouseId};
    const zoneId = ${zone.zoneId};
    const variants = [
        <c:forEach items="${variants}" var="v" varStatus="status">
        <c:if test="${status.index > 0}">,</c:if>
        {
            variantId: ${v.variantId},
            variantSku: "<c:out value='${v.variantSku}' escapeXml='false' />",
            productName: "<c:out value='${v.productName}' escapeXml='false' />"
        }
        </c:forEach>
    ];

let slotDetailModal = null;

function openSlotDetail(slotId) {
    const modalElement = document.getElementById('slotDetailModal');
    if (!slotDetailModal) {
        slotDetailModal = new bootstrap.Modal(modalElement, {
            backdrop: true,
            keyboard: true
        });
    }
    const modalContent = document.getElementById('slotDetailContent');
    modalContent.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
    slotDetailModal.show();
    
    loadSlotDetail(slotId);
}

function closeSlotDetailModal() {
    if (slotDetailModal) {
        slotDetailModal.hide();
    } else {
        const modalElement = document.getElementById('slotDetailModal');
        if (modalElement) {
            const modal = bootstrap.Modal.getInstance(modalElement);
            if (modal) {
                modal.hide();
            }
        }
    }
}

function loadSlotDetail(slotId) {
    const modalContent = document.getElementById('slotDetailContent');
    
    fetch('${pageContext.request.contextPath}/warehouse-layout?action=slot-detail&slotId=' + slotId + '&warehouseId=' + warehouseId)
        .then(response => response.json())
        .then(data => {
            displaySlotDetail(data, slotId);
        })
        .catch(error => {
            modalContent.innerHTML = '<div class="alert alert-danger">Error: ' + error.message + '</div>';
        });
}

function displaySlotDetail(slot, slotId) {
    const modalContent = document.getElementById('slotDetailContent');
    let html = '<div class="mb-3">';
    html += '<h6>Slot Information</h6>';
    html += '<table class="table table-sm">';
    html += '<tr><td><strong>Slot Code:</strong></td><td>' + (slot.slotCode || '') + '</td></tr>';
    html += '<tr><td><strong>Status:</strong></td><td><span class="badge bg-' + 
        (slot.status === 'ACTIVE' ? 'success' : slot.status === 'BLOCKED' ? 'danger' : 'secondary') + '">' + 
        (slot.status || '') + '</span></td></tr>';
    html += '<tr><td><strong>Empty:</strong></td><td>' + (slot.isEmpty ? 'Yes' : 'No') + '</td></tr>';
    html += '<tr><td><strong>Used Capacity:</strong></td><td>' + (slot.usedCapacity || '0') + '</td></tr>';
    html += '<tr><td><strong>Available Capacity:</strong></td><td>' + (slot.availableCapacity || '0') + '</td></tr>';
    html += '<tr><td><strong>Max Capacity:</strong></td><td>' + (slot.maxCapacity || 'Unlimited') + '</td></tr>';
    html += '</table></div>';
    
    html += '<div class="mb-3"><h6>Products in Slot</h6>';
    if (slot.products && slot.products.length > 0) {
        html += '<div class="table-responsive"><table class="table table-sm table-bordered">';
        html += '<thead><tr><th>SKU</th><th>Product Name</th><th>Condition</th><th>On Hand</th><th>Available</th></tr></thead><tbody>';
        slot.products.forEach(p => {
            html += '<tr>';
            html += '<td>' + (p.variantSku || '') + '</td>';
            html += '<td>' + (p.productName || '') + '</td>';
            html += '<td>' + (p.condition || '') + '</td>';
            html += '<td>' + (p.qtyOnHand || '0') + '</td>';
            html += '<td>' + (p.qtyAvailable || '0') + '</td>';
            html += '</tr>';
        });
        html += '</tbody></table></div>';
    } else {
        html += '<p class="text-muted">No products in this slot</p>';
    }
    html += '</div>';
    
    html += '<div><h6>Add Product to Slot</h6>';
    html += '<form method="post" action="${pageContext.request.contextPath}/warehouse-layout" id="assignProductForm">';
    html += '<input type="hidden" name="action" value="assign-product">';
    html += '<input type="hidden" name="warehouseId" value="' + warehouseId + '">';
    html += '<input type="hidden" name="slotId" value="' + slotId + '">';
    html += '<input type="hidden" name="zoneId" value="' + zoneId + '">';
    
    html += '<div class="row mb-3">';
    html += '<div class="col-md-6">';
    html += '<label class="form-label">Product (Variant)</label>';
    html += '<select name="variantId" class="form-select" required>';
    html += '<option value="">-- Select Product --</option>';
    variants.forEach(v => {
        html += '<option value="' + v.variantId + '">' + v.variantSku + ' - ' + v.productName + '</option>';
    });
    html += '</select></div>';
    
    html += '<div class="col-md-3">';
    html += '<label class="form-label">Quantity</label>';
    html += '<input type="number" name="qty" class="form-control" min="0.01" step="0.01" required>';
    html += '</div>';
    
    html += '<div class="col-md-3">';
    html += '<label class="form-label">Condition</label>';
    html += '<select name="condition" class="form-select">';
    html += '<option value="GOOD">GOOD</option>';
    html += '<option value="DAMAGED">DAMAGED</option>';
    html += '<option value="EXPIRED">EXPIRED</option>';
    html += '</select></div></div>';
    
    html += '<button type="submit" class="btn btn-primary">Add Product</button>';
    html += '</form></div>';
    
    modalContent.innerHTML = html;
}
    </script>
</t:layout>
