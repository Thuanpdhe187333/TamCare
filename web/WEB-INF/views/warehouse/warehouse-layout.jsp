<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.Warehouse"%>
<%@page import="model.Zone"%>
<%@page import="model.Slot"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>

<%
    List<Warehouse> warehouses = (List<Warehouse>) request.getAttribute("warehouses");
    List<Zone> zones = (List<Zone>) request.getAttribute("zones");
    Long selectedWarehouseId = (Long) request.getAttribute("selectedWarehouseId");
    String error = (String) request.getAttribute("error");
    Map<Long, Boolean> zoneHasSlots = (Map<Long, Boolean>) request.getAttribute("zoneHasSlots");
    if (zoneHasSlots == null) zoneHasSlots = new java.util.HashMap<>();
%>

<jsp:include page="../layout/head.jspf" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .zone-card {
        margin-bottom: 20px;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 15px;
    }
    .slot-grid {
        display: grid;
        gap: 5px;
        margin-top: 10px;
    }
    .slot-item {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: center;
        background-color: #f8f9fa;
        border-radius: 4px;
        font-size: 12px;
    }
    .slot-item.blocked {
        background-color: #dc3545;
        color: white;
    }
    .slot-item.active {
        background-color: #28a745;
        color: white;
    }
</style>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="mb-0">Tạo layout kho hàng</h4>
    </div>

    <% if (error != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <!-- Form chọn kho -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">Chọn kho</h5>
        </div>
        <div class="card-body">
            <form method="get" action="<%= request.getContextPath() %>/warehouse-layout">
                <div class="row">
                    <div class="col-md-6">
                        <label for="warehouseId" class="form-label">Kho hàng</label>
                        <select class="form-select" id="warehouseId" name="warehouseId" required onchange="this.form.submit()">
                            <option value="">-- Chọn kho --</option>
                            <% if (warehouses != null) {
                                for (Warehouse wh : warehouses) { %>
                            <option value="<%= wh.getWarehouseId() %>" 
                                    <%= (selectedWarehouseId != null && selectedWarehouseId.equals(wh.getWarehouseId())) ? "selected" : "" %>>
                                <%= wh.getCode() %> - <%= wh.getName() %>
                            </option>
                            <% }
                            } %>
                        </select>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <% if (selectedWarehouseId != null) { %>

    <!-- Form tạo Zone -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">Tạo Zone (Khu vực)</h5>
        </div>
        <div class="card-body">
            <form method="post" action="<%= request.getContextPath() %>/warehouse-layout">
                <input type="hidden" name="action" value="create-zone">
                <input type="hidden" name="warehouseId" value="<%= selectedWarehouseId %>">
                
                <div class="row">
                    <div class="col-md-3">
                        <label for="code" class="form-label">Mã Zone</label>
                        <input type="text" class="form-control" id="code" name="code" required>
                    </div>
                    <div class="col-md-4">
                        <label for="name" class="form-label">Tên Zone</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    <div class="col-md-3">
                        <label for="zoneType" class="form-label">Loại Zone</label>
                        <select class="form-select" id="zoneType" name="zoneType" required>
                            <option value="">-- Chọn loại --</option>
                            <option value="INBOUND">INBOUND</option>
                            <option value="QC">QC</option>
                            <option value="STORAGE">STORAGE</option>
                            <option value="PICKING">PICKING</option>
                            <option value="PACKING">PACKING</option>
                            <option value="DAMAGE">DAMAGE</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100">Tạo Zone</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Danh sách Zones -->
    <% if (zones != null && !zones.isEmpty()) { %>
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="mb-0">Danh sách Zones</h5>
        </div>
        <div class="card-body">
            <c:forEach items="${zones}" var="zone">
                <div class="zone-card">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h6 class="mb-1">
                                <span class="badge bg-info"><c:out value="${zone.code}" /></span>
                                <c:out value="${zone.name}" />
                            </h6>
                            <small class="text-muted">Loại: <c:out value="${zone.zoneType}" /> 
                                <span>Trạng thái: 
                                        <span class="badge bg-${zone.status == 'ACTIVE' ? 'success' : 'secondary'}">
                                                <c:out value="${zone.status}" /></span>
</span>
                            </small>
                        </div>
                        <div class="d-flex gap-2 align-items-center">
                            <a href="<%= request.getContextPath() %>/warehouse-layout?action=view-zone&zoneId=${zone.zoneId}&warehouseId=<%= selectedWarehouseId %>" 
                               class="btn btn-sm btn-outline-primary" style="min-width: 110px;">
                                Xem Layout
                            </a>
                            <c:set var="hasSlots" value="${zoneHasSlots[zone.zoneId]}" />
                            <button type="button" class="btn btn-sm <c:out value='${hasSlots ? "btn-outline-warning" : "btn-outline-secondary"}' />" 
                                    style="min-width: 140px;"
                                    data-bs-toggle="modal" 
                                    data-bs-target="#slotModal${zone.zoneId}">
                                <c:out value="${hasSlots ? 'Chỉnh sửa Layout' : 'Tạo Slots'}" />
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Modal tạo Slots cho Zone -->
                <div class="modal fade" id="slotModal${zone.zoneId}" tabindex="-1" aria-labelledby="slotModalLabel${zone.zoneId}" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="slotModalLabel${zone.zoneId}">
                                    <c:set var="hasSlots" value="${zoneHasSlots[zone.zoneId]}" />
                                    <c:out value="${hasSlots ? 'Chỉnh sửa Layout' : 'Tạo Slots'}" /> cho Zone: <c:out value="${zone.code}" /> - <c:out value="${zone.name}" />
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form method="post" action="<%= request.getContextPath() %>/warehouse-layout" id="slotForm${zone.zoneId}">
                                    <input type="hidden" name="action" value="create-slots">
                                    <input type="hidden" name="zoneId" value="${zone.zoneId}">
                                    
                                    <c:set var="hasSlots" value="${zoneHasSlots[zone.zoneId]}" />
                                    <c:if test="${hasSlots}">
                                    <div class="alert alert-warning">
                                        <strong>Lưu ý:</strong> Zone này đã có slots. Hệ thống sẽ chỉ thêm các slots mới chưa tồn tại.
                                        Slots đã tồn tại sẽ không bị thay đổi.
                                    </div>
                                    </c:if>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label for="rows${zone.zoneId}" class="form-label">Số hàng (Rows)</label>
                                            <input type="number" class="form-control" id="rows${zone.zoneId}" name="rows" min="1" max="100" value="5" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="cols${zone.zoneId}" class="form-label">Số cột (Columns)</label>
                                            <input type="number" class="form-control" id="cols${zone.zoneId}" name="cols" min="1" max="100" value="5" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="codePrefix${zone.zoneId}" class="form-label">Tiền tố mã Slot</label>
                                            <input type="text" class="form-control" id="codePrefix${zone.zoneId}" name="codePrefix" value="<c:out value="${zone.code}" />" required>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-info">
                                        <strong>Lưu ý:</strong> Hệ thống sẽ tạo grid slots với định dạng: 
                                        <code>[Tiền tố]-R[Row]-C[Column]</code>
                                        <br>Ví dụ: ZONE-A-R1-C1, ZONE-A-R1-C2, ...
                                        <c:if test="${hasSlots}">
                                        <br><strong>Các slots đã tồn tại sẽ được bỏ qua.</strong>
                                        </c:if>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary" form="slotForm${zone.zoneId}">
                                    <c:out value="${hasSlots ? 'Thêm Slots' : 'Tạo Slots'}" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <% } else { %>
    <div class="alert alert-info">
        Chưa có Zone nào. Vui lòng tạo Zone trước.
    </div>
    <% } %>

    <% } else { %>
    <div class="alert alert-warning">
        Vui lòng chọn kho hàng để bắt đầu tạo layout.
    </div>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function loadSlotsForZone(zoneId) {
    // Có thể load danh sách slots hiện có của zone này nếu cần
    console.log('Loading slots for zone: ' + zoneId);
}
</script>

<jsp:include page="../layout/footer.jspf" />
