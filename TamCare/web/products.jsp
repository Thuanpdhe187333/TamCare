<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="model.User"%>
<%
    // KIỂM TRA DỮ LIỆU: Nếu chưa qua Servlet, tự động đẩy về Servlet
    if (request.getAttribute("productList") == null) {
        response.sendRedirect("products");
        return;
    }

    User acc = (User) session.getAttribute("account");
    String userName = (acc != null) ? acc.getFullName() : "Khách";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cửa hàng TamCare - Thiết bị Y tế</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #008080; --primary-dark: #006666;
            --orange-shopee: #ee4d2d; --bg-body: #f5f5f5;
            --white: #ffffff; --transition: all 0.2s ease;
        }

        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 130px; display: flex; flex-direction: column; min-height: 100vh; }

        /* --- HEADER FIXED --- */
        .header-fixed {
            background: linear-gradient(-180deg, var(--primary), var(--primary-dark));
            position: fixed; top: 0; width: 100%; z-index: 1002; padding-bottom: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-top-bar { max-width: 1200px; margin: 0 auto; display: flex; justify-content: flex-end; padding: 5px 20px; gap: 25px; font-size: 13px; color: white; }
        .top-link-item { position: relative; cursor: pointer; display: flex; align-items: center; gap: 5px; text-decoration: none; color: white; font-size: 13px; }

        .header-main { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; padding: 10px 20px; gap: 40px; }
        .logo { font-size: 30px; font-weight: 800; color: white; text-decoration: none; }
        .search-container { flex: 1; background: white; padding: 3px; border-radius: 3px; display: flex; }
        .search-container input { flex: 1; border: none; padding: 10px 15px; outline: none; font-family: inherit; }
        .search-container button { background: var(--primary); color: white; border: none; padding: 0 25px; cursor: pointer; }

        /* --- CATEGORY --- */
        .section-white { max-width: 1200px; margin: 20px auto; background: white; border-radius: 2px; box-shadow: 0 1px 1px rgba(0,0,0,.05); }
        .category-grid { display: grid; grid-template-columns: repeat(10, 1fr); }
        .category-item { display: flex; flex-direction: column; align-items: center; padding: 15px 5px; border: 0.5px solid #f5f5f5; text-decoration: none; color: #333; text-align: center; transition: 0.2s; font-size: 12px; }
        .category-item:hover { color: var(--primary); background: #fafafa; transform: translateY(-2px); }
        .category-item i { font-size: 24px; color: var(--primary); margin-bottom: 8px; }

        /* --- PRODUCTS GRID --- */
        .product-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; flex: 1; padding: 0 10px; margin-bottom: 40px; }
        .product-card { 
            background: white; padding: 10px; text-decoration: none; color: inherit; 
            transition: var(--transition); border: 1px solid transparent; 
            display: flex; flex-direction: column; height: 100%; box-sizing: border-box; 
            border-radius: 2px;
        }
        .product-card:hover { transform: translateY(-2px); box-shadow: 0 4px 20px rgba(0,0,0,0.1); border-color: var(--orange-shopee); }
        
        .product-img { width: 100%; aspect-ratio: 1/1; background: #fff; display: flex; align-items: center; justify-content: center; overflow: hidden; }
        .product-img img { width: 100%; height: 100%; object-fit: contain; }
        
        .product-name { font-size: 13px; margin-top: 10px; line-height: 1.4; height: 36px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; color: #333; }
        .product-price { color: var(--orange-shopee); font-size: 16px; font-weight: 600; margin-top: auto; padding-top: 5px; }

        /* --- FOOTER --- */
        .footer { background: #1e293b; color: #94a3b8; padding: 40px 20px; margin-top: auto; }
        .footer-container { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1.5fr; gap: 40px; }
        .footer-col h4 { color: white; margin-bottom: 20px; font-size: 16px; text-transform: uppercase; }
        .footer-col p, .footer-col a { font-size: 14px; color: #94a3b8; text-decoration: none; display: block; margin-bottom: 10px; }
        .footer-col a:hover { color: white; }
        .footer-bottom { max-width: 1200px; margin: 30px auto 0; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1); text-align: center; font-size: 12px; }

        .user-dropdown:hover .dropdown-box { display: flex; }
    </style>
</head>
<body>

    <div class="header-fixed">
        <div class="header-top-bar">
            <div class="top-link-item"><i class="fa-solid fa-bell"></i> Thông báo</div>
            <div class="top-link-item"><i class="fa-solid fa-circle-question"></i> Hỗ trợ</div>
            <div class="top-link-item user-dropdown" style="font-weight: 700;">
                <i class="fa-solid fa-circle-user"></i> <%= userName %>
                <div class="dropdown-box" style="width: 160px; padding: 5px 0; background: white; position: absolute; top: 20px; right: 0; display: none; border-radius: 2px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); flex-direction: column;">
                    <a href="profile.jsp" style="padding: 10px 15px; text-decoration: none; color: #333; display: block; font-size: 14px; font-weight: 400;">Tài khoản</a>
                    <a href="logout" style="padding: 10px 15px; text-decoration: none; color: #333; display: block; border-top: 1px solid #eee; font-size: 14px; font-weight: 400;">Đăng xuất</a>
                </div>
            </div>
        </div>

        <header class="header-main">
            <a href="home" class="logo">TamCare</a>
            <form action="products" method="get" class="search-container">
                <input type="text" name="txt" placeholder="Tìm thiết bị y tế, thực phẩm chức năng..." value="${param.txt}">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <div class="top-link-item" style="font-size: 26px; padding: 10px;">
                <i class="fa-solid fa-cart-shopping"></i>
            </div>
        </header>
    </div>

    <div class="section-white">
        <div class="category-grid">
            <a href="products?category=Huyết áp" class="category-item"><i class="fa-solid fa-heart-pulse"></i><span>Huyết áp</span></a>
            <a href="products?category=Tiểu đường" class="category-item"><i class="fa-solid fa-droplet"></i><span>Tiểu đường</span></a>
            <a href="products?category=Di chuyển" class="category-item"><i class="fa-solid fa-wheelchair"></i><span>Di chuyển</span></a>
            <a href="products?category=Dược phẩm" class="category-item"><i class="fa-solid fa-pills"></i><span>Dược phẩm</span></a>
            <a href="products?category=Nhiệt kế" class="category-item"><i class="fa-solid fa-thermometer"></i><span>Nhiệt kế</span></a>
            <a href="products?category=Máy oxy" class="category-item"><i class="fa-solid fa-lungs"></i><span>Máy oxy</span></a>
            <a href="products?category=Sơ cứu" class="category-item"><i class="fa-solid fa-kit-medical"></i><span>Sơ cứu</span></a>
            <a href="products?category=Giường bệnh" class="category-item"><i class="fa-solid fa-bed-pulse"></i><span>Giường bệnh</span></a>
            <a href="products?category=Vitamin" class="category-item"><i class="fa-solid fa-prescription-bottle-medical"></i><span>Vitamin</span></a>
            <a href="products" class="category-item"><i class="fa-solid fa-ellipsis"></i><span>Tất cả</span></a>
        </div>
    </div>

    <div class="product-grid">
        <c:forEach items="${productList}" var="p">
            <a href="product_detail?id=${p.id}" class="product-card">
                <div class="product-img">
                    <c:choose>
                        <c:when test="${not empty p.imageUrl}">
                            <img src="assets/img/products/${p.imageUrl}" 
                                 onerror="this.src='https://via.placeholder.com/200?text=TamCare'" 
                                 alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-notes-medical" style="color: #eee; font-size: 60px;"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="product-name">${p.productName}</div>
                <div class="product-price">
                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                </div>
            </a>
        </c:forEach>

        <c:if test="${empty productList}">
            <div style="text-align: center; padding: 100px 0; color: #888; grid-column: span 6; background: white; border-radius: 4px;">
                <i class="fa-solid fa-box-open fa-4x" style="margin-bottom: 20px; opacity: 0.4;"></i>
                <p style="font-size: 18px; font-weight: 600;">Hiện tại chưa có sản phẩm này.</p>
                <a href="products" style="color: var(--primary); text-decoration: none; font-weight: 700;">Xem tất cả sản phẩm</a>
            </div>
        </c:if>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-col">
                <h2 style="color: white; margin-top: 0; font-size: 26px;">TamCare</h2>
                <p>Giải pháp sức khỏe cho người cao tuổi <br> bằng công nghệ hiện đại.</p>
            </div>
            <div class="footer-col">
                <h4>Hỗ trợ</h4>
                <a href="#">Trung tâm trợ giúp</a>
                <a href="#">Chính sách bảo mật</a>
                <a href="#">Điều khoản sử dụng</a>
            </div>
            <div class="footer-col">
                <h4>Liên hệ</h4>
                <p><i class="fa-solid fa-phone"></i> 1900 1234</p>
                <p><i class="fa-solid fa-envelope"></i> support@tamcare.vn</p>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2026 TamCare Team. All rights reserved.
        </div>
    </footer>
</body>
</html>