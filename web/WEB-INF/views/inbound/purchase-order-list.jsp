<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PurchaseOrderListDTO"%>

<%
    List<PurchaseOrderListDTO> pos =
        (List<PurchaseOrderListDTO>) request.getAttribute("pos");
%>

 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<div class="container mt-4">
    <h4 class="mb-3">Purchase Order List</h4>
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
                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                View
                            </button>
                        </form>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="8" class="text-center text-muted">
                        No purchase orders found
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
