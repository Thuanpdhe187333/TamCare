<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.ProductListDTO"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>

<%
    List<ProductListDTO> products = (List<ProductListDTO>) request.getAttribute("products");
    Integer pageNum = (Integer) request.getAttribute("page");
    if (pageNum == null) pageNum = 1;
%>

<jsp:include page="../layout/head.jspf" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    .product-table {
        cursor: pointer;
    }
    .product-table tbody tr:hover {
        background-color: #f8f9fa;
    }
</style>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">Danh sách sản phẩm</h4>
    </div>

    <div class="table-responsive">
        <table class="table table-bordered table-hover table-striped align-middle product-table">
            <thead class="table-dark text-center">
                <tr>
                    <th>ID</th>
                    <th>SKU</th>
                    <th>Tên sản phẩm</th>
                    <th>Barcode</th>
                    <th>Ngày tạo</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <% if (products != null && !products.isEmpty()) {
                    for (ProductListDTO product : products) { %>
                <tr>
                    <td class="text-center"><%= product.getProductId() %></td>
                    <td><%= product.getSku() != null ? product.getSku() : "" %></td>
                    <td><%= product.getName() != null ? product.getName() : "" %></td>
                    <td><%= product.getBarcode() != null ? product.getBarcode() : "" %></td>
                    <td class="text-center">
                        <%= product.getCreatedAt() != null ? product.getCreatedAt().toString() : "" %>
                    </td>
                    <td class="text-center">
                        <button type="button" 
                                class="btn btn-sm btn-outline-primary btn-view-detail"
                                data-product-id="<%= product.getProductId() %>">
                            Xem chi tiết
                        </button>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" class="text-center text-muted">
                        Không có sản phẩm nào
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Popup cho chi tiết sản phẩm -->
<div class="modal fade" id="productDetailModal" tabindex="-1" aria-labelledby="productDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productDetailModalLabel">Chi tiết sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="productDetailContent">
                <div class="text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const modal = new bootstrap.Modal(document.getElementById('productDetailModal'));
    const modalContent = document.getElementById('productDetailContent');
    
    document.querySelectorAll('.btn-view-detail').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.getAttribute('data-product-id');
            loadProductDetail(productId);
            modal.show();
        });
    });
    
    function loadProductDetail(productId) {
        modalContent.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        
        fetch('<%= request.getContextPath() %>/products?action=detail&id=' + productId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Không tìm thấy sản phẩm');
                }
                return response.json();
            })
            .then(data => {
                displayProductDetail(data);
            })
            .catch(error => {
                modalContent.innerHTML = '<div class="alert alert-danger">' + error.message + '</div>';
            });
    }
    
    function displayProductDetail(product) {
        let html = '<div class="row">';
        html += '<div class="col-md-6"><h6>Thông tin sản phẩm</h6>';
        html += '<table class="table table-sm">';
        html += '<tr><td><strong>ID:</strong></td><td>' + (product.productId || '') + '</td></tr>';
        html += '<tr><td><strong>SKU:</strong></td><td>' + (product.sku || '') + '</td></tr>';
        html += '<tr><td><strong>Tên:</strong></td><td>' + (product.name || '') + '</td></tr>';
        html += '<tr><td><strong>Danh mục:</strong></td><td>' + (product.categoryName || 'N/A') + '</td></tr>';
        html += '<tr><td><strong>Đơn vị:</strong></td><td>' + (product.uomName || 'N/A') + '</td></tr>';
        html += '<tr><td><strong>Barcode:</strong></td><td>' + (product.barcode || '') + '</td></tr>';
        html += '<tr><td><strong>Trọng lượng:</strong></td><td>' + (product.weight || 'N/A') + '</td></tr>';
        html += '<tr><td><strong>Kích thước:</strong></td><td>';
        html += (product.length && product.width && product.height) 
            ? product.length + ' x ' + product.width + ' x ' + product.height 
            : 'N/A';
        html += '</td></tr>';
        html += '<tr><td><strong>Ngày tạo:</strong></td><td>' + (product.createdAt || '') + '</td></tr>';
        html += '</table></div>';
        
        html += '<div class="col-md-6"><h6>Các biến thể (Variants)</h6>';
        if (product.variants && product.variants.length > 0) {
            html += '<div class="table-responsive"><table class="table table-sm table-bordered">';
            html += '<thead class="table-light"><tr>';
            html += '<th>Variant SKU</th><th>Màu</th><th>Kích cỡ</th><th>Barcode</th><th>Trạng thái</th>';
            html += '</tr></thead><tbody>';
            product.variants.forEach(variant => {
                html += '<tr>';
                html += '<td>' + (variant.variantSku || '') + '</td>';
                html += '<td>' + (variant.color || 'N/A') + '</td>';
                html += '<td>' + (variant.size || 'N/A') + '</td>';
                html += '<td>' + (variant.barcode || '') + '</td>';
                html += '<td><span class="badge bg-' + (variant.status === 'ACTIVE' ? 'success' : 'secondary') + '">' + (variant.status || '') + '</span></td>';
                html += '</tr>';
            });
            html += '</tbody></table></div>';
        } else {
            html += '<p class="text-muted">Không có biến thể nào</p>';
        }
        html += '</div></div>';
        
        modalContent.innerHTML = html;
    }
});
</script>

<jsp:include page="../layout/footer.jspf" />
