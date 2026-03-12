<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User acc = (User) session.getAttribute("account");
    String userName = (acc != null) ? acc.getFullName() : "Khách";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cửa hàng TamCare - Thiết bị Y tế</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080; 
            --primary-dark: #006666;
            --orange-shopee: #ee4d2d; 
            --bg-body: #f5f5f5;
            --white: #ffffff;
            --transition: all 0.2s ease;
        }

        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 130px; display: flex; flex-direction: column; min-height: 100vh; }

        /* --- HEADER FIXED --- */
        .header-fixed {
            background: linear-gradient(-180deg, var(--primary), var(--primary-dark));
            position: fixed; top: 0; width: 100%; z-index: 1002; padding-bottom: 10px;
        }
        .header-top-bar { max-width: 1200px; margin: 0 auto; display: flex; justify-content: flex-end; padding: 5px 20px; gap: 25px; font-size: 13px; color: white; }
        .top-link-item { position: relative; cursor: pointer; display: flex; align-items: center; gap: 5px; text-decoration: none; color: white; }

        /* --- DROPDOWN BOX --- */
        .dropdown-box {
            position: absolute; top: 25px; right: 0; width: 350px;
            background: var(--white); border-radius: 2px; box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            display: none; flex-direction: column; cursor: default; color: #333; z-index: 1003;
        }
        .dropdown-box::after { content: ''; position: absolute; top: -10px; right: 10px; border-left: 10px solid transparent; border-right: 10px solid transparent; border-bottom: 10px solid white; }
        .top-link-item:hover .dropdown-box { display: flex; }

        /* Giỏ hàng Hover */
        .cart-dropdown { width: 400px; padding: 10px 0; }
        .cart-item-demo { display: flex; padding: 10px 15px; gap: 10px; border-bottom: 1px solid #f5f5f5; align-items: center; }
        .cart-item-demo img { width: 40px; height: 40px; border: 1px solid #eee; object-fit: cover; }
        .btn-view-cart { background: var(--orange-shopee); color: white; text-align: center; padding: 10px; margin: 10px; text-decoration: none; border-radius: 2px; font-size: 14px; }

        /* --- SEARCH & LOGO --- */
        .header-main { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; padding: 10px 20px; gap: 40px; }
        .logo { font-size: 30px; font-weight: 800; color: white; text-decoration: none; }
        .search-container { flex: 1; background: white; padding: 3px; border-radius: 3px; display: flex; }
        .search-container input { flex: 1; border: none; padding: 10px 15px; outline: none; }
        .search-container button { background: var(--primary); color: white; border: none; padding: 0 25px; cursor: pointer; }

        /* --- CATEGORY --- */
        .section-white { max-width: 1200px; margin: 20px auto; background: white; border-radius: 2px; box-shadow: 0 1px 1px rgba(0,0,0,.05); }
        .category-grid { display: grid; grid-template-columns: repeat(10, 1fr); }
        .category-item { display: flex; flex-direction: column; align-items: center; padding: 20px 10px; border: 0.5px solid #f5f5f5; text-decoration: none; color: #333; text-align: center; }
        .category-item i { font-size: 30px; color: var(--primary); margin-bottom: 12px; }

        /* --- PRODUCTS --- */
        .product-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: repeat(6, 1fr); gap: 10px; flex: 1; }
        .product-card { background: white; padding: 10px; text-decoration: none; color: inherit; transition: var(--transition); border: 1px solid transparent; }
        .product-card:hover { transform: translateY(-2px); box-shadow: 0 4px 20px rgba(0,0,0,0.1); border-color: var(--orange-shopee); }
        .product-img { width: 100%; aspect-ratio: 1/1; background: #f9f9f9; display: flex; align-items: center; justify-content: center; font-size: 50px; color: #eee; }
        .product-price { color: var(--orange-shopee); font-size: 16px; font-weight: 600; margin-top: 5px; }

        /* --- CHAT COMPONENT --- */
        #chat-trigger { position: fixed; bottom: 0; right: 30px; background: white; color: var(--orange-shopee); padding: 10px 20px; border-radius: 8px 8px 0 0; box-shadow: 0 -2px 10px rgba(0,0,0,0.1); cursor: pointer; font-weight: 700; z-index: 2001; display: flex; align-items: center; gap: 10px; border: 1px solid #ddd; }
        .chat-window { position: fixed; bottom: 0; right: 30px; width: 350px; background: white; border-radius: 8px 8px 0 0; box-shadow: 0 0 15px rgba(0,0,0,0.1); z-index: 2000; display: none; flex-direction: column; overflow: hidden; border: 1px solid #ddd; }
        .chat-header { background: var(--white); border-bottom: 1px solid #eee; padding: 12px 15px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; }
        .chat-body { height: 350px; background: #f9f9f9; padding: 20px; text-align: center; color: #888; }

        /* --- FOOTER ĐỒNG BỘ --- */
        .footer { background: #1e293b; color: #94a3b8; padding: 60px 40px; margin-top: 50px; }
        .footer-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; gap: 40px; }
        .footer-col h4 { color: white; margin-bottom: 20px; font-size: 18px; }
        .footer-col p, .footer-col a { font-size: 14px; color: #94a3b8; text-decoration: none; display: block; margin-bottom: 10px; transition: 0.3s; }
        .footer-col a:hover { color: var(--primary-light); }
        .footer-bottom { max-width: 1200px; margin: 40px auto 0; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1); text-align: center; font-size: 13px; }
    </style>
</head>
<body>

    <div class="header-fixed">
        <div class="header-top-bar">
            <div class="top-link-item"><i class="fa-solid fa-bell"></i> Thông báo</div>
            <div class="top-link-item"><i class="fa-solid fa-circle-question"></i> Hỗ trợ</div>
            <div class="top-link-item" style="font-weight: 700;">
                <i class="fa-solid fa-circle-user"></i> <%= userName %>
                <div class="dropdown-box" style="width: 160px;">
                    <a href="profile.jsp" style="padding: 12px; text-decoration: none; color: #333; display: block;">Tài khoản</a>
                    <a href="logout" style="padding: 12px; text-decoration: none; color: #333; display: block; border-top: 1px solid #eee;">Đăng xuất</a>
                </div>
            </div>
        </div>

        <header class="header-main">
            <a href="home_caregiver.jsp" class="logo">TamCare</a>
            <div class="search-container">
                <input type="text" placeholder="Tìm thiết bị y tế, thực phẩm chức năng cho người thân...">
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
            <div class="top-link-item" style="font-size: 24px; padding: 10px;">
                <i class="fa-solid fa-cart-shopping"></i>
                <div class="dropdown-box cart-dropdown">
                    <div style="padding: 15px; color: #999; font-size: 14px; border-bottom: 1px solid #f5f5f5;">Sản phẩm mới thêm</div>
                    <div class="cart-item-demo">
                        <img src="https://via.placeholder.com/40" alt="">
                        <div class="cart-info">Máy đo huyết áp Omron JPN600</div>
                        <div class="cart-price">1.250.000₫</div>
                    </div>
                    <div class="cart-item-demo">
                        <img src="https://via.placeholder.com/40" alt="">
                        <div class="cart-info">Xe lăn tay tiêu chuẩn Haruka</div>
                        <div class="cart-price">2.400.000₫</div>
                    </div>
                    <a href="cart.jsp" class="btn-view-cart">Xem Giỏ Hàng</a>
                </div>
            </div>
        </header>
    </div>

    <div class="section-white">
        <div class="category-grid">
            <a href="#" class="category-item"><i class="fa-solid fa-heart-pulse"></i><span>Huyết áp</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-droplet"></i><span>Tiểu đường</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-wheelchair"></i><span>Di chuyển</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-pills"></i><span>Dược phẩm</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-thermometer"></i><span>Nhiệt kế</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-lungs"></i><span>Máy oxy</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-kit-medical"></i><span>Sơ cứu</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-bed-pulse"></i><span>Giường bệnh</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-prescription-bottle-medical"></i><span>Vitamin</span></a>
            <a href="#" class="category-item"><i class="fa-solid fa-ellipsis"></i><span>Thêm</span></a>
        </div>
    </div>

    <div class="product-grid">
        <% for(int i=1; i<=12; i++) { %>
        <a href="product_detail.jsp?id=<%=i%>" class="product-card">
            <div class="product-img"><i class="fa-solid fa-notes-medical"></i></div>
            <div class="product-name">Sản phẩm hỗ trợ sức khỏe TamCare mã số #<%=i%></div>
            <div class="product-price">1.250.000₫</div>
        </a>
        <% } %>
    </div>

    <div id="chat-trigger" onclick="toggleChat()"><i class="fa-solid fa-comment-dots"></i> Chat</div>
    <div class="chat-window" id="chatWindow">
        <div class="chat-header" onclick="toggleChat()"><span>Chat với TamCare</span><i class="fa-solid fa-chevron-down"></i></div>
        <div class="chat-body"><p>Chào mừng! Hãy đặt câu hỏi để chúng tôi hỗ trợ bạn.</p></div>
    </div>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-col">
                <h2 style="color: white; margin-top: 0;">TamCare</h2>
                <p>Giải pháp chăm sóc sức khỏe người cao tuổi <br> hàng đầu bằng công nghệ hiện đại.</p>
            </div>
            <div class="footer-col">
                <h4>Về chúng tôi</h4>
                <a href="about.jsp">Giới thiệu</a>
                <a href="blog.jsp">Blog sức khỏe</a>
                <a href="#">Tuyển dụng</a>
            </div>
            <div class="footer-col">
                <h4>Hỗ trợ khách hàng</h4>
                <a href="#">Trung tâm trợ giúp</a>
                <a href="#">Chính sách bảo mật</a>
                <a href="#">Điều khoản sử dụng</a>
            </div>
            <div class="footer-col">
                <h4>Liên hệ</h4>
                <p><i class="fa-solid fa-phone"></i> Hotline: 1900 1234</p>
                <p><i class="fa-solid fa-envelope"></i> Email: support@tamcare.vn</p>
                <div style="display: flex; gap: 15px; margin-top: 15px; font-size: 20px;">
                    <i class="fa-brands fa-facebook"></i>
                    <i class="fa-brands fa-youtube"></i>
                    <i class="fa-brands fa-linkedin"></i>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2026 TamCare Project Team. All rights reserved.
        </div>
    </footer>

    <script>
        function toggleChat() {
            var window = document.getElementById('chatWindow');
            var trigger = document.getElementById('chat-trigger');
            if (window.style.display === 'flex') {
                window.style.display = 'none';
                trigger.style.display = 'flex';
            } else {
                window.style.display = 'flex';
                trigger.style.display = 'none';
            }
        }
    </script>
</body>
</html>