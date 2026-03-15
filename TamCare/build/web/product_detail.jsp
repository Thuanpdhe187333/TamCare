<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="header.jsp" %>

<style>
    :root {
        --primary-bg: #e0effa; /* Màu chính bác chọn */
        --text-dark: #2d3748;
        --white: #ffffff;
        --price-color: #ee4d2d;
        --border-color: #c9e2f5;
    }

    body { background-color: #f8fafc; }

    .detail-container { 
        max-width: 1100px; 
        margin: 50px auto; 
        background: var(--white); 
        padding: 40px; 
        border-radius: 20px; 
        box-shadow: 0 8px 25px rgba(224, 239, 250, 0.5); /* Shadow cùng tông màu */
        display: flex; 
        gap: 50px; 
        border: 2px solid var(--primary-bg);
    }
    
    .detail-left { flex: 1; }
    .detail-left img { 
        width: 100%; 
        border-radius: 12px; 
        border: 1px solid var(--primary-bg);
        background: var(--white);
        padding: 10px;
    }
    
    .detail-right { flex: 1.2; }
    
    .breadcrumb { font-size: 14px; color: #718096; margin-bottom: 15px; }
    .breadcrumb span { color: var(--text-dark); font-weight: 600; }
    
    .p-name-detail { font-size: 30px; font-weight: 800; color: var(--text-dark); margin-bottom: 10px; line-height: 1.2; }
    
    /* Vùng giá tiền nổi bật trên nền màu bác chọn */
    .price-box {
        background: var(--primary-bg);
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 25px;
    }
    .p-price-detail { font-size: 32px; font-weight: 700; color: var(--price-color); }
    
    .p-desc-detail { line-height: 1.7; color: #4a5568; margin-bottom: 30px; }
    .p-desc-detail h4 { color: var(--text-dark); border-left: 4px solid var(--primary-bg); padding-left: 10px; margin-bottom: 10px; }
    
    .quantity-selector { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; }
    .quantity-btn { 
        width: 38px; height: 38px; 
        border: 1px solid var(--border-color); 
        background: var(--primary-bg); 
        color: var(--text-dark);
        cursor: pointer; border-radius: 6px; font-weight: bold;
    }
    .quantity-btn:hover { background: #c5dff2; }
    
    .quantity-input { 
        width: 55px; height: 38px; text-align: center; 
        border: 1px solid var(--border-color); border-radius: 6px; outline: none;
    }
    
    .action-btns { display: flex; gap: 15px; }
    
    /* Nút Thêm vào giỏ dùng màu nền #e0effa */
    .btn-add-cart { 
        background: var(--primary-bg); 
        color: #1a4a73; 
        border: 1px solid #b8d9f1; 
        padding: 16px; border-radius: 10px; font-weight: 700; 
        cursor: pointer; flex: 1; display: flex; align-items: center; justify-content: center; gap: 10px;
        transition: 0.3s;
    }
    .btn-add-cart:hover { background: #cde4f5; }
    
    /* Nút Mua ngay dùng tông đậm hơn của màu đó để nổi bật */
    .btn-buy-now { 
        background: #3182ce; /* Xanh dương đậm để khách dễ thấy nút quan trọng nhất */
        color: white; border: none; 
        padding: 16px; border-radius: 10px; font-weight: 700; 
        cursor: pointer; flex: 1; transition: 0.3s;
    }
    .btn-buy-now:hover { background: #2b6cb0; transform: translateY(-2px); }
</style>

<div class="main-content" style="padding-top: 130px; min-height: 90vh;">
    <div class="detail-container">
        <div class="detail-left">
            <img src="assets/img/products/${detail.imageUrl}" 
                 onerror="this.src='https://via.placeholder.com/500x500?text=TamCare+Product'" 
                 alt="${detail.productName}">
        </div>

        <div class="detail-right">
            <div class="breadcrumb">Cửa hàng / ${detail.productCategory} / <span>${detail.productName}</span></div>
            
            <h1 class="p-name-detail">${detail.productName}</h1>
            
            <div class="price-box">
                <span class="p-price-detail">
                    <fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                </span>
            </div>

            <div class="p-desc-detail">
                <h4>Thông tin sản phẩm</h4>
                <p>${detail.productDescription}</p>
            </div>

            <form action="add-to-cart" method="post">
                <input type="hidden" name="id" value="${detail.id}">
                
                <div class="quantity-selector">
                    <span style="font-weight: 600;">Số lượng:</span>
                    <button type="button" class="quantity-btn" onclick="changeQty(-1)">-</button>
                    <input type="number" name="quantity" id="qty" class="quantity-input" value="1" min="1">
                    <button type="button" class="quantity-btn" onclick="changeQty(1)">+</button>
                </div>

                <div class="action-btns">
                    <button type="submit" class="btn-add-cart">
                        <i class="fa-solid fa-cart-shopping"></i> Thêm vào giỏ hàng
                    </button>
                    <button type="button" class="btn-buy-now">
                        Mua ngay
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function changeQty(delta) {
        var input = document.getElementById('qty');
        var newVal = parseInt(input.value) + delta;
        if (newVal >= 1) input.value = newVal;
    }
</script>

<%@include file="footer.jsp" %>