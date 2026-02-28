<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<t:layout title="Create Shipment">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <div class="container-fluid py-4">
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                class="text-decoration-none text-muted">
                <i class="fas fa-arrow-left me-1"></i> Back to GDN List
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/shipment" method="post" id="shipmentForm">
            <input type="hidden" name="action" value="create" />
            <input type="hidden" name="gdnId" id="gdnId" value="${param.gdnId}" />

            <div class="row">
                <div class="col-lg-12">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-primary text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-truck me-2"></i>Shipment Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Sales Order Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-shopping-cart"></i></span>
                                        <input type="text" class="form-control" name="soNumber" id="soNumber" 
                                            value="${param.soNumber}" required>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-secondary mt-2" onclick="loadSoInfo()">
                                        <i class="fas fa-search me-1"></i> Load SO Info
                                    </button>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Carrier</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-truck"></i></span>
                                        <select class="form-control" name="carrierId" required>
                                            <option value="">-- Choose Carrier --</option>
                                            <c:forEach var="carrier" items="${carriers}">
                                                <option value="${carrier.carrierId}">${carrier.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Shipment Type</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-info-circle"></i></span>
                                        <select class="form-control" name="shipmentType" required>
                                            <option value="STANDARD">STANDARD</option>
                                            <option value="EXPRESS">EXPRESS</option>
                                            <option value="OVERNIGHT">OVERNIGHT</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12" id="soInfoCard" style="display: none;">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-info text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>Customer Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <p class="text-muted small mb-1 text-uppercase fw-bold">Customer Name</p>
                                    <p class="mb-0 fw-semibold" id="customerName">-</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="text-muted small mb-1 text-uppercase fw-bold">Ship To Address</p>
                                    <p class="mb-0 text-secondary" id="shipToAddress">-</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="text-muted small mb-1 text-uppercase fw-bold">Requested Ship Date</p>
                                    <p class="mb-0 fw-semibold" id="requestedShipDate">-</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="text-muted small mb-1 text-uppercase fw-bold">GDN Number</p>
                                    <p class="mb-0 fw-semibold" id="gdnNumber">-</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 mt-4">
                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                            class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i> Create Shipment
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        function loadSoInfo() {
            const soNumber = document.getElementById('soNumber').value;
            if (!soNumber) {
                Swal.fire('Error', 'Please enter a Sales Order Number', 'error');
                return;
            }

            fetch('${pageContext.request.contextPath}/shipment?action=getSoInfo&soNumber=' + soNumber)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Sales Order not found');
                    }
                    return response.json();
                })
                .then(data => {
                    document.getElementById('customerName').textContent = data.customerName || '-';
                    document.getElementById('shipToAddress').textContent = data.shipToAddress || '-';
                    document.getElementById('requestedShipDate').textContent = data.requestedShipDate || '-';
                    document.getElementById('gdnNumber').textContent = data.gdnNumber || '-';
                    document.getElementById('gdnId').value = data.gdnId || '';
                    document.getElementById('soInfoCard').style.display = 'block';
                })
                .catch(error => {
                    Swal.fire('Error', error.message, 'error');
                });
        }

        // Auto-load if soNumber is provided
        <c:if test="${not empty param.soNumber}">
            window.addEventListener('DOMContentLoaded', function() {
                loadSoInfo();
            });
        </c:if>
    </script>
</t:layout>
