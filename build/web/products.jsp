<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="model.User"%>
<%
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
    <meta name="referrer" content="no-referrer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2c5282; 
            --primary-dark: #1a365d;
            --primary-light: #e0effa;
            --orange-shopee: #ee4d2d; 
            --bg-body: #f8fafc;
            --white: #ffffff; 
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 130px; display: flex; flex-direction: column; min-height: 100vh; }

        /* --- HEADER FIXED --- */
        .header-fixed {
            background: var(--primary-light);
            position: fixed; top: 0; width: 100%; z-index: 1002; padding-bottom: 10px;
            box-shadow: 0 2px 15px rgba(44, 82, 130, 0.1);
        }
        .header-top-bar { max-width: 1200px; margin: 0 auto; display: flex; justify-content: flex-end; padding: 5px 20px; gap: 10px; }
        
        /* Hiệu ứng Hover mượt mà cho Top Bar */
        .top-link-item { 
            text-decoration: none; color: var(--primary); font-size: 13px; font-weight: 600;
            display: flex; align-items: center; gap: 6px; padding: 8px 15px; border-radius: 10px;
            transition: var(--transition); cursor: pointer;
        }
        .top-link-item:hover { background: white; transform: translateY(-1px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .header-main { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; padding: 10px 20px; gap: 40px; }
        .logo { font-size: 30px; font-weight: 800; color: var(--primary); text-decoration: none; }

        .search-container { flex: 1; background: white; padding: 4px; border-radius: 10px; display: flex; border: 1px solid #c3dafe; transition: var(--transition); }
        .search-container:focus-within { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1); }
        .search-container input { flex: 1; border: none; padding: 10px 15px; outline: none; background: transparent; }
        .search-container button { background: var(--primary); color: white; border: none; padding: 0 25px; cursor: pointer; border-radius: 8px; }

        .cart-icon-btn { 
            font-size: 26px; color: var(--primary); padding: 10px; cursor: pointer; 
            transition: var(--transition); border-radius: 50%;
        }
        .cart-icon-btn:hover { background: white; color: var(--orange-shopee); transform: scale(1.1); }

        /* --- CATEGORY --- */
        .section-white { max-width: 1200px; margin: 20px auto; background: white; border-radius: 12px; border: 1px solid var(--primary-light); overflow: hidden; }
        .category-grid { display: grid; grid-template-columns: repeat(10, 1fr); }
        .category-item { display: flex; flex-direction: column; align-items: center; padding: 15px 5px; text-decoration: none; color: #4a5568; transition: var(--transition); font-size: 12px; }
        .category-item:hover { background: var(--primary-light); color: var(--primary); transform: translateY(-2px); }
        .category-item i { font-size: 22px; color: var(--primary); margin-bottom: 8px; }

        /* --- PRODUCTS GRID --- */
        .product-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(5, 1fr); gap: 20px; padding: 0 10px 40px; }
        .product-card { 
            background: white; padding: 15px; text-decoration: none; color: inherit; 
            transition: var(--transition); border: 1px solid #edf2f7; 
            display: flex; flex-direction: column; border-radius: 16px;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.08); border-color: var(--primary); }
        
        .product-img { width: 100%; aspect-ratio: 1/1; display: flex; align-items: center; justify-content: center; overflow: hidden; margin-bottom: 12px; }
        .product-img img { width: 100%; height: 100%; object-fit: contain; transition: var(--transition); }
        .product-card:hover img { transform: scale(1.08); }
        
        .product-name { font-size: 14px; font-weight: 600; color: #2d3748; height: 40px; overflow: hidden; margin-bottom: 8px; line-height: 1.4; }
        .product-price { color: var(--orange-shopee); font-size: 18px; font-weight: 800; }

        .footer { background: var(--primary-dark); color: white; padding: 40px; text-align: center; margin-top: auto; }
    </style>
</head>
<body>

    <div class="header-fixed">
        <div class="header-top-bar">
            <div class="top-link-item"><i class="fa-solid fa-bell"></i> Thông báo</div>
            <div class="top-link-item"><i class="fa-solid fa-circle-question"></i> Hỗ trợ</div>
            <a href="profile.jsp" class="top-link-item"><i class="fa-solid fa-circle-user"></i> <%= userName %></a>
        </div>

        <header class="header-main">
            <a href="home" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
            <form action="products" method="get" class="search-container">
                <input type="text" name="txt" placeholder="Tìm thiết bị y tế, thực phẩm chức năng..." value="${param.txt}">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <%-- ĐÃ SỬA: Đường dẫn icon giỏ hàng đến cart.jsp --%>
            <div class="cart-icon-btn" onclick="window.location.href='cart.jsp'">
                <i class="fa-solid fa-cart-shopping"></i>
            </div>
        </header>
    </div>

    <div class="product-grid">
        <c:forEach items="${productList}" var="p">
            <%-- ĐÃ SỬA: Chuyển đường dẫn về products?id= để Servlet xử lý chi tiết --%>
            <a href="products?id=${p.id}" class="product-card">
                <div class="product-img">
                    <c:choose>
                        <c:when test="${not empty p.imageUrl}">
                            <c:set var="imgSrc" value="${p.imageUrl.startsWith('http') ? p.imageUrl : 'assets/img/products/'.concat(p.imageUrl)}" />
                            <img src="${imgSrc}" referrerpolicy="no-referrer" alt="${p.productName}"
                                 onerror="this.src='https://icons.veryicon.com/png/o/business/office-icon-1/product-14.png';">
                        </c:when>
                        <c:otherwise><i class="fa-solid fa-box-open" style="font-size: 50px; color: #cbd5e1;"></i></c:otherwise>
                    </c:choose>
                </div>
                <div class="product-name">${p.productName}</div>
                <div class="product-price">
                    <fmt:formatNumber value="${p.price}" pattern="###,###,### ₫"/>
                </div>
            </a>
        </c:forEach>
    </div>

    <footer class="footer">
        &copy; 2026 TamCare Team - Giải pháp sức khỏe cho người cao tuổi.
    </footer>
</body>
</html>