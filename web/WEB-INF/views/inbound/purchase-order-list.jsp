<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PurchaseOrderListDTO"%>

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

    int window = 2; // hiển thị 5 trang: 2 trước + hiện tại + 2 sau
    int startPage = Math.max(1, currentPage - window);
    int endPage   = Math.min(totalPages, currentPage + window);

    if (endPage - startPage < window * 2) {
        if (startPage == 1) endPage = Math.min(totalPages, startPage + window * 2);
        if (endPage == totalPages) startPage = Math.max(1, endPage - window * 2);
    }

    String baseUrl = request.getContextPath() + "/purchase-orders";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Purchase Order List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body class="bg-light">
        <div class="container mt-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0">Purchase Order List</h4>

                <form action="<%= request.getContextPath() %>/purchase-orders" method="post" class="m-0">
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
                        <% if (pos != null && !pos.isEmpty()) {
                for (PurchaseOrderListDTO po : pos) { %>
                        <tr>
                            <td class="text-center"><%= po.getPoId() %></td>
                            <td><%= po.getPoNumber() %></td>
                            <td><%= po.getSupplierName() %></td>
                            <td><%= po.getExpectedDeliveryDate() %></td>
                            <td><%= po.getStatus() %></td>
                            <td><%= po.getImportedByUsername() %></td>
                            <td><%= po.getImportedAt() %></td>
                            <td class="text-center">
                                <form action="<%= request.getContextPath() %>/purchase-orders"
                                      method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="detail">
                                    <input type="hidden" name="id" value="<%= po.getPoId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-primary">View</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/purchase-orders"
                                      method="post" style="display:inline;"
                                      onsubmit="return confirm('Delete PO <%= po.getPoNumber() %>?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= po.getPoId() %>">
                                    <input type="hidden" name="page" value="<%= request.getAttribute("page") %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                </form>
                            </td>

                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="8" class="text-center text-muted">No purchase orders found</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav aria-label="Purchase Order pagination" class="mt-3">
                <ul class="pagination justify-content-center">

                    <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                        <a class="page-link" href="<%= baseUrl %>?page=<%= currentPage - 1 %>">Previous</a>
                    </li>

                    <% if (startPage > 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="<%= baseUrl %>?page=1">1</a>
                    </li>
                    <% if (startPage > 2) { %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                        <% } %>

                    <% for (int i = startPage; i <= endPage; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="<%= baseUrl %>?page=<%= i %>"><%= i %></a>
                    </li>
                    <% } %>

                    <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>
                    <li class="page-item">
                        <a class="page-link" href="<%= baseUrl %>?page=<%= totalPages %>"><%= totalPages %></a>
                    </li>
                    <% } %>

                    <li class="page-item <%= (currentPage >= totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="<%= baseUrl %>?page=<%= currentPage + 1 %>">Next</a>
                    </li>

                </ul>
            </nav>

        </div>
    </body>
</html>
