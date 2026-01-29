<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
        <%@taglib uri="jakarta.tags.core" prefix="c" %>
            <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                <t:layout title="Goods Receipt Putaway">
                    <div class="container-fluid py-4">
                        <!-- Back Link -->
                        <div class="mb-3">
                            <a href="${pageContext.request.contextPath}/goods-receipt?action=detail&id=${grn.grnId}"
                                class="text-decoration-none text-muted">
                                <i class="fas fa-arrow-left me-1"></i> Back to Detail
                            </a>
                        </div>

                        <div class="card shadow-sm border-0 mb-4">
                            <div class="card-header bg-primary text-white py-3">
                                <h5 class="card-title mb-0"><i class="fas fa-dolly-flatbed me-2"></i> Confirm Putaway -
                                    ${grn.grnNumber}</h5>
                            </div>
                            <div class="card-body bg-light-subtle">
                                <div class="row text-center mb-0">
                                    <div class="col">
                                        <p class="text-muted small mb-1 text-uppercase fw-bold">Purchase Order</p>
                                        <p class="mb-0 fw-semibold">${grn.poNumber}</p>
                                    </div>
                                    <div class="col border-start">
                                        <p class="text-muted small mb-1 text-uppercase fw-bold">Warehouse</p>
                                        <p class="mb-0 fw-semibold">${warehouseName}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/goods-receipt" method="post">
                            <input type="hidden" name="action" value="confirmputaway" />
                            <input type="hidden" name="grnId" value="${grn.grnId}" />
                            <input type="hidden" name="warehouseId" value="${grn.warehouseId}" />

                            <div class="card shadow-sm border-0 mb-4">
                                <div class="card-header bg-dark text-white py-3">
                                    <h5 class="card-title mb-0"><i class="fas fa-boxes me-2"></i> Item Assignment</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="ps-4">Product</th>
                                                    <th class="text-center">Good Qty</th>
                                                    <th>Assign to Storage (Z-STO)</th>
                                                    <th class="text-center">Damaged Qty</th>
                                                    <th>Assign to Damage (Z-DAM)</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="l" items="${lines}" varStatus="status">
                                                    <input type="hidden" name="lineIndices" value="${status.index}" />
                                                    <input type="hidden" name="grnLineId_${status.index}"
                                                        value="${l.grnLineId}" />
                                                    <input type="hidden" name="variantId_${status.index}"
                                                        value="${l.variantId}" />
                                                    <tr>
                                                        <td class="ps-4">
                                                            <div class="fw-bold text-primary">${l.sku}</div>
                                                            <div class="small text-muted">${l.productName}</div>
                                                        </td>

                                                        <!-- Good Items -->
                                                        <td class="text-center">
                                                            <span
                                                                class="badge bg-success-subtle text-success fs-6 px-3">
                                                                <fmt:formatNumber value="${l.qtyGood}"
                                                                    pattern="#,##0" />
                                                            </span>
                                                            <input type="hidden" name="goodQty_${status.index}"
                                                                value="${l.qtyGood}" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${l.qtyGood > 0}">
                                                                    <select name="goodSlotId_${status.index}"
                                                                        class="form-select shadow-sm" required>
                                                                        <option value="">-- Select Slot --</option>
                                                                        <c:forEach var="slot" items="${storageSlots}">
                                                                            <option value="${slot.slotId}">${slot.code}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted small">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <!-- Damaged Items -->
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${l.qtyDamaged > 0}">
                                                                    <span
                                                                        class="badge bg-danger-subtle text-danger fs-6 px-3">
                                                                        <fmt:formatNumber value="${l.qtyDamaged}"
                                                                            pattern="#,##0" />
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <input type="hidden" name="damagedQty_${status.index}"
                                                                value="${l.qtyDamaged}" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${l.qtyDamaged > 0}">
                                                                    <select name="damagedSlotId_${status.index}"
                                                                        class="form-select shadow-sm" required>
                                                                        <option value="">-- Select Slot --</option>
                                                                        <c:forEach var="slot" items="${damageSlots}">
                                                                            <option value="${slot.slotId}">${slot.code}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted small">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="card-footer bg-white py-3">
                                    <div class="d-flex justify-content-end gap-2">
                                        <button type="submit" class="btn btn-primary px-4 shadow-sm">
                                            <i class="fas fa-check-circle me-2"></i> Confirm Putaway
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <style>
                        .form-select {
                            border-radius: 8px;
                            border-color: #e0e0e0;
                        }

                        .form-select:focus {
                            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
                        }

                        .badge {
                            font-weight: 600;
                        }

                        .bg-light-subtle {
                            background-color: #f8f9fa;
                        }
                    </style>
                </t:layout>