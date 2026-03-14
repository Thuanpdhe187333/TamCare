<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="header.jsp" %>

<style>
    .detail-container { max-width: 1100px; margin: 50px auto; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); display: flex; gap: 50px; }
    .detail-left { flex: 1; }
    .detail-left img { width: 100%; border-radius: 15px; border: 1px solid #eee; }
    .detail-right { flex: 1.2; display: flex; flex-direction: column; }
    
    .breadcrumb { font-size: 14px; color: #888; margin-bottom: 20px; }
    .p-name-detail { font-size: 32px; font-weight: 800; color: #1e293b; margin: 0 0 15px 0; }
    .p-price-detail { font-size: 28px; font-weight: 700; color: #ee4d2d; margin-bottom: 25px; }
    
    .p-desc-detail { line-height: 1.8; color: #64748b; margin-bottom: 30px; border-top: 1px solid #f1f5f9; padding-top: 20px; }
    
    .quantity-selector { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; }
    .quantity-btn { width: 35px; height: 35px; border: 1px solid #ddd; background: white; cursor: pointer; border-radius: 5px; }
    .quantity-input { width: 50px; text-align: center; border: 1px solid #ddd; padding: 5px; border-radius: 5px; }
    
    .action-btns { display: flex; gap: 20px; }
    .btn-add-cart { background: #00808020; color: #008080; border: 1px solid #008080; padding: 15px 30px; border-radius: 10px; font-weight: 700; cursor: pointer; flex: 1; }
    .btn-buy-now { background: #008080; color: white; border: none; padding: 15px 30px; border-radius: 10px; font-weight: 700; cursor: pointer; flex: 1; }
    .btn-buy-now:hover { background: #006666; }
</style>

<div class="main-content" style="padding-top: 130px; background: #f8fafc; min-height: 80vh;">
    <div class="detail-container">
        <div class="detail-left">
            <img src="assets/img/products/${detail.imageUrl}" onerror="this.src='https://via.placeholder.com/500'" alt="${detail.productName}">
        </div>

        <div class="detail-right">
            <div class="breadcrumb">Cửa hàng / ${detail.productCategory} / ${detail.productName}</div>
            <h1 class="p-name-detail">${detail.productName}</h1>
            <div class="p-price-detail">
                <fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>

            <div class="p-desc-detail">
                <h4 style="color: #334155; margin-bottom: 10px;">Mô tả sản phẩm:</h4>
                <p>${detail.productDescription}</p>
            </div>

            <form action="add-to-cart" method="post">
                <input type="hidden" name="id" value="${detail.id}">
                <div class="quantity-selector">
                    <span>Số lượng:</span>
                    <button type="button" class="quantity-btn" onclick="changeQty(-1)">-</button>
                    <input type="number" name="quantity" id="qty" class="quantity-input" value="1" min="1">
                    <button type="button" class="quantity-btn" onclick="changeQty(1)">+</button>
                </div>

                <div class="action-btns">
                    <button type="submit" class="btn-add-cart"><i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ</button>
                    <button type="button" class="btn-buy-now">Mua ngay</button>
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