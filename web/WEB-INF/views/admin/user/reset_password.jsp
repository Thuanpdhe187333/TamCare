<%-- Document : reset_password Created on : Jan 24, 2026, 8:27:55 PM Author : chaua --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Reset Password</title>
            <style>
                .login-box {
                    width: 350px;
                    margin: 50px auto;
                    padding: 25px;
                    border-radius: 10px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
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

                .success-msg {
                    color: green;
                    text-align: center;
                    margin-top: 10px;
                }

                .hint {
                    font-size: 13px;
                    color: #555;
                    margin-top: -8px;
                    margin-bottom: 10px;
                }

                a {
                    color: #0d6efd;
                    text-decoration: none;
                }
            </style>
        </head>

        <body>

            <div class="login-box">
                <h2>Đặt lại mật khẩu</h2>

                <form action="<%=request.getContextPath()%>/authen" method="post">
                    <input type="hidden" name="action" value="reset" />



                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPassword" required
                        oninvalid="this.setCustomValidity('Vui lòng nhập mật khẩu mới')"
                        oninput="this.setCustomValidity('')">

                    <label>Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" required
                        oninvalid="this.setCustomValidity('Vui lòng xác nhận mật khẩu')"
                        oninput="this.setCustomValidity('')">

                    <button type="submit">Cập nhật mật khẩu</button>
                </form>

                <c:if test="${not empty message}">
                    <div class="success-msg">${message}</div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="error-msg">${error}</div>
                </c:if>

                <div style="text-align:center; margin-top:12px;">
                    <a href="<%=request.getContextPath()%>/authen?action=forgot">← Gửi lại OTP</a>
                    <span style="margin: 0 6px;">|</span>
                    <a href="<%=request.getContextPath()%>/authen">Đăng nhập</a>
                </div>
            </div>

        </body>

        </html>