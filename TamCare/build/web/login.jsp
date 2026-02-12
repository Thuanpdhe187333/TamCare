<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - TamCare</title>
    <style>
        body { 
            font-family: 'Segoe UI', sans-serif; 
            background-color: #f0f8ff; 
            display: flex; justify-content: center; align-items: center; 
            min-height: 100vh; margin: 0; 
        }

        .container {
            background-color: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px; /* Rộng hơn để dễ nhìn */
            border-top: 10px solid #0066cc;
        }

        .back-btn { text-decoration: none; font-size: 18px; color: #666; display: block; margin-bottom: 20px; }
        h2 { text-align: center; color: #0066cc; font-size: 32px; margin-top: 0; }

        label { font-size: 20px; font-weight: bold; color: #333; display: block; margin-bottom: 10px; margin-top: 20px; }
        
        /* Ô nhập liệu TO và RÕ */
        input[type=email], input[type=password] {
            width: 100%;
            padding: 15px;
            font-size: 20px; /* Chữ to */
            border: 2px solid #ccc;
            border-radius: 10px;
            box-sizing: border-box;
            background-color: #fafafa;
        }
        input:focus { border-color: #0066cc; outline: none; background-color: white; }

        .btn-submit {
            width: 100%;
            padding: 18px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 22px;
            font-weight: bold;
            margin-top: 30px;
            cursor: pointer;
        }
        .btn-submit:hover { background-color: #0052a3; }

        .error { background-color: #ffe6e6; color: #d63031; padding: 15px; border-radius: 10px; text-align: center; font-size: 18px; margin-bottom: 20px; }
        .link { text-align: center; margin-top: 30px; font-size: 18px; }
        .link a { color: #0066cc; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.jsp" class="back-btn">⬅️ Quay lại Trang chủ</a>
        
        <h2>Đăng Nhập</h2>

        <% String error = (String) request.getAttribute("error"); if (error != null) { %>
            <div class="error">⚠️ <%= error %></div>
        <% } %>

        <form action="login" method="POST">
            <label for="email">📧 Email của bạn:</label>
            <input type="email" id="email" name="email" placeholder="Ví dụ: ongba@gmail.com" required>

            <label for="password">🔑 Mật khẩu:</label>
            <input type="password" id="password" name="password" required>

            <input type="submit" value="Vào Hệ Thống" class="btn-submit">
        </form>

        <div class="link">
            Chưa có tài khoản? <a href="register.jsp">Đăng ký mới tại đây</a>
        </div>
    </div>
</body>
</html>