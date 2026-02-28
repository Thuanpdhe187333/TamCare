<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<t:layout title="Create Goods Delivery Note">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <div class="container-fluid py-4">
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                class="text-decoration-none text-muted">
                <i class="fas fa-arrow-left me-1"></i> Back to List
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/goods-delivery-note" method="post" id="gdnForm">
            <input type="hidden" name="action" value="create" />

            <div class="row">
                <div class="col-lg-12">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-primary text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-file-invoice me-2"></i>Header Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">Sales Order Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-shopping-cart"></i></span>
                                        <select class="form-control" name="soNumber" id="soSelect" required>
                                            <option value="">-- Choose Sales Order --</option>
                                            <c:forEach var="so" items="${salesOrders}">
                                                <option value="${so.soNumber}">${so.soNumber} - ${so.customerName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <!-- Status set to PENDING when created (same as GRN) -->
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-dark text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-boxes me-2"></i>Items to Pick</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" id="itemsTable">
                                    <thead class="table-light">
                                        <tr class="text-center">
                                            <th>Variant SKU</th>
                                            <th>Product Name</th>
                                            <th>Color</th>
                                            <th>Size</th>
                                            <th>Quantity Required</th>
                                            <th>Available</th>
                                        </tr>
                                    </thead>
                                    <tbody id="itemsTableBody">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                Please select a Sales Order to view items
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12 mt-4">
                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                            class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-1"></i> Create GDN
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('soSelect').addEventListener('change', function() {
            const soNumber = this.value;
            if (!soNumber) {
                document.getElementById('itemsTableBody').innerHTML = 
                    '<tr><td colspan="6" class="text-center text-muted py-4">Please select a Sales Order to view items</td></tr>';
                return;
            }

            fetch('${pageContext.request.contextPath}/goods-delivery-note?action=getSoDetails&soNumber=' + soNumber)
                .then(response => response.json())
                .then(data => {
                    let html = '';
                    if (data.lines && data.lines.length > 0) {
                        data.lines.forEach(line => {
                            html += '<tr class="text-center">';
                            html += '<td>' + (line.variantSku || 'N/A') + '</td>';
                            html += '<td>' + (line.productName || 'N/A') + '</td>';
                            html += '<td>' + (line.color || 'N/A') + '</td>';
                            html += '<td>' + (line.size || 'N/A') + '</td>';
                            html += '<td><strong>' + (line.qtyOrdered || 0) + '</strong></td>';
                            html += '<td>' + (line.qtyAvailable || 0) + '</td>';
                            html += '</tr>';
                        });
                    } else {
                        html = '<tr><td colspan="6" class="text-center text-muted py-4">No items found</td></tr>';
                    }
                    document.getElementById('itemsTableBody').innerHTML = html;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('itemsTableBody').innerHTML = 
                        '<tr><td colspan="6" class="text-center text-danger py-4">Error loading items</td></tr>';
                });
        });
    </script>
</t:layout>
