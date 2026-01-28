<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
        <%@taglib uri="jakarta.tags.core" prefix="c" %>
            <t:layout title="Goods Receipt List">
                <div class="container-fluid">

                    <!-- Filter Form -->
                    <div class="card mb-4 shadow-sm">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/goods-receipt" method="get"
                                class="row g-3">
                                <input type="hidden" name="action" value="list">
                                <div class="col-md-3">
                                    <label class="form-label font-weight-bold">GRN Number</label>
                                    <input type="text" class="form-control" name="grnNumber" value="${param.grnNumber}"
                                        placeholder="Search code...">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label font-weight-bold">Supplier</label>
                                    <select class="form-control" name="supplierId">
                                        <option value="">-- All Suppliers --</option>
                                        <c:forEach var="s" items="${suppliers}">
                                            <option value="${s.supplierId}" ${param.supplierId==s.supplierId
                                                ? 'selected' : '' }>${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label font-weight-bold">Status</label>
                                    <select class="form-control" name="status">
                                        <option value="">-- All --</option>
                                        <option value="PENDING" ${param.status=='PENDING' ? 'selected' : '' }>PENDING
                                        </option>
                                        <option value="APPROVED" ${param.status=='APPROVED' ? 'selected' : '' }>APPROVED
                                        </option>
                                        <option value="REJECTED" ${param.status=='REJECTED' ? 'selected' : '' }>REJECTED
                                        </option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-search"></i> Filter
                                    </button>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <a href="${pageContext.request.contextPath}/goods-receipt?action=list"
                                        class="btn btn-secondary w-100">Reset</a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="mb-3 d-flex justify-content-end">
                        <a href="${pageContext.request.contextPath}/goods-receipt?action=create"
                            class="btn btn-success shadow-sm">
                            <i class="fas fa-plus"></i> Create New GRN
                        </a>
                    </div>

                    <div class="table-responsive shadow-sm rounded">
                        <table class="table table-bordered table-hover table-striped align-middle mb-0">
                            <thead class="thead-dark">
                                <tr class="text-center">
                                    <th style="cursor: pointer;" onclick="toggleSort('grn_id')">ID <i
                                            class="fas fa-sort"></i></th>
                                    <th style="cursor: pointer;" onclick="toggleSort('grn_number')">GRN Number <i
                                            class="fas fa-sort"></i></th>
                                    <th style="cursor: pointer;" onclick="toggleSort('supplier_name')">Supplier <i
                                            class="fas fa-sort"></i></th>
                                    <th style="cursor: pointer;" onclick="toggleSort('status')">Status <i
                                            class="fas fa-sort"></i></th>
                                    <th>Created At</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="gr" items="${grns}">
                                    <tr>
                                        <td class="text-center">${gr.grnId}</td>
                                        <td class="font-weight-bold text-primary">${gr.grnNumber}</td>
                                        <td>${gr.supplierName}</td>
                                        <td class="text-center">
                                            <span
                                                class="badge badge-pill ${gr.status == 'PENDING' ? 'badge-warning' : (gr.status == 'APPROVED' ? 'badge-success' : 'badge-danger')}">
                                                ${gr.status}
                                            </span>
                                        </td>
                                        <td class="text-center">${gr.createdAt}</td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center align-items-center gap-2">
                                                <!-- View 버튼 -->
                                                <a href="${pageContext.request.contextPath}/goods-receipt?action=detail&id=${gr.grnId}"
                                                    class="btn btn-sm btn-info shadow-sm text-white d-flex align-items-center justify-content-center"
                                                    style="width: 85px; height: 32px;" title="View Details">
                                                    <i class="fas fa-eye me-1"></i> View
                                                </a>

                                                <!-- Edit 버튼 -->
                                                <div style="width: 85px; height: 32px;">
                                                    <c:if test="${gr.status == 'PENDING' || gr.status == 'DRAFT'}">
                                                        <a href="${pageContext.request.contextPath}/goods-receipt?action=edit&id=${gr.grnId}"
                                                            class="btn btn-sm btn-warning shadow-sm d-flex align-items-center justify-content-center h-100 w-100"
                                                            title="Edit">
                                                            <i class="fas fa-edit me-1"></i> Edit
                                                        </a>
                                                    </c:if>
                                                </div>

                                                <!-- Delete 버튼 -->
                                                <div style="width: 85px; height: 32px;">
                                                    <c:if test="${gr.status == 'PENDING' || gr.status == 'DRAFT'}">
                                                        <a href="${pageContext.request.contextPath}/goods-receipt?action=delete&id=${gr.grnId}"
                                                            class="btn btn-sm btn-danger shadow-sm d-flex align-items-center justify-content-center h-100 w-100"
                                                            title="Delete"
                                                            onclick="return confirm('Are you sure you want to delete this GRN?')">
                                                            <i class="fas fa-trash me-1"></i> Delete
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty grns}">
                                    <tr>
                                        <td colspan="6" class="text-center py-4 text-muted">No data found in the system.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link shadow-sm"
                                            href="${pageContext.request.contextPath}/goods-receipt?action=list&page=${i}&grnNumber=${param.grnNumber}&supplierId=${param.supplierId}&status=${param.status}&sortBy=${param.sortBy}&order=${param.order}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>
                    </c:if>
                </div>

                <script>
                    function toggleSort(field) {
                        const urlParams = new URLSearchParams(window.location.search);
                        const currentOrder = urlParams.get('order') === 'ASC' ? 'DESC' : 'ASC';
                        urlParams.set('sortBy', field);
                        urlParams.set('order', currentOrder);
                        window.location.href = window.location.pathname + '?' + urlParams.toString();
                    }
                </script>
            </t:layout>