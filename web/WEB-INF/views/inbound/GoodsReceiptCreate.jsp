<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<t:layout title="Create Goods Receipt Note">
    <div class="container-fluid py-4">
        <!-- Back Link -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
               class="text-decoration-none text-muted">
                <i class="fas fa-arrow-left me-1"></i> Back to List
            </a>
        </div>

        <form action="${pageContext.request.contextPath}/goods-receipt" method="post" id="grnForm">
            <input type="hidden" name="action" value="save" />

            <div class="row">
                <!-- Header Section -->
                <div class="col-lg-12">
                    <div class="card shadow-sm border-0 mb-4">
                        <div class="card-header bg-primary text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-file-invoice me-2"></i>Header
                                Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">GRN Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i
                                                class="fas fa-hashtag"></i></span>
                                        <input class="form-control" name="grnNumber"
                                               placeholder="GRN-YYYY-XXXX" required>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">Reference PO ID</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i
                                                class="fas fa-shopping-cart"></i></span>
                                        <input type="number" class="form-control" name="poId" required>
                                    </div>
                                    <small class="text-muted">Enter the related Purchase Order ID</small>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">Warehouse ID</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i
                                                class="fas fa-warehouse"></i></span>
                                        <input type="number" class="form-control" name="warehouseId"
                                               value="1" required>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label fw-bold">Delivered By</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i
                                                class="fas fa-truck"></i></span>
                                        <input class="form-control" name="deliveredBy"
                                               placeholder="Driver name / Carrier">
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold">Internal Note</label>
                                    <textarea class="form-control" name="note" rows="2"
                                              placeholder="Any special instructions or observations..."></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Lines Section -->
                <div class="col-lg-12">
                    <div class="card shadow-sm border-0">
                        <div
                            class="card-header d-flex justify-content-between align-items-center bg-dark text-white py-3">
                            <h5 class="card-title mb-0"><i class="fas fa-boxes me-2"></i>SKU Details</h5>
                            <button type="button" class="btn btn-sm btn-outline-light" onclick="addLine()">
                                <i class="fas fa-plus me-1"></i> Add Line
                            </button>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" id="linesTable">
                                    <thead
                                        class="table-light text-center text-secondary text-uppercase small">
                                        <tr>
                                            <th style="min-width: 150px;">Variant ID</th>
                                            <th style="width: 120px;">Expected</th>
                                            <th style="width: 120px;">Good</th>
                                            <th style="width: 120px;">Damaged</th>
                                            <th style="width: 120px;">Missing</th>
                                            <th style="width: 120px;">Extra</th>
                                            <th>Note</th>
                                            <th style="width: 50px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer bg-light py-3 d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                               class="btn btn-outline-secondary px-4">Cancel</a>
                            <button class="btn btn-success px-5 shadow-sm" type="submit">
                                <i class="fas fa-save me-2"></i>Save Goods Receipt
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</t:layout>

<style>
    .input-group-text {
        border-right: none;
    }

    .form-control:focus+.input-group-text {
        border-color: #86b7fe;
    }

    .table th {
        font-weight: 600;
    }

    .card {
        border-radius: 0.5rem;
        overflow: hidden;
    }
</style>

<script>
    let idx = 0;
    function addLine() {
        const tbody = document.querySelector("#linesTable tbody");
        const tr = document.createElement("tr");
        tr.className = "line-row";
        tr.innerHTML = `
<td><input type="number" class="form-control form-control-sm" name="lines[${idx}].variantId" required placeholder="ID"></td>
<td><input type="number" step="0.01" class="form-control form-control-sm text-center" name="lines[${idx}].qtyExpected" value="0"></td>
<td><input type="number" step="0.01" class="form-control form-control-sm text-center border-success-subtle" name="lines[${idx}].qtyGood" value="0"></td>
<td><input type="number" step="0.01" class="form-control form-control-sm text-center border-danger-subtle" name="lines[${idx}].qtyDamaged" value="0"></td>
<td><input type="number" step="0.01" class="form-control form-control-sm text-center border-warning-subtle" name="lines[${idx}].qtyMissing" value="0"></td>
<td><input type="number" step="0.01" class="form-control form-control-sm text-center border-info-subtle" name="lines[${idx}].qtyExtra" value="0"></td>
<td><input type="text" class="form-control form-control-sm" name="lines[${idx}].note" placeholder="Remark"></td>
<td class="text-center">
    <button type="button" class="btn btn-link text-danger p-0" onclick="removeLine(this)">
        <i class="fas fa-trash-alt"></i>
    </button>
</td>
`;
        tbody.appendChild(tr);
        idx++;
    }

    function removeLine(btn) {
        btn.closest('tr').remove();
    }

    // Initialize with one line
    document.addEventListener("DOMContentLoaded", function () {
        addLine();
    });
</script>