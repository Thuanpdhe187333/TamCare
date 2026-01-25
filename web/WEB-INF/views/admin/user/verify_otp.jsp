<%-- 
    Document   : verify_otp
    Created on : Jan 25, 2026
    Author     : chaua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
    <title>Verify OTP</title>
    <style>
        .login-box {
            width: 350px;
            margin: 50px auto;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.2);
            background: #fff;
        }
        .login-box h2 { text-align:center; margin-bottom:20px; white-space:nowrap; }
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
        .login-box button:hover { background:#0b5ed7; }
        .error-msg { color:red; text-align:center; margin-top:10px; }
        .success-msg { color:green; text-align:center; margin-top:10px; }
        .hint { font-size: 13px; color:#555; margin-top:-8px; margin-bottom:10px; }
        a { color:#0d6efd; text-decoration:none; }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Nhập mã OTP</h2>

    <form action="<%=request.getContextPath()%>/authen" method="post">
        <input type="hidden" name="action" value="verify-otp" />

        <label>Mã OTP đã gửi đến email của bạn</label>
        <input type="text" name="otp" required maxlength="6"
               placeholder="Nhập 6 số..."
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
