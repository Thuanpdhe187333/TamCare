<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>
<%@taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t" %>
<t:layout title="Purchase Order Detail">
    <div class=" mt-4">
        <div class="card shadow-sm">
            <div class="card-body">
                <p><b>PO ID:</b> ${poId}</p>
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Product</th>
                                <th>Variant SKU</th>
                                <th>Color</th>
                                <th>Size</th>
                                <th>Barcode</th>
                                <th class="text-end">Qty</th>
                                <th class="text-end">Unit Price</th>
                                <th class="text-end">Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${lines}" var="l" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>${l.productName}</td>
                                    <td>${l.variantSku}</td>
                                    <td>${l.color}</td>
                                    <td>${l.size}</td>
                                    <td>${l.barcode}</td>
                                    <td class="text-end">${l.orderedQty}</td>
                                    <td class="text-end">${l.unitPrice}</td>
                                    <td class="text-end fw-bold">${l.lineAmount}</td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty lines}">
                                <tr>
                                    <td colspan="9" class="text-center text-muted">No data</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="d-flex justify-content-between mt-3">
                    <form action="purchase-orders" method="post">
                        <input type="hidden" name="action" value="list"/>
                        <button class="btn btn-secondary">Back</button>
                    </form>
                    <div>
                        <span class="fw-bold">Total Rows:</span> ${fn:length(lines)}
                    </div>
                </div>

            </div>
        </div>
    </div>
</t:layout>
</body>
</html>
