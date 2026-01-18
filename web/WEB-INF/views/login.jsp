<%-- 
    Document   : login
    Created on : Jan 18, 2026, 7:28:29 PM
    Author     : chaua
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <style>
            .login-box {
                width: 350px;
                margin: 50px auto;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.2);
                background: #fff;
            }

            .login-box h2 {
                text-align: center;
                margin-bottom: 20px;
                white-space: nowrap;
            }

            .login-box input {
                width: 100%;
                padding: 8px;
                margin: 8px 0 15px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }

            .login-box button {
                width: 100%;
                padding: 10px;
                background: #0d6efd;
                border: none;
                color: white;
                border-radius: 5px;
                cursor: pointer;
            }

            .login-box button:hover {
                background: #0b5ed7;
            }

            .error-msg {
                color: red;
                text-align: center;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>


        <div class="login-box">
            <h2>Đăng nhập hệ thống</h2>

            <form action="<%=request.getContextPath()%>/authen" method="post">

                <label>Tên đăng nhập</label>
                <input type="text" name="username" required
                       oninvalid="this.setCustomValidity('Vui lòng nhập tên đăng nhập')"
                       oninput="this.setCustomValidity('')">

                <label>Mật khẩu</label>
                <input type="password" name="password" required
                       oninvalid="this.setCustomValidity('Vui lòng nhập mật khẩu')"
                       oninput="this.setCustomValidity('')">

                <button type="submit">Đăng nhập</button>
            </form>
            <div class="error-msg">${error}</div>
        </div>
    </body>
</html>
