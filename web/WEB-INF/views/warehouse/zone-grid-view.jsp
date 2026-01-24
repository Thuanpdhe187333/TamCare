<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="dto.SlotDetailDTO"%>
<%@page import="model.Zone"%>
<%@page import="dto.ProductVariantDTO"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>

<%
    List<SlotDetailDTO> slots = (List<SlotDetailDTO>) request.getAttribute("slots");
    Zone zone = (Zone) request.getAttribute("zone");
    Long warehouseId = (Long) request.getAttribute("warehouseId");
    List<ProductVariantDTO> variants = (List<ProductVariantDTO>) request.getAttribute("variants");
    
    // Tạo map để tổ chức slots theo row và col
    Map<Integer, Map<Integer, SlotDetailDTO>> slotGrid = new HashMap<>();
    int maxRow = 0;
    int maxCol = 0;
    
    if (slots != null) {
        for (SlotDetailDTO slot : slots) {
            if (slot.getRowNo() != null && slot.getColNo() != null) {
                int row = slot.getRowNo();
                int col = slot.getColNo();
                
                if (!slotGrid.containsKey(row)) {
                    slotGrid.put(row, new HashMap<>());
                }
                slotGrid.get(row).put(col, slot);
                
                if (row > maxRow) maxRow = row;
                if (col > maxCol) maxCol = col;
            }
        }
    }
%>

<jsp:include page="../layout/head.jspf" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="mb-0">
                Layout Zone: <span class="badge bg-info"><c:out value="${zone.code}" /></span>
                <c:out value="${zone.name}" />
            </h4>
            <small class="text-muted">Loại: <c:out value="${zone.zoneType}" /></small>
        </div>
        <a href="<%= request.getContextPath() %>/warehouse-layout?warehouseId=<%= warehouseId %>" 
           class="btn btn-secondary">Quay lại</a>
    </div>

    <!-- Chú thích -->
    <div class="legend">
        <div class="legend-item">
            <div class="legend-color empty" style="background-color: #d1ecf1; border-color: #0dcaf0;"></div>
            <span>Slot trống (Có thể đặt hàng)</span>
        </div>
        <div class="legend-item">
            <div class="legend-color occupied" style="background-color: #d4edda; border-color: #28a745;"></div>
            <span>Slot có hàng</span>
        </div>
        <div class="legend-item">
            <div class="legend-color full" style="background-color: #fff3cd; border-color: #ffc107;"></div>
            <span>Slot đầy</span>
        </div>
        <div class="legend-item">
            <div class="legend-color blocked" style="background-color: #f8d7da; border-color: #dc3545;"></div>
            <span>Slot bị khóa</span>
        </div>
    </div>

    <!-- Hướng dẫn -->
    <div class="instructions">
        <strong>Hướng dẫn:</strong>
        <ul class="mb-0">
            <li>Click vào slot để xem chi tiết và quản lý sản phẩm trong slot đó</li>
            <li>Slot trống (màu xanh nhạt) sẽ được làm nổi bật để dễ nhận biết</li>
            <li>Slot có hàng hiển thị màu xanh lá, slot đầy màu vàng, slot bị khóa màu đỏ</li>
        </ul>
    </div>

    <!-- Slot Grid -->
    <div class="slot-grid-container">
        <div class="screen-indicator">KHU VỰC VẬN HÀNH</div>
        
        <div class="slot-grid" id="slotGrid" style="grid-template-columns: 30px repeat(<%= maxCol > 0 ? maxCol : 10 %>, 80px); grid-template-rows: 30px repeat(<%= maxRow > 0 ? maxRow : 8 %>, 80px);">
            <!-- Header row -->
            <div></div>
            <% for (int col = 1; col <= maxCol; col++) { %>
            <div class="col-header"><%= col %></div>
            <% } %>
            
            <!-- Slot rows -->
            <% for (int row = 1; row <= maxRow; row++) { %>
                <div class="row-label"><%= (char)('A' + row - 1) %></div>
                <% for (int col = 1; col <= maxCol; col++) { 
                    SlotDetailDTO slot = null;
                    if (slotGrid.containsKey(row) && slotGrid.get(row).containsKey(col)) {
                        slot = slotGrid.get(row).get(col);
                    }
                %>
                    <% if (slot != null) { %>
                        <div class="slot-item 
                            <%= slot.getStatus().equals("BLOCKED") ? "blocked" : 
                                (slot.getIsEmpty() ? "empty" : 
                                (slot.getMaxCapacity() != null && slot.getUsedCapacity().compareTo(slot.getMaxCapacity()) >= 0 ? "full" : "occupied")) %>"
                             data-slot-id="<%= slot.getSlotId() %>"
                             onclick="openSlotDetail(<%= slot.getSlotId() %>)">
                            <div class="slot-code"><%= slot.getSlotCode() %></div>
                            <% if (!slot.getIsEmpty()) { %>
                                <div class="slot-info">
                                    <%= slot.getProducts().size() %> SP<br>
                                    <%= slot.getUsedCapacity() != null ? slot.getUsedCapacity().stripTrailingZeros().toPlainString() : "0" %>
                                </div>
                            <% } else { %>
                                <div class="slot-info">Trống</div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div style="width: 80px; height: 80px;"></div>
                    <% } %>
                <% } %>
            <% } %>
        </div>
    </div>
</div>

<!-- Modal chi tiết Slot -->
<div class="modal fade" id="slotDetailModal" tabindex="-1" aria-labelledby="slotDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="slotDetailModalLabel">Chi tiết Slot</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
const warehouseId = <%= warehouseId %>;
const zoneId = <%= zone.getZoneId() %>;
const variants = [
    <% if (variants != null) {
        for (int i = 0; i < variants.size(); i++) {
            ProductVariantDTO v = variants.get(i);
            if (i > 0) out.print(",");
    %>
    {
        variantId: <%= v.getVariantId() %>,
        variantSku: "<%= v.getVariantSku() != null ? v.getVariantSku().replace("\"", "\\\"") : "" %>",
        productName: "<%= v.getProductName() != null ? v.getProductName().replace("\"", "\\\"") : "" %>"
    }<% } } %>
];

