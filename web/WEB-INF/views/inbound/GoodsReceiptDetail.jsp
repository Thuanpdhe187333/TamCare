<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<t:layout title="Goods Receipt Details">
    <div class="py-2">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 bg-transparent p-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                           class="text-decoration-none text-muted">Goods Receipt</a>
                    </li>
                    <li class="breadcrumb-item active text-primary font-weight-bold" aria-current="page">
                        ${grn.grnNumber}</li>
                </ol>
            </nav>
            <span
                class="badge badge-pill ${grn.status == 'PENDING' ? 'badge-warning' : (grn.status == 'APPROVED' ? 'badge-success' : 'badge-danger')} px-3 py-2 shadow-sm">
                <i
                    class="fas ${grn.status == 'PENDING' ? 'fa-clock' : (grn.status == 'APPROVED' ? 'fa-check-circle' : 'fa-times-circle')} mr-1"></i>
                ${grn.status}
            </span>
        </div>

        <div class="row">
            <div class="col-lg-12">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-primary text-white py-3">
                        <h6 class="m-0 font-weight-bold"><i class="fas fa-info-circle mr-2"></i>General
                            Information</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">GRN Number
                                </p>
                                <p class="mb-0 font-weight-bold">${grn.grnNumber}</p>
                            </div>
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Reference
                                    PO ID</p>
                                <p class="mb-0 font-weight-bold">#${grn.poId}</p>
                            </div>
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Warehouse
                                </p>
                                <p class="mb-0 font-weight-bold">
                                    <i class="fas fa-warehouse mr-1 text-primary"></i> ${grn.warehouseId}
                                </p>
                            </div>
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Delivered
                                    By</p>
                                <p class="mb-0 font-weight-bold">
                                    <i class="fas fa-truck mr-1 text-primary"></i> ${not empty
                                                                                     grn.deliveredBy ? grn.deliveredBy : '--'}
                                </p>
                            </div>
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Created At
                                </p>
                                <p class="mb-0 font-weight-bold">${grn.createdAt}</p>
                            </div>
                            <div class="col-md-3 mb-3">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Status</p>
                                <p class="mb-0 font-weight-bold">${grn.status}</p>
                            </div>
                            <div class="col-lg-12">
                                <hr class="my-2">
                                <p class="text-muted small mb-1 text-uppercase font-weight-bold">Internal
                                    Note</p>
                                <p class="mb-0 font-italic text-secondary">${not empty grn.note ? grn.note :
                                                                             'No notes provided.'}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-12">
                <div class="card shadow-sm border-0 mb-4">
                    <div class="card-header bg-dark text-white py-3">
                        <h6 class="m-0 font-weight-bold text-white"><i class="fas fa-list mr-2"></i>SKU
                            Details</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-items-center table-flush mb-0">
                                <thead class="thead-light">
                                    <tr class="text-center">
                                        <th>Variant ID</th>
                                        <th>Expected</th>
                                        <th>Good</th>
                                        <th>Damaged</th>
                                        <th>Missing</th>
                                        <th>Extra</th>
                                        <th class="text-left">Note</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="l" items="${lines}">
                                        <tr class="text-center">
                                            <td class="font-weight-bold text-dark">#${l.variantId}</td>
                                            <td><span
                                                    class="badge badge-light border">${l.qtyExpected}</span>
                                            </td>
                                            <td><span class="badge badge-success px-3">${l.qtyGood}</span>
                                            </td>
                                            <td><span class="badge badge-danger px-3">${l.qtyDamaged}</span>
                                            </td>
                                            <td><span
                                                    class="badge badge-warning px-3">${l.qtyMissing}</span>
                                            </td>
                                            <td><span class="badge badge-info px-3">${l.qtyExtra}</span>
                                            </td>
                                            <td class="text-left small text-muted">${l.note}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div
            class="d-flex justify-content-between align-items-center mt-3 p-3 bg-white rounded shadow-sm border">
            <div>
                <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                   class="btn btn-outline-secondary mr-2">
                    <i class="fas fa-arrow-left mr-1"></i> Back to List
                </a>
                <a href="${pageContext.request.contextPath}/putaway?grnId=${grn.grnId}"
                   class="btn btn-primary shadow-sm px-4">
                    <i class="fas fa-dolly mr-2"></i>Go to Putaway
                </a>
            </div>

            <c:if test="${grn.status == 'PENDING'}">
                <div class="d-flex">
                    <form action="${pageContext.request.contextPath}/goods-receipt" method="post"
                          onsubmit="return confirm('Are you sure you want to approve this GRN?')"
                          class="mr-2">
                        <input type="hidden" name="action" value="approve">
                        <input type="hidden" name="id" value="${grn.grnId}">
                        <button type="submit" class="btn btn-success px-4 shadow-sm">
                            <i class="fas fa-check mr-2"></i>Approve
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/goods-receipt" method="post"
                          onsubmit="return confirm('Are you sure you want to reject this GRN?')">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="id" value="${grn.grnId}">
                        <button type="submit" class="btn btn-danger px-4 shadow-sm">
                            <i class="fas fa-times mr-2"></i>Reject
                        </button>
                    </form>
                </div>
            </c:if>
        </div>
    </div>

    <style>
        .breadcrumb-item+.breadcrumb-item::before {
            content: "›";
            font-size: 1.2rem;
            vertical-align: middle;
        }

        .card {
            border-radius: 0.75rem;
            overflow: hidden;
        }

        .table th {
            font-weight: 600;
            letter-spacing: 0.5px;
        }
    </style>
</t:layout>