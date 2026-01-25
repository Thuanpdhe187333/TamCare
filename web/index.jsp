<%-- 
    Document   : index.jsp (Login)
    Created on : Jan 18, 2026
    Author     : chaua
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f5f7fb;
            }

            .login-box {
                width: 360px;
                margin: 70px auto;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.15);
                background: #fff;
            }

            .login-box h2 {
                text-align: center;
                margin-bottom: 18px;
                white-space: nowrap;
                font-size: 22px;
            }

            .hint {
                font-size: 13px;
                color: #555;
                margin-bottom: 14px;
                text-align: center;
            }

            .login-box label {
                display: block;
                margin-top: 10px;
                font-size: 14px;
                color: #222;
            }

            .login-box input {
                width: 100%;
                padding: 9px;
                margin: 8px 0 12px;
                border-radius: 6px;
                border: 1px solid #ccc;
                outline: none;
            }

            .login-box input:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 3px rgba(13,110,253,0.15);
            }

            .login-box button {
                width: 100%;
                padding: 10px;
                background: #0d6efd;
                border: none;
                color: white;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 6px;
                font-size: 15px;
            }

            .login-box button:hover {
                background: #0b5ed7;
            }

            .error-msg {
                color: #dc3545;
                text-align: center;
                margin-top: 12px;
                font-size: 14px;
            }

            .success-msg {
                color: #198754;
                text-align: center;
                margin-top: 12px;
                font-size: 14px;
            }

            .links {
                text-align: center;
                margin-top: 12px;
                font-size: 14px;
            }

            .links a {
                color: #0d6efd;
                text-decoration: none;
            }

            .links a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="login-box">
            <h2>Đăng nhập hệ thống</h2>
            
            <form action="<%=request.getContextPath()%>/authen" method="post">
                <label>Tên đăng nhập hoặc Email</label>
                <input type="text" name="username" required
                       placeholder="Ví dụ: admin hoặc admin@gmail.com"
                       oninvalid="this.setCustomValidity('Vui lòng nhập username hoặc email')"
                       oninput="this.setCustomValidity('')">

                <label>Mật khẩu</label>
                <input type="password" name="password" required
                       placeholder="Nhập mật khẩu"
                       oninvalid="this.setCustomValidity('Vui lòng nhập mật khẩu')"
                       oninput="this.setCustomValidity('')">

                <button type="submit">Đăng nhập</button>
            </form>

            <div class="links">
                <a href="<%=request.getContextPath()%>/authen?action=forgot">Quên mật khẩu?</a>
            </div>

            <c:if test="${not empty message}">
                <div class="success-msg">${message}</div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error-msg">${error}</div>
            </c:if>
        </div>
    </body>
</html>