function openSlotDetail(slotId) {
    const modal = new bootstrap.Modal(document.getElementById('slotDetailModal'));
    const modalContent = document.getElementById('slotDetailContent');
    modalContent.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
    modal.show();
    
    loadSlotDetail(slotId);
}

function loadSlotDetail(slotId) {
    const modalContent = document.getElementById('slotDetailContent');
    
    fetch('<%= request.getContextPath() %>/warehouse-layout?action=slot-detail&slotId=' + slotId + '&warehouseId=' + warehouseId)
        .then(response => response.json())
        .then(data => {
            displaySlotDetail(data, slotId);
        })
        .catch(error => {
            modalContent.innerHTML = '<div class="alert alert-danger">Lỗi: ' + error.message + '</div>';
        });
}

function displaySlotDetail(slot, slotId) {
    const modalContent = document.getElementById('slotDetailContent');
    let html = '<div class="mb-3">';
    html += '<h6>Thông tin Slot</h6>';
    html += '<table class="table table-sm">';
    html += '<tr><td><strong>Mã Slot:</strong></td><td>' + (slot.slotCode || '') + '</td></tr>';
    html += '<tr><td><strong>Trạng thái:</strong></td><td><span class="badge bg-' + 
        (slot.status === 'ACTIVE' ? 'success' : slot.status === 'BLOCKED' ? 'danger' : 'secondary') + '">' + 
        (slot.status || '') + '</span></td></tr>';
    html += '<tr><td><strong>Trống:</strong></td><td>' + (slot.isEmpty ? 'Có' : 'Không') + '</td></tr>';
    html += '<tr><td><strong>Đã sử dụng:</strong></td><td>' + (slot.usedCapacity || '0') + '</td></tr>';
    html += '<tr><td><strong>Còn trống:</strong></td><td>' + (slot.availableCapacity || '0') + '</td></tr>';
    html += '<tr><td><strong>Sức chứa tối đa:</strong></td><td>' + (slot.maxCapacity || 'Không giới hạn') + '</td></tr>';
    html += '</table></div>';
    
    html += '<div class="mb-3"><h6>Sản phẩm trong slot</h6>';
    if (slot.products && slot.products.length > 0) {
        html += '<div class="table-responsive"><table class="table table-sm table-bordered">';
        html += '<thead><tr><th>SKU</th><th>Tên sản phẩm</th><th>Điều kiện</th><th>Tồn kho</th><th>Có sẵn</th></tr></thead><tbody>';
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
        html += '<p class="text-muted">Chưa có sản phẩm nào trong slot này</p>';
    }
    html += '</div>';
    
    html += '<div><h6>Thêm sản phẩm vào slot</h6>';
    html += '<form method="post" action="<%= request.getContextPath() %>/warehouse-layout" id="assignProductForm">';
    html += '<input type="hidden" name="action" value="assign-product">';
    html += '<input type="hidden" name="warehouseId" value="' + warehouseId + '">';
    html += '<input type="hidden" name="slotId" value="' + slotId + '">';
    html += '<input type="hidden" name="zoneId" value="' + zoneId + '">';
    
    html += '<div class="row mb-3">';
    html += '<div class="col-md-6">';
    html += '<label class="form-label">Sản phẩm (Variant)</label>';
    html += '<select name="variantId" class="form-select" required>';
    html += '<option value="">-- Chọn sản phẩm --</option>';
    variants.forEach(v => {
        html += '<option value="' + v.variantId + '">' + v.variantSku + ' - ' + v.productName + '</option>';
    });
    html += '</select></div>';
    
    html += '<div class="col-md-3">';
    html += '<label class="form-label">Số lượng</label>';
    html += '<input type="number" name="qty" class="form-control" min="0.01" step="0.01" required>';
    html += '</div>';
    
    html += '<div class="col-md-3">';
    html += '<label class="form-label">Điều kiện</label>';
    html += '<select name="condition" class="form-select">';
    html += '<option value="GOOD">GOOD</option>';
    html += '<option value="DAMAGED">DAMAGED</option>';
    html += '<option value="EXPIRED">EXPIRED</option>';
    html += '</select></div></div>';
    
    html += '<button type="submit" class="btn btn-primary">Thêm sản phẩm</button>';
    html += '</form></div>';
    
    modalContent.innerHTML = html;
}
</script>

<jsp:include page="../layout/footer.jspf" />
