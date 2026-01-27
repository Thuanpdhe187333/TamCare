<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <t:layout title="Goods Receipt Details">
                <div class="container-fluid py-4">
                    <!-- Breadcrumb / Back Link -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a
                                        href="${pageContext.request.contextPath}/goods-receipt?action=list"
                                        class="text-decoration-none text-muted">Goods Receipt</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${grn.grnNumber}</li>
                            </ol>
                        </nav>
                        <span
                            class="badge ${grn.status == 'PENDING' ? 'bg-warning text-dark' : (grn.status == 'APPROVED' ? 'bg-success' : 'bg-danger')} px-3 py-2 rounded-pill shadow-sm">
                            <i
                                class="fas ${grn.status == 'PENDING' ? 'fa-clock' : (grn.status == 'APPROVED' ? 'fa-check-circle' : 'fa-times-circle')} me-1"></i>
                            ${grn.status}
                        </span>
                    </div>

                    <div class="row g-4">
                        <!-- Header Info Card -->
                        <div class="col-lg-12">
                            <div class="card shadow-sm border-0">
                                <div class="card-header bg-primary text-white py-3">
                                    <h5 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>General
                                        Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3">
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">GRN Number</p>
                                            <p class="mb-0 fw-semibold">${grn.grnNumber}</p>
                                        </div>
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Reference PO ID
                                            </p>
                                            <p class="mb-0 fw-semibold">#${grn.poId}</p>
                                        </div>
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Warehouse</p>
                                            <p class="mb-0 fw-semibold"><i
                                                    class="fas fa-warehouse me-1 text-primary"></i>
                                                ${grn.warehouseId}</p>
                                        </div>
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Delivered By</p>
                                            <p class="mb-0 fw-semibold"><i class="fas fa-truck me-1 text-primary"></i>
                                                ${grn.deliveredBy !=
                                                null ? grn.deliveredBy : '--'}</p>
                                        </div>
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Created At</p>
                                            <p class="mb-0 fw-semibold">${grn.createdAt}</p>
                                        </div>
                                        <div class="col">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Status</p>
                                            <p class="mb-0 fw-semibold">${grn.status}</p>
                                        </div>
                                        <div class="col-lg-12">
                                            <hr class="my-2 opacity-10">
                                            <p class="text-muted small mb-1 text-uppercase fw-bold">Internal Note
                                            </p>
                                            <p class="mb-0 italic text-secondary">${grn.note != null && grn.note !=
                                                '' ? grn.note : 'No notes provided.'}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- SKU Lines Card -->
                        <div class="col-lg-12">
                            <div class="card shadow-sm border-0 mb-4">
                                <div class="card-header bg-dark text-white py-3">
                                    <h5 class="card-title mb-0"><i class="fas fa-list me-2"></i>SKU Details</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light text-secondary text-uppercase small">
                                                <tr class="text-center">
                                                    <th>Variant ID</th>
                                                    <th>Expected</th>
                                                    <th>Good</th>
                                                    <th>Damaged</th>
                                                    <th>Missing</th>
                                                    <th>Extra</th>
                                                    <th class="text-start">Note</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="l" items="${lines}">
                                                    <tr class="text-center">
                                                        <td class="fw-bold text-dark">#${l.variantId}</td>
                                                        <td><span
                                                                class="badge bg-light text-dark border">${l.qtyExpected}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge bg-success-subtle text-success px-3">${l.qtyGood}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge bg-danger-subtle text-danger px-3">${l.qtyDamaged}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge bg-warning-subtle text-warning px-3">${l.qtyMissing}</span>
                                                        </td>
                                                        <td><span
                                                                class="badge bg-info-subtle text-info px-3">${l.qtyExtra}</span>
                                                        </td>
                                                        <td class="text-start small text-muted">${l.note}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div
                        class="d-flex justify-content-between align-items-center mt-3 p-3 bg-white rounded shadow-sm border">
                        <div>
                            <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                                class="btn btn-outline-secondary me-2">
                                <i class="fas fa-arrow-left me-1"></i> Back to List
                            </a>
                            <a href="${pageContext.request.contextPath}/putaway?grnId=${grn.grnId}"
                                class="btn btn-primary shadow-sm px-4">
                                <i class="fas fa-dolly me-2"></i>Go to Putaway
                            </a>
                        </div>

                        <c:if test="${grn.status == 'PENDING'}">
                            <div class="d-flex gap-2">
                                <form action="${pageContext.request.contextPath}/goods-receipt" method="post"
                                    onsubmit="return confirm('Are you sure you want to approve this GRN?')">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="id" value="${grn.grnId}">
                                    <button type="submit" class="btn btn-success px-4 shadow-sm">
                                        <i class="fas fa-check me-2"></i>Approve
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/goods-receipt" method="post"
                                    onsubmit="return confirm('Are you sure you want to reject this GRN?')">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="id" value="${grn.grnId}">
                                    <button type="submit" class="btn btn-danger px-4 shadow-sm">
                                        <i class="fas fa-times me-2"></i>Reject
                                    </button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                </div>

            </t:layout>