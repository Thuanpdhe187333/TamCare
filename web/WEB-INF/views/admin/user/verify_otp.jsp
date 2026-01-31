<%-- Document : verify_otp Created on : Jan 25, 2026 Author : chaua --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Verify OTP</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
                    rel="stylesheet">
                <style>
                    body {
                        font-family: 'Inter', Arial, sans-serif;
                        background: #f5f7fb;
                    }

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
                        font-weight: 600;
                    }

                    .login-box label {
                        font-size: 14px;
                        color: #374151;
                        font-weight: 500;
                    }

                    .login-box input {
                        width: 100%;
                        padding: 10px;
                        margin: 8px 0 15px;
                        border-radius: 8px;
                        border: 1px solid #d1d5db;
                        box-sizing: border-box;
                        outline: none;
                    }

                    .login-box input:focus {
                        border-color: #0d6efd;
                        box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.1);
                    }

                    .login-box button {
                        width: 100%;
                        padding: 12px;
                        background: #0d6efd;
                        border: none;
                        color: white;
                        border-radius: 8px;
                        cursor: pointer;
                        font-weight: 600;
                        font-size: 15px;
                    }

                    .login-box button:hover {
                        background: #0b5ed7;
                    }

                    .error-msg {
                        color: red;
                        text-align: center;
                        margin-top: 10px;
                        font-size: 14px;
                    }

                    .success-msg {
                        color: green;
                        text-align: center;
                        margin-top: 10px;
                        font-size: 14px;
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
                        font-weight: 500;
                    }

                    a:hover {
                        text-decoration: underline;
                    }
                </style>
            </head>

            <body>

                <div class="login-box">
                    <h2>Nhập mã OTP</h2>

                    <form action="<%=request.getContextPath()%>/authen" method="post">
                        <input type="hidden" name="action" value="verify-otp" />

                        <label>Mã OTP đã gửi đến email của bạn</label>
                        <input type="text" name="otp" required maxlength="6" placeholder="Nhập 6 số..."
                            oninvalid="this.setCustomValidity('Vui lòng nhập mã OTP')"
                            oninput="this.setCustomValidity('')">

                        <button type="submit">Xác nhận</button>
                    </form>

                    <c:if test="${not empty error}">
                        <div class="error-msg">${error}</div>
                    </c:if>

                    <div style="text-align:center; margin-top:12px;">
                        <a href="<%=request.getContextPath()%>/authen?action=forgot">← Gửi lại OTP</a>
                    </div>
                </div>

            </body>

            </html>