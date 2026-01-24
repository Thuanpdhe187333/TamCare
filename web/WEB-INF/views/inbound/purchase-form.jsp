<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.SupplierDTO"%>
<%@page import="dto.ProductVariantDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    List<SupplierDTO> suppliers = (List<SupplierDTO>) request.getAttribute("suppliers");
    List<ProductVariantDTO> variants = (List<ProductVariantDTO>) request.getAttribute("variants");
%>
<t:layout title="Create Purchase Order">
    <div class="py-4">
        <form action="${pageContext.request.getContextPath()}/purchase-orders" method="post" id="poForm">
            <input type="hidden" name="action" value="create"/>
            <!-- Header -->
            <div class="card shadow-sm mb-3">
                <div class="card-header fw-semibold">Header</div>
                <div class="card-body row g-3">
                    <div class="col-md-4">
                        <label class="form-label">PO Number</label>
                        <input class="form-control" name="poNumber" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Supplier</label>
                        <select class="form-select" name="supplierId" required>
                            <option value="">-- Select supplier --</option>
                            <c:if test="${not empty suppliers}">
                                <c:forEach var="s" items="${suppliers}">
                                    <option value="${s.supplierId}">
                                        ${s.code} - ${s.name}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Expected Delivery Date</label>
                        <input type="date" class="form-control" name="expectedDeliveryDate">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Note</label>
                        <textarea class="form-control" name="note" rows="2"></textarea>
                    </div>
                </div>
            </div
            <!-- Lines -->
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="fw-semibold">Lines</span>
                    <button type="button" class="btn btn-sm btn-primary" onclick="addLine()">+ Add line</button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered mb-0" id="linesTable">
                            <thead class="table-dark text-center">
                                <tr>
                                    <th style="min-width:220px;">Variant SKU</th>
                                    <th style="width:140px;">Quantity</th>
                                    <th style="width:160px;">Unit Price</th>
                                    <th style="width:140px;">Currency</th>
                                    <th style="width:80px;">#</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer d-flex justify-content-end gap-2">
                    <button class="btn btn-success" type="submit">Save</button>
                </div>
            </div>
        </form>
    </div>
</t:layout>
<script>
    let idx = 0;

    function addLine() {
        const tbody = document.querySelector("#linesTable tbody");
        const tr = document.createElement("tr");

        tr.innerHTML =
                '<td>' +
                '  <select class="form-select" name="lines[' + idx + '].variantId" required>' +
                '    <option value="">-- Select variant --</option>' +
                '    <% if (variants != null) for (ProductVariantDTO v : variants) { %>' +
                '      <option value="<%=v.getVariantId()%>">' +
                '        <%=v.getVariantSku()%> | <%=v.getProductSku()%> - <%=v.getProductName()%>' +
                '      </option>' +
                '    <% } %>' +
                '  </select>' +
                '</td>' +
                '<td><input class="form-control" type="number" step="0.0001" min="0.0001" name="lines[' + idx + '].qty" required></td>' +
                '<td><input class="form-control" type="number" step="0.0001" min="0" name="lines[' + idx + '].unitPrice"></td>' +
                '<td><input class="form-control" name="lines[' + idx + '].currency" value="VND"></td>' +
                '<td class="text-center">' +
                '  <button type="button" class="btn btn-sm btn-danger btn-remove">X</button>' +
                '</td>';

        tbody.appendChild(tr);
        idx++;
    }

    // event delegation: bấm X thì xoá row
    document.addEventListener("click", function (e) {
        if (e.target && e.target.classList.contains("btn-remove")) {
            e.target.closest("tr").remove();
        }
    });

    // add dòng mặc định khi load
    addLine();
</script>

