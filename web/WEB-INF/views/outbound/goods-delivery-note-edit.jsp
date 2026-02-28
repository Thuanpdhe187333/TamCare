<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<t:layout title="Edit Goods Delivery Note">
    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/goods-delivery-note?action=list" class="text-decoration-none text-muted">Goods Delivery Note</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${gdn.gdnId}" class="text-decoration-none text-muted">${gdn.gdnNumber}</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Edit</li>
                </ol>
            </nav>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-warning">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/goods-delivery-note" method="post">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="gdnId" value="${gdn.gdnId}" />

            <div class="card shadow-sm border-0 mb-4">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="card-title mb-0"><i class="fas fa-edit me-2"></i>Update GDN</h5>
                </div>
                <div class="card-body">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3 mb-4">
                        <div class="col">
                            <p class="text-muted small mb-1 text-uppercase fw-bold">GDN Number</p>
                            <p class="mb-0 fw-semibold">${gdn.gdnNumber}</p>
                        </div>
                        <div class="col">
                            <p class="text-muted small mb-1 text-uppercase fw-bold">Sales Order</p>
                            <p class="mb-0 fw-semibold">${gdn.soNumber}</p>
                        </div>
                        <div class="col">
                            <p class="text-muted small mb-1 text-uppercase fw-bold">Customer</p>
                            <p class="mb-0 fw-semibold">${gdn.customerName}</p>
                        </div>
                        <div class="col">
                            <p class="text-muted small mb-1 text-uppercase fw-bold">Created At</p>
                            <p class="mb-0 fw-semibold">${gdn.createdAtDisplay}</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Status</label>
                            <select name="status" class="form-control" required>
                                <option value="PENDING" ${gdn.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                <option value="DRAFT" ${gdn.status == 'DRAFT' ? 'selected' : ''}>DRAFT</option>
                                <option value="ONGOING" ${gdn.status == 'ONGOING' ? 'selected' : ''}>ONGOING</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center">
                <a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${gdn.gdnId}" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Cancel
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-1"></i> Update
                </button>
            </div>
        </form>
    </div>
</t:layout>
