<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TamCare - Chăm sóc người cao tuổi</title>
    <style>
        /* CSS DÀNH CHO NGƯỜI CAO TUỔI */
        body { 
            margin: 0; 
            font-family: 'Segoe UI', Arial, sans-serif; 
            font-size: 18px; /* Cỡ chữ cơ bản lớn */
            background-color: #f0f8ff; /* Màu xanh lơ dịu mắt */
            color: #333;
            line-height: 1.6;
        }

        .navbar {
            background-color: #0066cc; /* Xanh đậm tin cậy */
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .logo { font-size: 28px; font-weight: bold; text-decoration: none; color: white; }
        
        .hero {
            text-align: center;
            padding: 60px 20px;
            background: white;
            margin: 20px;
            border-radius: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        h1 { font-size: 40px; color: #004d99; margin-bottom: 10px; }
        p { font-size: 22px; color: #555; max-width: 800px; margin: 0 auto 40px auto; }

        /* Nút bấm chuẩn Accessibility */
        .btn-group { display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; }
        
        .btn {
            padding: 20px 40px;
            font-size: 22px;
            font-weight: bold;
            text-decoration: none;
            border-radius: 50px; /* Bo tròn mềm mại */
            transition: transform 0.2s;
            display: inline-block;
            cursor: pointer;
        }
        
        .btn-primary { background-color: #009933; color: white; border: 2px solid #009933; } /* Xanh lá: Hành động chính */
        .btn-secondary { background-color: white; color: #0066cc; border: 3px solid #0066cc; } /* Xanh dương: Hành động phụ */

        .btn:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }

        .footer { text-align: center; padding: 40px; font-size: 16px; color: #777; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="logo">👴 TamCare</div>
        <%
            User acc = (User) session.getAttribute("account");
            if (acc != null) { 
        %>
            <a href="home.jsp" style="color: white; font-size: 20px; text-decoration: underline;">Vào trang cá nhân &rarr;</a>
        <% } %>
    </div>

    <div class="hero">
        <h1>Chào mừng đến với TamCare</h1>
        <p>Hệ thống chăm sóc sức khỏe thông minh, dễ sử dụng dành cho Bố Mẹ và Ông Bà.</p>
        
        <div class="btn-group">
            <% if (acc == null) { %>
                <a href="login.jsp" class="btn btn-primary">🔐 Đăng Nhập</a>
                <a href="register.jsp" class="btn btn-secondary">📝 Đăng Ký Mới</a>
            <% } else { %>
                <a href="home.jsp" class="btn btn-primary">🏠 Về Trang Chủ</a>
            <% } %>
        </div>
    </div>

    <div class="footer">
        Được xây dựng với tình yêu thương ❤️<br>
        © 2026 TamCare Project
    </div>

</body>
</html>