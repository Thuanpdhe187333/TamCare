<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng của bác - TamCare</title>
    <meta name="referrer" content="no-referrer">
    <style>
        :root { 
            --primary: #2c5282;
            --primary-bg: #e0effa; 
            --white: #ffffff; 
            --text-dark: #2d3748;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        body { background-color: #f8fafc; padding-top: 130px; }
        .cart-container { max-width: 1100px; margin: 30px auto; display: grid; grid-template-columns: 1fr 380px; gap: 30px; padding: 0 20px; min-height: 70vh; }
        
        /* Cột bên trái: Danh sách */
        .cart-left { background: var(--white); border-radius: 20px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.03); border: 1px solid var(--primary-bg); }
        .cart-title { font-size: 26px; font-weight: 800; color: var(--text-dark); margin-bottom: 30px; display: flex; align-items: center; gap: 12px; }

        /* Item sản phẩm trong giỏ */
        .cart-item { 
            display: flex; align-items: center; gap: 20px; padding: 20px 0; 
            border-bottom: 1px solid #f1f5f9; transition: var(--transition);
        }
        .cart-item:hover { background-color: #fafcfe; transform: scale(1.01); }
        .item-img { width: 100px; height: 100px; border-radius: 12px; border: 1px solid var(--primary-bg); object-fit: contain; background: white; }
        .item-info { flex: 1; }
        .item-name { font-weight: 700; color: var(--text-dark); margin-bottom: 5px; font-size: 16px; }
        .item-price { color: #ee4d2d; font-weight: 700; }
        
        .btn-remove { 
            background: none; border: none; color: #94a3b8; cursor: pointer; 
            font-size: 14px; transition: var(--transition); display: flex; align-items: center; gap: 5px;
        }
        .btn-remove:hover { color: #ef4444; }

        /* Cột bên phải: Thanh toán */
        .cart-right { background: var(--white); border-radius: 20px; padding: 30px; box-shadow: 0 10px 25px rgba(0,0,0,0.03); height: fit-content; border: 1px solid var(--primary-bg); position: sticky; top: 150px; }
        
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 18px; font-weight: 600; font-size: 15px; }
        
        /* Hiệu ứng nút Thanh toán */
        .btn-checkout { 
            width: 100%; background: #3182ce; color: white; border: none; padding: 18px; 
            border-radius: 12px; font-weight: 700; cursor: pointer; margin-top: 25px; 
            transition: var(--transition); box-shadow: 0 4px 12px rgba(49, 130, 206, 0.2);
        }
        .btn-checkout:hover { background: #2b6cb0; transform: translateY(-3px); box-shadow: 0 8px 20px rgba(49, 130, 206, 0.4); }
        .btn-checkout:active { transform: translateY(0); }
        
        .back-to-shop { color: var(--primary); text-decoration: none; font-weight: 700; display: inline-flex; align-items: center; gap: 8px; transition: var(--transition); padding: 10px 0; }
        .back-to-shop:hover { transform: translateX(-5px); color: var(--primary-dark); }

        .empty-cart { text-align: center; padding: 60px 0; color: #94a3b8; }
    </style>
</head>
<body>
    <div class="cart-container">
        <div class="cart-left">
            <div class="cart-title">
                <i class="fa-solid fa-cart-shopping" style="color: var(--primary);"></i> Giỏ hàng của bác
            </div>
            
            <c:choose>
                <%-- Sau này bác truyền list 'cartItems' từ Servlet vào đây --%>
                <c:when test="${not empty cartItems}">
                    <c:forEach items="${cartItems}" var="item">
                        <div class="cart-item">
                            <img src="${item.product.imageUrl}" class="item-img" alt="${item.product.productName}">
                            <div class="item-info">
                                <div class="item-name">${item.product.productName}</div>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span class="item-price">
                                        <fmt:formatNumber value="${item.product.price}" pattern="###,###,### ₫"/>
                                    </span>
                                    <span style="font-size: 14px; color: #64748b;">Số lượng: ${item.quantity}</span>
                                </div>
                                <button class="btn-remove" style="margin-top: 10px;">
                                    <i class="fa-regular fa-trash-can"></i> Xóa khỏi giỏ
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-cart">
                        <i class="fa-solid fa-basket-shopping fa-5x" style="opacity: 0.15; margin-bottom: 25px;"></i>
                        <p style="font-size: 18px; font-weight: 600;">Giỏ hàng của bác đang trống!</p>
                        <div style="margin-top: 25px;">
                            <a href="products" class="back-to-shop"><i class="fa-solid fa-arrow-left"></i> Quay lại cửa hàng ngay</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="cart-right">
            <h3 style="margin-top: 0; color: var(--text-dark); border-bottom: 1px solid #f1f5f9; padding-bottom: 15px;">Tóm tắt đơn hàng</h3>
            <div class="summary-row"><span>Tạm tính:</span> <span>${totalPrice != null ? totalPrice : '0'} ₫</span></div>
            <div class="summary-row"><span>Giảm giá:</span> <span>0 ₫</span></div>
            <div class="summary-row"><span>Phí vận chuyển:</span> <span style="color: #2ecc71;">Miễn phí</span></div>
            
            <div style="background: #f8fafc; padding: 20px; border-radius: 12px; margin-top: 20px; border: 1px solid var(--primary-bg);">
                <div class="summary-row" style="font-size: 20px; color: #ee4d2d; margin-bottom: 0;">
                    <span>Tổng cộng:</span> 
                    <span><fmt:formatNumber value="${totalPrice != null ? totalPrice : 0}" pattern="###,###,### ₫"/></span>
                </div>
                <small style="color: #94a3b8; display: block; margin-top: 5px;">(Đã bao gồm VAT cho bác)</small>
            </div>
            
            <button class="btn-checkout">TIẾN HÀNH THANH TOÁN</button>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="products" class="back-to-shop" style="font-size: 14px;">Tiếp tục mua sắm</a>
            </div>
        </div>
    </div>
</body>
</html>
<%@include file="footer.jsp" %>