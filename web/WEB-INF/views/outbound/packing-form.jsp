<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<t:layout title="Packing – ${gdn.gdnNumber}">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/packing?action=list">Packing</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${gdn.gdnId}">${gdn.gdnNumber}</a></li>
                    <li class="breadcrumb-item active">Pack</li>
                </ol>
            </nav>
            <a href="${pageContext.request.contextPath}/goods-delivery-note?action=detail&id=${gdn.gdnId}" class="btn btn-outline-secondary">Back to GDN</a>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white py-2"><h5 class="mb-0">GDN ${gdn.gdnNumber} – ${gdn.soNumber}</h5></div>
            <div class="card-body">
                <div class="row row-cols-2 row-cols-md-4 g-2 small">
                    <div class="col"><strong>Customer:</strong> ${gdn.customerName}</div>
                    <div class="col"><strong>Status:</strong> ${gdn.status}</div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-dark text-white py-2"><h5 class="mb-0">Lines (qty picked → pack)</h5></div>
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr class="text-center">
                            <th>Variant / Product</th>
                            <th>Qty required</th>
                            <th>Qty picked</th>
                            <th>Qty packed</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="line" items="${gdn.lines}">
                            <tr>
                                <td>${line.variantSku} – ${line.productName}</td>
                                <td class="text-center"><fmt:formatNumber value="${line.qtyRequired}" maxFractionDigits="0"/></td>
                                <td class="text-center"><fmt:formatNumber value="${line.qtyPicked}" maxFractionDigits="0"/></td>
                                <td class="text-center"><fmt:formatNumber value="${line.qtyPacked}" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-secondary text-white py-2"><h5 class="mb-0">Complete packing</h5></div>
            <div class="card-body">
                <c:if test="${packing.status != 'DONE'}">
                    <form action="${pageContext.request.contextPath}/packing" method="post">
                        <input type="hidden" name="action" value="save"/>
                        <input type="hidden" name="packId" value="${packing.packId}"/>
                        <input type="hidden" name="gdnId" value="${gdn.gdnId}"/>
                        <div class="mb-3">
                            <label class="form-label">Package label</label>
                            <input type="text" name="packageLabel" class="form-control" placeholder="e.g. Box 1" value="${packing.packageLabel}"/>
                        </div>
                        <button type="submit" class="btn btn-success"><i class="fas fa-check me-1"></i> Save & mark packed</button>
                    </form>
                </c:if>
                <c:if test="${packing.status == 'DONE'}">
                    <p class="mb-0 text-success">
                        Packing completed. Label: ${packing.packageLabel}
                        <c:if test="${not empty packing.packedAt}">
                            | Packed at: <c:out value="${packing.packedAt}" />
                        </c:if>
                    </p>
                </c:if>
            </div>
        </div>
    </div>
</t:layout>
