<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.ProductListDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
    List<ProductListDTO> products = (List<ProductListDTO>) request.getAttribute("products");
    Integer pageNum = (Integer) request.getAttribute("page");
    if (pageNum == null) pageNum = 1;
%>

<t:layout title="Product List">
    <style>
        .product-table {
            cursor: pointer;
        }
        .product-table tbody tr:hover {
            background-color: #f8f9fa;
        }
        .sortable-header {
            cursor: pointer;
            user-select: none;
            position: relative;
        }
        .sortable-header:hover {
            background-color: #495057 !important;
        }
        .sortable-header::after {
            content: ' ↕';
            opacity: 0.5;
            font-size: 0.8em;
        }
        .sortable-header.sort-asc::after {
            content: ' ↑';
            opacity: 1;
        }
        .sortable-header.sort-desc::after {
            content: ' ↓';
            opacity: 1;
        }
    </style>

    <!-- Filter Section -->
    <div class="card mb-4 shadow-sm">
        <div class="card-header">
            <h6 class="mb-0">Filter</h6>
        </div>
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/products" id="filterForm">
                <input type="hidden" name="page" value="1">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="filterSku" class="form-label">SKU</label>
                        <input type="text" class="form-control" id="filterSku" name="filterSku" 
                               value="${param.filterSku}" placeholder="Enter SKU...">
                    </div>
                    <div class="col-md-3">
                        <label for="filterName" class="form-label">Product Name</label>
                        <input type="text" class="form-control" id="filterName" name="filterName" 
                               value="${param.filterName}" placeholder="Enter product name...">
                    </div>
                    <div class="col-md-3">
                        <label for="filterBarcode" class="form-label">Barcode</label>
                        <input type="text" class="form-control" id="filterBarcode" name="filterBarcode" 
                               value="${param.filterBarcode}" placeholder="Enter barcode...">
                    </div>
                    <div class="col-md-3 d-flex align-items-end justify-content-end">
                        <button type="submit" class="btn btn-primary" style="margin-right: 12px !important;">Search</button>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">Clear Filter</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="table-responsive shadow-sm rounded">
        <table class="table table-bordered table-hover table-striped align-middle mb-0 product-table">
            <thead class="thead-dark">
                <tr class="text-center">
                    <th class="sortable-header" data-sort="product_id" data-current-sort="${param.sortBy == 'product_id' ? param.sortOrder : ''}">ID</th>
                    <th class="sortable-header" data-sort="sku" data-current-sort="${param.sortBy == 'sku' ? param.sortOrder : ''}">SKU</th>
                    <th class="sortable-header" data-sort="name" data-current-sort="${param.sortBy == 'name' ? param.sortOrder : ''}">Product Name</th>
                    <th class="sortable-header" data-sort="barcode" data-current-sort="${param.sortBy == 'barcode' ? param.sortOrder : ''}">Barcode</th>
                    <th class="sortable-header" data-sort="created_at" data-current-sort="${param.sortBy == 'created_at' ? param.sortOrder : ''}">Created Date</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${products}">
                    <tr>
                        <td class="text-center">${product.productId}</td>
                        <td class="font-weight-bold text-primary">${product.sku}</td>
                        <td>${product.name}</td>
                        <td>${product.barcode}</td>
                        <td class="text-center">${product.createdAt}</td>
                        <td class="text-center">
                            <button type="button" 
                                    class="btn btn-sm btn-info shadow-sm btn-view-detail"
                                    data-product-id="${product.productId}">
                                View Details
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr>
                        <td colspan="6" class="text-center py-4 text-muted">
                            No products found
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

