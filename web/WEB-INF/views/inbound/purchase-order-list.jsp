<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PurchaseOrderListDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    List<PurchaseOrderListDTO> pos =
        (List<PurchaseOrderListDTO>) request.getAttribute("pos");

    Integer currentPageObj = (Integer) request.getAttribute("page");
    Integer totalPagesObj  = (Integer) request.getAttribute("totalPages");

    int currentPage = (currentPageObj == null) ? 1 : currentPageObj;
    int totalPages  = (totalPagesObj == null) ? 1 : totalPagesObj;

    if (currentPage < 1) currentPage = 1;
    if (totalPages < 1) totalPages = 1;
    if (currentPage > totalPages) currentPage = totalPages;

    int window = 2; 
    int startPage = Math.max(1, currentPage - window);
    int endPage   = Math.min(totalPages, currentPage + window);

    if (endPage - startPage < window * 2) {
        if (startPage == 1) endPage = Math.min(totalPages, startPage + window * 2);
        if (endPage == totalPages) startPage = Math.max(1, endPage - window * 2);
    }

    String baseUrl = request.getContextPath() + "/purchase-orders";
%>
<t:layout title="Purchase Order List">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <form action="${pageContext.request.getContextPath()}/purchase-orders" method="post" class="m-0">
                <input type="hidden" name="action" value="new">
                <button class="btn btn-success">
                    + Add Purchase Order
                </button>
            </form>
        </div>
        <div class="table-responsive">
            <table class="table table-bordered table-hover table-striped align-middle">
                <thead class="table-dark text-center">
                    <tr>
                        <th>ID</th>
                        <th>PO Number</th>
                        <th>Supplier</th>
                        <th>Expected Date</th>
                        <th>Status</th>
                        <th>Imported By</th>
                        <th>Imported At</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty pos}">
                        <c:forEach var="po" items="${pos}">
                            <tr>
                                <td class="text-center">${po.poId}</td>
                                <td>${po.poNumber}</td>
                                <td>${po.supplierName}</td>
                                <td>${po.expectedDeliveryDate}</td>
                                <td>${po.status}</td>
                                <td>${po.importedByUsername}</td>
                                <td>${po.importedAt}</td>
                                <td class="text-center">

                                    <form action="${pageContext.request.contextPath}/purchase-orders"
                                          method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="detail">
                                        <input type="hidden" name="id" value="${po.poId}">
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </form>

                                    <form action="${pageContext.request.contextPath}/purchase-orders"
                                          method="post" style="display:inline;"
                                          onsubmit="return confirm('Delete PO ${po.poNumber}?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="${po.poId}">
                                        <input type="hidden" name="page" value="${page}">
                                        <button class="btn btn-sm btn-outline-danger">Delete</button>
                                    </form>

                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>

                    <c:if test="${empty pos}">
                        <tr>
                            <td colspan="8" class="text-center text-muted">
                                No purchase orders found
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <nav aria-label="Purchase Order pagination" class="mt-3">
            <ul class="pagination justify-content-center">

                <!-- Previous -->
                <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/purchase-orders?page=${page - 1}">
                        Previous
                    </a>
                </li>

                <!-- 1 và ... (khi page > 3) -->
                <c:if test="${page > 3}">
                    <li class="page-item">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/purchase-orders?page=1">1</a>
                    </li>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                    </c:if>

                <!-- 2 trang trước, current, 2 trang sau -->
                <c:set var="start" value="${page - 2}" />
                <c:set var="end" value="${page + 2}" />
                <c:if test="${start < 1}"><c:set var="start" value="1"/></c:if>
                <c:if test="${end > totalPages}"><c:set var="end" value="${totalPages}"/></c:if>

                <c:forEach var="i" begin="${start}" end="${end}">
                    <li class="page-item ${i == page ? 'active' : ''}">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/purchase-orders?page=${i}">
                            ${i}
                        </a>
                    </li>
                </c:forEach>

                <!-- ... và last (khi còn xa last) -->
                <c:if test="${page < totalPages - 2}">
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                    <li class="page-item">
                        <a class="page-link"
                           href="${pageContext.request.contextPath}/purchase-orders?page=${totalPages}">
                            ${totalPages}
                        </a>
                    </li>
                </c:if>

                <!-- Next -->
                <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                    <a class="page-link"
                       href="${pageContext.request.contextPath}/purchase-orders?page=${page + 1}">
                        Next
                    </a>
                </li>
            </ul>
        </nav>
</t:layout>






