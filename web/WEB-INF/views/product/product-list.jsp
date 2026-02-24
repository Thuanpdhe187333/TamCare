<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.ProductInventoryListDTO"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="t"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%
    List<ProductInventoryListDTO> products = (List<ProductInventoryListDTO>) request.getAttribute("products");
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

    <!-- Filter Section - Synced with purchase-order-list.jsp -->
    <form action="${pageContext.request.contextPath}/products"
          method="get"
          class="mb-3 p-3 border rounded bg-light">
        <!-- ROW 1: Text filters -->
        <div class="form-row mb-2">
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">SKU</label>
                <input type="text"
                       name="filterSku"
                       class="form-control"
                       placeholder="Enter SKU..."
                       value="${param.filterSku}">
            </div>
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Product Name</label>
                <input type="text"
                       name="filterName"
                       class="form-control"
                       placeholder="Enter product name..."
                       value="${param.filterName}">
            </div>
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Barcode</label>
                <input type="text"
                       name="filterBarcode"
                       class="form-control"
                       placeholder="Enter barcode..."
                       value="${param.filterBarcode}">
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary mr-2">
                    Search
                </button>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-outline-secondary">
                    Reset
                </a>
            </div>
        </div>
        <!-- ROW 2: Dropdown filters -->
        <div class="form-row">
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Zone</label>
                <select name="filterZoneCode" class="form-control">
                    <option value="">-- All Zones --</option>
                    <c:forEach items="${zones}" var="zone">
                        <option value="${zone.code}" ${param.filterZoneCode == zone.code ? 'selected' : ''}>
                            ${zone.code} - ${zone.name}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <label class="mb-1 font-weight-bold">Condition</label>
                <select name="filterCondition" class="form-control">
                    <option value="">-- All Conditions --</option>
                    <option value="GOOD" ${param.filterCondition == 'GOOD' ? 'selected' : ''}>GOOD</option>
                    <option value="DAMAGED" ${param.filterCondition == 'DAMAGED' ? 'selected' : ''}>DAMAGED</option>
                    <option value="EXPIRED" ${param.filterCondition == 'EXPIRED' ? 'selected' : ''}>EXPIRED</option>
                </select>
            </div>
        </div>
    </form>

    <style>
        .resizable-table {
            table-layout: fixed;
            width: 100%;
        }
        .product-detail-container {
            padding: 10px;
        }
        .product-header h4 {
            font-weight: 600;
            color: #2c3e50;
        }
        .card-header {
            font-weight: 600;
        }
        .table-borderless td {
            padding: 0.5rem 0;
        }
        .resizable-table th,
        .resizable-table td {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            position: relative;
        }
        .resizable-table th {
            text-align: center;
            user-select: none;
            cursor: default;
        }
        .resizable-table th.resizable {
            cursor: col-resize;
        }
        .resizable-table th .resizer {
            position: absolute;
            top: 0;
            right: 0;
            width: 5px;
            height: 100%;
            cursor: col-resize;
            user-select: none;
            background: transparent;
        }
        .resizable-table th .resizer:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .resizable-table th .resizer.active {
            background: rgba(255, 255, 255, 0.5);
        }
    </style>
    
    <div class="table-responsive">
        <table class="table table-bordered table-striped align-middle resizable-table">
            <thead class="table-dark">
                <tr>
                    <th class="sortable-header resizable" data-sort="sku" data-current-sort="${param.sortBy == 'sku' ? param.sortOrder : ''}" style="text-align: center;">
                        SKU
                        <div class="resizer"></div>
                    </th>
                    <th class="sortable-header resizable" data-sort="name" data-current-sort="${param.sortBy == 'name' ? param.sortOrder : ''}" style="text-align: center;">
                        Product Name
                        <div class="resizer"></div>
                    </th>
                    <th class="sortable-header resizable" data-sort="barcode" data-current-sort="${param.sortBy == 'barcode' ? param.sortOrder : ''}" style="text-align: center;">
                        Barcode
                        <div class="resizer"></div>
                    </th>
                    <th class="resizable" style="text-align: center;">
                        Variant SKU
                        <div class="resizer"></div>
                    </th>
                    <th class="resizable" style="text-align: center;">
                        Quantity (On Hand)
                        <div class="resizer"></div>
                    </th>
                    <th class="resizable" style="text-align: center;">
                        Quantity (Available)
                        <div class="resizer"></div>
                    </th>
                    <th class="sortable-header resizable" data-sort="slot_code" data-current-sort="${param.sortBy == 'slot_code' ? param.sortOrder : ''}" style="text-align: center;">
                        Slot
                        <div class="resizer"></div>
                    </th>
                    <th class="sortable-header resizable" data-sort="zone_code" data-current-sort="${param.sortBy == 'zone_code' ? param.sortOrder : ''}" style="text-align: center;">
                        Zone
                        <div class="resizer"></div>
                    </th>
                    <th class="sortable-header resizable" data-sort="condition" data-current-sort="${param.sortBy == 'condition' ? param.sortOrder : ''}" style="text-align: center;">
                        Condition
                        <div class="resizer"></div>
                    </th>
                    <th class="resizable" style="text-align: center;">
                        Warehouse
                        <div class="resizer"></div>
                    </th>
                    <th class="resizable" style="text-align: center;">
                        Action
                        <div class="resizer"></div>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${not empty products}">
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td class="font-weight-bold text-primary">${product.sku}</td>
                            <td>${product.name}</td>
                            <td>${product.barcode}</td>
                            <td>${product.variantSku}</td>
                            <td class="text-center"><fmt:formatNumber value="${product.totalQtyOnHand}" maxFractionDigits="0" /></td>
                            <td class="text-center"><fmt:formatNumber value="${product.totalQtyAvailable}" maxFractionDigits="0" /></td>
                            <td class="text-center">
                                <span class="badge bg-info">${product.slotCode}</span>
                            </td>
                            <td>
                                <span class="badge bg-secondary">${product.zoneCode}</span>
                                <small class="text-muted d-block">${product.zoneName}</small>
                            </td>
                            <td class="text-center">
                                <span class="badge bg-${product.condition == 'GOOD' ? 'success' : product.condition == 'DAMAGED' ? 'danger' : 'warning'}">
                                    ${product.condition}
                                </span>
                            </td>
                            <td>
                                <small>${product.warehouseCode}</small>
                                <small class="text-muted d-block">${product.warehouseName}</small>
                            </td>
                            <td class="text-center">
                                <button type="button" 
                                        class="btn btn-sm btn-outline-primary btn-view-detail"
                                        data-product-id="${product.productId}">
                                    View Details
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty products}">
                    <tr>
                        <td colspan="11" class="text-center text-muted">
                            No products found in inventory
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Pagination - Synced with purchase-order-list.jsp -->
    <nav aria-label="Product pagination" class="mt-3">
        <ul class="pagination justify-content-center">
            <c:set var="baseUrl" value="${baseUrl}" />
            <c:set var="qs" value="${qs}" />

            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                <a class="page-link" href="${page <= 1 ? '#' : baseUrl.concat('?page=').concat(page-1).concat(qs)}">Previous</a>
            </li>

            <c:if test="${startPage > 1}">
                <li class="page-item">
                    <a class="page-link" href="${baseUrl}?page=1${qs}">1</a>
                </li>
                <c:if test="${startPage > 2}">
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
            </c:if>

            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <li class="page-item ${i == page ? 'active' : ''}">
                    <a class="page-link" href="${baseUrl}?page=${i}${qs}">${i}</a>
                </li>
            </c:forEach>

            <c:if test="${endPage < totalPages}">
                <c:if test="${endPage < totalPages - 1}">
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                </c:if>
                <li class="page-item">
                    <a class="page-link" href="${baseUrl}?page=${totalPages}${qs}">${totalPages}</a>
                </li>
            </c:if>

            <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                <a class="page-link" href="${page >= totalPages ? '#' : baseUrl.concat('?page=').concat(page+1).concat(qs)}">Next</a>
            </li>
        </ul>
    </nav>

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
    
    // Column resizing functionality
    function initColumnResize() {
        const table = document.querySelector('.resizable-table');
        if (!table) return;
        
        const ths = table.querySelectorAll('th.resizable');
        let currentTh = null;
        let startX = 0;
        let startWidth = 0;
        
        ths.forEach(th => {
            const resizer = th.querySelector('.resizer');
            if (!resizer) return;
            
            resizer.addEventListener('mousedown', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                currentTh = th;
                startX = e.pageX;
                startWidth = th.offsetWidth;
                
                resizer.classList.add('active');
                document.body.style.cursor = 'col-resize';
                document.body.style.userSelect = 'none';
                
                document.addEventListener('mousemove', handleResize);
                document.addEventListener('mouseup', stopResize);
            });
        });
        
        function handleResize(e) {
            if (!currentTh) return;
            
            const diff = e.pageX - startX;
            const newWidth = Math.max(50, startWidth + diff); // Minimum width 50px
            currentTh.style.width = newWidth + 'px';
            
            // Update table layout
            table.style.tableLayout = 'fixed';
        }
        
        function stopResize() {
            if (currentTh) {
                const resizer = currentTh.querySelector('.resizer');
                if (resizer) {
                    resizer.classList.remove('active');
                }
            }
            
            currentTh = null;
            document.body.style.cursor = '';
            document.body.style.userSelect = '';
            
            document.removeEventListener('mousemove', handleResize);
            document.removeEventListener('mouseup', stopResize);
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize column resizing
        initColumnResize();
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
            
            let html = '<div class="product-detail-container">';
            
            // Header Section
            html += '<div class="product-header mb-4 pb-3 border-bottom">';
            html += '<div class="d-flex justify-content-between align-items-start">';
            html += '<div>';
            html += '<h4 class="mb-2 text-primary">' + (product.name || 'N/A') + '</h4>';
            html += '<p class="text-muted mb-0"><strong>SKU:</strong> ' + (product.sku || 'N/A') + '</p>';
            html += '</div>';
            html += '<div class="text-end">';
            html += '<span class="badge bg-info fs-6">ID: ' + (product.productId || '') + '</span>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            // Main Information Cards
            html += '<div class="row mb-4">';
            
            // Left Column - Basic Information
            html += '<div class="col-md-6">';
            html += '<div class="card h-100 shadow-sm">';
            html += '<div class="card-header bg-primary text-white">';
            html += '<h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Basic Information</h6>';
            html += '</div>';
            html += '<div class="card-body">';
            html += '<table class="table table-borderless mb-0">';
            html += '<tr><td class="text-muted" style="width: 40%;"><strong>Product Name:</strong></td><td>' + (product.name || 'N/A') + '</td></tr>';
            html += '<tr><td class="text-muted"><strong>SKU:</strong></td><td><span class="badge bg-secondary">' + (product.sku || 'N/A') + '</span></td></tr>';
            html += '<tr><td class="text-muted"><strong>Barcode:</strong></td><td>' + (product.barcode || 'N/A') + '</td></tr>';
            html += '<tr><td class="text-muted"><strong>Category:</strong></td><td>' + (product.categoryName || 'N/A') + '</td></tr>';
            html += '<tr><td class="text-muted"><strong>Unit of Measure:</strong></td><td>' + (product.uomName || 'N/A') + '</td></tr>';
            html += '<tr><td class="text-muted"><strong>Created Date:</strong></td><td>' + (product.createdAt || 'N/A') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            // Right Column - Physical Properties
            html += '<div class="col-md-6">';
            html += '<div class="card h-100 shadow-sm">';
            html += '<div class="card-header bg-success text-white">';
            html += '<h6 class="mb-0"><i class="fas fa-ruler-combined me-2"></i>Physical Properties</h6>';
            html += '</div>';
            html += '<div class="card-body">';
            html += '<table class="table table-borderless mb-0">';
            html += '<tr><td class="text-muted" style="width: 40%;"><strong>Weight:</strong></td><td>' + (product.weight ? product.weight + ' kg' : 'N/A') + '</td></tr>';
            html += '<tr><td class="text-muted"><strong>Dimensions:</strong></td><td>';
            if (product.length && product.width && product.height) {
                html += product.length + ' x ' + product.width + ' x ' + product.height + ' cm';
            } else {
                html += 'N/A';
            }
            html += '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            html += '</div>';
            
            // Variants Section
            html += '<div class="card shadow-sm">';
            html += '<div class="card-header bg-info text-white">';
            html += '<h6 class="mb-0"><i class="fas fa-layer-group me-2"></i>Product Variants</h6>';
            html += '</div>';
            html += '<div class="card-body">';
            if (product.variants && product.variants.length > 0) {
                html += '<div class="table-responsive">';
                html += '<table class="table table-hover table-bordered align-middle">';
                html += '<thead class="table-light">';
                html += '<tr class="text-center">';
                html += '<th>Variant SKU</th>';
                html += '<th>Color</th>';
                html += '<th>Size</th>';
                html += '<th>Barcode</th>';
                html += '<th>Quantity (On Hand)</th>';
                html += '<th>Quantity (Available)</th>';
                html += '<th>Status</th>';
                html += '</tr>';
                html += '</thead>';
                html += '<tbody>';
                product.variants.forEach(variant => {
                    html += '<tr>';
                    html += '<td><span class="badge bg-primary">' + (variant.variantSku || 'N/A') + '</span></td>';
                    html += '<td class="text-center">' + (variant.color || 'N/A') + '</td>';
                    html += '<td class="text-center">' + (variant.size || 'N/A') + '</td>';
                    html += '<td>' + (variant.barcode || 'N/A') + '</td>';
                    html += '<td class="text-center"><span class="badge bg-info">' + (variant.totalQtyOnHand ? Math.floor(parseFloat(variant.totalQtyOnHand)) : '0') + '</span></td>';
                    html += '<td class="text-center"><span class="badge bg-success">' + (variant.totalQtyAvailable ? Math.floor(parseFloat(variant.totalQtyAvailable)) : '0') + '</span></td>';
                    html += '<td class="text-center">';
                    html += '<span class="badge bg-' + (variant.status === 'ACTIVE' ? 'success' : 'secondary') + '">';
                    html += variant.status || 'N/A';
                    html += '</span>';
                    html += '</td>';
                    html += '</tr>';
                });
                html += '</tbody>';
                html += '</table>';
                html += '</div>';
            } else {
                html += '<div class="text-center py-4">';
                html += '<i class="fas fa-inbox fa-3x text-muted mb-3"></i>';
                html += '<p class="text-muted mb-0">No variants available for this product</p>';
                html += '</div>';
            }
            html += '</div>';
            html += '</div>';
            
            html += '</div>';
            
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
