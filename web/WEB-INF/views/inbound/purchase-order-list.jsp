<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.PurchaseOrderListDTO"%>

<%
    List<PurchaseOrderListDTO> pos = (List<PurchaseOrderListDTO>) request.getAttribute("pos");
%>

<table border="1" cellpadding="8">
    <thead>
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
        <% if (pos != null) for (PurchaseOrderListDTO po : pos) { %>
        <tr>
            <td><%= po.getPoId() %></td>
            <td><%= po.getPoNumber() %></td>
            <td><%= po.getSupplierName() %></td>
            <td><%= po.getExpectedDeliveryDate() %></td>
            <td><%= po.getStatus() %></td>
            <td><%= po.getImportedByUsername() %></td>
            <td><%= po.getImportedAt() %></td>
            <td>
                <a href="purchase-order-detail?id=<%= po.getPoId() %>">View</a>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
