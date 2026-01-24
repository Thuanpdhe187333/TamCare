<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PurchaseOrderListDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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
    String keyword = request.getParameter("keyword");
    String status  = request.getParameter("status");

    String qs = "";
    if (keyword != null && !keyword.isBlank()) qs += "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
    if (status != null && !status.isBlank()) qs += "&status=" + java.net.URLEncoder.encode(status, "UTF-8");
%>
<t:layout title="Purchase Order List">
    <div class="d-flex justify-content-end align-items-center mb-3">
        <form action="${pageContext.request.contextPath}/purchase-orders"
              method="post"
              class="m-0 mr-2">
            <input type="hidden" name="action" value="new">
            <button class="btn btn-success">
                Add Purchase Order
            </button>
        </form>
        <form action="${pageContext.request.contextPath}/purchase-orders"
              method="post"
              class="m-0">
            <input type="hidden" name="action" value="import">
            <button class="btn btn-success">
                Import Purchase Order
            </button>
        </form>
    </div>
    <form action="${pageContext.request.contextPath}/purchase-orders"
          method="get"
          class="mb-3 p-3 border rounded bg-light">

        <!-- ROW 1: keyword + status -->
        <div class="form-row mb-2">
            <div class="col-md-6">
                <label class="mb-1 font-weight-bold">Search</label>
                <input type="text"
                       name="keyword"
                       class="form-control"
                       placeholder="PO number, supplier..."
                       value="${param.keyword}">
            </div>
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Status</label>
                <select name="status" class="form-control">
                    <option value="">-- All --</option>
                    <option value="CREATED"   ${param.status == 'CREATED' ? 'selected' : ''}>CREATED</option>
                    <option value="IMPORTED"  ${param.status == 'IMPORTED' ? 'selected' : ''}>IMPORTED</option>
                    <option value="CANCELLED" ${param.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                    <option value="CLOSED"    ${param.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                </select>
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary mr-2">
                    Search
                </button>
                <a href="${pageContext.request.contextPath}/purchase-orders"
                   class="btn btn-outline-secondary">
                    Reset
                </a>
            </div>
        </div>
        <!-- ROW 2: Date filters -->
        <div class="form-row">
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Expected from</label>
                <input type="date" name="expectedFrom" class="form-control"
                       value="${param.expectedFrom}">
            </div>
            <div class="col-md-3 font-weight-bold">
                <label class="mb-1">Expected to</label>
                <input type="date" name="expectedTo" class="form-control"
                       value="${param.expectedTo}">
            </div>
        </div>
    </form>
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
    <c:set var="keyword" value="${param.keyword}" />
    <c:set var="status" value="${param.status}" />

    <nav aria-label="Purchase Order pagination" class="mt-3">
        <ul class="pagination justify-content-center">

            <!-- Previous URL -->
            <c:url var="prevUrl" value="/purchase-orders">
                <c:param name="page" value="${page - 1}" />
                <c:if test="${not empty keyword}">
                    <c:param name="keyword" value="${keyword}" />
                </c:if>
                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}" />
                </c:if>
            </c:url>

            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                <a class="page-link" href="${page <= 1 ? '#' : prevUrl}">Previous</a>
            </li>

            <!-- First + ... -->
            <c:if test="${page > 3}">
                <c:url var="firstUrl" value="/purchase-orders">
                    <c:param name="page" value="1" />
                    <c:if test="${not empty keyword}">
                        <c:param name="keyword" value="${keyword}" />
                    </c:if>
                    <c:if test="${not empty status}">
                        <c:param name="status" value="${status}" />
                    </c:if>
                </c:url>

                <li class="page-item">
                    <a class="page-link" href="${firstUrl}">1</a>
                </li>
                <li class="page-item disabled">
                    <span class="page-link">...</span>
                </li>
            </c:if>

            <!-- window pages -->
            <c:set var="start" value="${page - 2}" />
            <c:set var="end" value="${page + 2}" />
            <c:if test="${start < 1}"><c:set var="start" value="1"/></c:if>
            <c:if test="${end > totalPages}"><c:set var="end" value="${totalPages}"/></c:if>

            <c:forEach var="i" begin="${start}" end="${end}">
                <c:url var="pageUrl" value="/purchase-orders">
                    <c:param name="page" value="${i}" />
                    <c:if test="${not empty keyword}">
                        <c:param name="keyword" value="${keyword}" />
                    </c:if>
                    <c:if test="${not empty status}">
                        <c:param name="status" value="${status}" />
                    </c:if>
                </c:url>

                <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="${pageUrl}">${i}</a>
                </li>
            </c:forEach>

            <!-- ... + Last -->
            <c:if test="${page < totalPages - 2}">
                <c:url var="lastUrl" value="/purchase-orders">
                    <c:param name="page" value="${totalPages}" />
                    <c:if test="${not empty keyword}">
                        <c:param name="keyword" value="${keyword}" />
                    </c:if>
                    <c:if test="${not empty status}">
                        <c:param name="status" value="${status}" />
                    </c:if>
                </c:url>

                <li class="page-item disabled">
                    <span class="page-link">...</span>
                </li>
                <li class="page-item">
                    <a class="page-link" href="${lastUrl}">${totalPages}</a>
                </li>
            </c:if>

            <!-- Next URL -->
            <c:url var="nextUrl" value="/purchase-orders">
                <c:param name="page" value="${page + 1}" />
                <c:if test="${not empty keyword}">
                    <c:param name="keyword" value="${keyword}" />
                </c:if>
                <c:if test="${not empty status}">
                    <c:param name="status" value="${status}" />
                </c:if>
            </c:url>

            <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${page >= totalPages ? '#' : nextUrl}">Next</a>
            </li>

        </ul>
    </nav>

</t:layout>