<!-- Modal Popup cho chi tiết sản phẩm -->
<div class="modal fade" id="productDetailModal" tabindex="-1" aria-labelledby="productDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="productDetailModalLabel">Product Details</h5>
                <button type="button" class="btn-close-modal" onclick="closeProductModal()" aria-label="Close" style="background: none; border: none; font-size: 28px; color: #dc3545; cursor: pointer; padding: 0; width: 35px; height: 35px; line-height: 30px; text-align: center; font-weight: bold;">×</button>
            </div>
            <div class="modal-body" id="productDetailContent">
                <div class="text-center">
                    <div class="spinner-border" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <script>
    let productModal = null;
    
    document.addEventListener('DOMContentLoaded', function() {
        const modalElement = document.getElementById('productDetailModal');
        if (modalElement) {
            productModal = new bootstrap.Modal(modalElement, {
                backdrop: true,
                keyboard: true
            });
        }
        const modalContent = document.getElementById('productDetailContent');
        
        // Sort functionality
        document.querySelectorAll('.sortable-header').forEach(header => {
            header.addEventListener('click', function() {
                const sortBy = this.getAttribute('data-sort');
                const currentSort = this.getAttribute('data-current-sort');
                let sortOrder = 'ASC';
                
                if (currentSort === 'ASC') {
                    sortOrder = 'DESC';
                } else if (currentSort === 'DESC') {
                    sortOrder = 'ASC';
                }
                
                // Update URL with sort parameters
                const url = new URL(window.location.href);
                url.searchParams.set('sortBy', sortBy);
                url.searchParams.set('sortOrder', sortOrder);
                url.searchParams.set('page', '1');
                window.location.href = url.toString();
            });
            
            // Update sort indicator
            const currentSort = header.getAttribute('data-current-sort');
            if (currentSort === 'ASC') {
                header.classList.add('sort-asc');
            } else if (currentSort === 'DESC') {
                header.classList.add('sort-desc');
            }
        });
        
        document.querySelectorAll('.btn-view-detail').forEach(button => {
            button.addEventListener('click', function() {
                const productId = this.getAttribute('data-product-id');
                loadProductDetail(productId);
                if (productModal) {
                    productModal.show();
                }
            });
        });
        
        function loadProductDetail(productId) {
            if (!modalContent) return;
            modalContent.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
            
            fetch('${pageContext.request.contextPath}/products?action=detail&id=' + productId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Product not found');
                    }
                    return response.json();
                })
                .then(data => {
                    displayProductDetail(data);
                })
                .catch(error => {
                    if (modalContent) {
                        modalContent.innerHTML = '<div class="alert alert-danger">' + error.message + '</div>';
                    }
                });
        }
        
        function displayProductDetail(product) {
            if (!modalContent) return;
            let html = '<div class="row">';
            html += '<div class="col-md-6"><h6>Product Information</h6>';
            html += '<table class="table table-sm">';
            html += '<tr><td><strong>ID:</strong></td><td>' + (product.productId || '') + '</td></tr>';
            html += '<tr><td><strong>SKU:</strong></td><td>' + (product.sku || '') + '</td></tr>';
            html += '<tr><td><strong>Name:</strong></td><td>' + (product.name || '') + '</td></tr>';
            html += '<tr><td><strong>Category:</strong></td><td>' + (product.categoryName || 'N/A') + '</td></tr>';
            html += '<tr><td><strong>Unit:</strong></td><td>' + (product.uomName || 'N/A') + '</td></tr>';
            html += '<tr><td><strong>Barcode:</strong></td><td>' + (product.barcode || '') + '</td></tr>';
            html += '<tr><td><strong>Weight:</strong></td><td>' + (product.weight || 'N/A') + '</td></tr>';
            html += '<tr><td><strong>Dimensions:</strong></td><td>';
            html += (product.length && product.width && product.height) 
                ? product.length + ' x ' + product.width + ' x ' + product.height 
                : 'N/A';
            html += '</td></tr>';
            html += '<tr><td><strong>Created Date:</strong></td><td>' + (product.createdAt || '') + '</td></tr>';
            html += '</table></div>';
            
            html += '<div class="col-md-6"><h6>Variants</h6>';
            if (product.variants && product.variants.length > 0) {
                html += '<div class="table-responsive"><table class="table table-sm table-bordered">';
                html += '<thead class="table-light"><tr>';
                html += '<th>Variant SKU</th><th>Color</th><th>Size</th><th>Barcode</th><th>Status</th>';
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
                html += '<p class="text-muted">No variants</p>';
            }
            html += '</div></div>';
            
            modalContent.innerHTML = html;
        }
    });
    
    function closeProductModal() {
        if (productModal) {
            productModal.hide();
        } else {
            const modalElement = document.getElementById('productDetailModal');
            if (modalElement) {
                const modal = bootstrap.Modal.getInstance(modalElement);
                if (modal) {
                    modal.hide();
                } else {
                    const newModal = new bootstrap.Modal(modalElement);
                    newModal.hide();
                }
            }
        }
    }
    </script>
</t:layout>
