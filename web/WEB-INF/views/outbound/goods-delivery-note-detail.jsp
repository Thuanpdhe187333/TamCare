<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<t:layout title="Goods Delivery Note Details">
    <div class="container-fluid py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a
                            href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                            class="text-decoration-none text-muted">Goods Delivery Note</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${gdn.gdnNumber}</li>
                </ol>
            </nav>
            <span class="badge ${gdn.status == 'DRAFT' ? 'bg-secondary' : (gdn.status == 'ONGOING' ? 'bg-warning text-dark' : 'bg-success')} px-3 py-2 rounded-pill shadow-sm">
                <i class="fas ${gdn.status == 'DRAFT' ? 'fa-file' : (gdn.status == 'ONGOING' ? 'fa-clock' : 'fa-check-circle')} me-1"></i>
                ${gdn.status}
            </span>
        </div>

        <div class="row g-4">
            <div class="col-lg-12">
                <div class="card shadow-sm border-0">
                    <div class="card-header bg-primary text-white py-3">
                        <h5 class="card-title mb-0"><i class="fas fa-info-circle me-2"></i>General Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-3">
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
                                <p class="mb-0 fw-semibold">
                                    <fmt:formatDate value="${gdn.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                </p>
                            </div>
                            <div class="col">
                                <p class="text-muted small mb-1 text-uppercase fw-bold">Status</p>
                                <p class="mb-0">
                                    <span class="badge ${gdn.status == 'DRAFT' ? 'bg-secondary' : (gdn.status == 'ONGOING' ? 'bg-warning' : 'bg-success')} fw-semibold">
                                        ${gdn.status}
                                    </span>
                                </p>
                            </div>
                            <div class="col">
                                <p class="text-muted small mb-1 text-uppercase fw-bold">Created By</p>
                                <p class="mb-0 fw-semibold">${gdn.creatorName}</p>
                            </div>
                            <c:if test="${not empty gdn.confirmedAt}">
                                <div class="col">
                                    <p class="text-muted small mb-1 text-uppercase fw-bold">Confirmed At</p>
                                    <p class="mb-0 fw-semibold">
                                        <fmt:formatDate value="${gdn.confirmedAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </p>
                                </div>
                            </c:if>
                            <div class="col-lg-12">
                                <hr class="my-2 opacity-10">
                                <p class="text-muted small mb-1 text-uppercase fw-bold">Ship To Address</p>
                                <p class="mb-0 text-secondary">${gdn.customerAddress != null && gdn.customerAddress != '' ? gdn.customerAddress : 'No address provided.'}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-12">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-dark text-white py-3">
                        <h5 class="card-title mb-0"><i class="fas fa-list me-2"></i>Items to Pick</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light text-secondary text-uppercase small">
                                    <tr class="text-center">
                                        <th class="text-start">Variant SKU</th>
                                        <th class="text-start">Product Name</th>
                                        <th>Color</th>
                                        <th>Size</th>
                                        <th>Qty Required</th>
                                        <th>Qty Picked</th>
                                        <th>Qty Packed</th>
                                        <th>Available</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="line" items="${gdn.lines}">
                                        <tr class="text-center">
                                            <td class="text-start fw-bold">${line.variantSku}</td>
                                            <td class="text-start">${line.productName}</td>
                                            <td>${line.color != null ? line.color : 'N/A'}</td>
                                            <td>${line.size != null ? line.size : 'N/A'}</td>
                                            <td><strong><fmt:formatNumber value="${line.qtyRequired}" maxFractionDigits="0" /></strong></td>
                                            <td><span class="badge bg-info"><fmt:formatNumber value="${line.qtyPicked}" maxFractionDigits="0" /></span></td>
                                            <td><span class="badge bg-warning"><fmt:formatNumber value="${line.qtyPacked}" maxFractionDigits="0" /></span></td>
                                            <td><span class="badge bg-success"><fmt:formatNumber value="${line.qtyAvailable}" maxFractionDigits="0" /></span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mt-3 p-3 bg-white rounded shadow-sm border">
            <div>
                <a href="${pageContext.request.contextPath}/goods-delivery-note?action=list"
                    class="btn btn-outline-secondary me-2">
                    <i class="fas fa-arrow-left me-1"></i> Back to List
                </a>
            </div>

            <c:if test="${gdn.status == 'DRAFT' || gdn.status == 'ONGOING'}">
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/goods-delivery-note?action=edit&id=${gdn.gdnId}"
                        class="btn btn-warning shadow-sm text-dark">
                        <i class="fas fa-edit me-2"></i>Edit
                    </a>
                    <c:if test="${gdn.status == 'DRAFT'}">
                        <a href="${pageContext.request.contextPath}/pick-task?action=assign&gdnId=${gdn.gdnId}"
                            class="btn btn-primary shadow-sm">
                            <i class="fas fa-user-check me-2"></i>Assign Pick Task
                        </a>
                    </c:if>
                    <c:if test="${gdn.status == 'CONFIRMED'}">
                        <a href="${pageContext.request.contextPath}/shipment?action=create&gdnId=${gdn.gdnId}&soNumber=${gdn.soNumber}"
                            class="btn btn-success shadow-sm">
                            <i class="fas fa-truck me-2"></i>Create Shipment
                        </a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</t:layout>
