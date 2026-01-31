<%-- 
    Document   : forgot_password
    Created on : Jan 24, 2026, 8:27:05 PM
    Author     : chaua
--%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>Forgot Password</title>
                <!-- Link to existing Font Awesome -->
                <link href="<%=request.getContextPath()%>/assets/vendor/fontawesome-free/css/all.min.css"
                    rel="stylesheet" type="text/css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
                    rel="stylesheet">

                <style>
                    :root {
                        --error-border: #f87171;
                        --error-bg: #fef2f2;
                        --error-text: #ef4444;
                        --input-border: #d1d5db;
                        --input-bg: #ffffff;
                        --icon-color: #6b7280;
                        --primary-color: #0d6efd;
                    }

                    body {
                        font-family: 'Inter', Arial, sans-serif;
                        background: #f5f7fb;
                        margin: 0;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        min-height: 100vh;
                    }

                    .login-box {
                        width: 100%;
                        max-width: 420px;
                        padding: 40px;
                        border-radius: 20px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                        background: #fff;
                    }

                    .login-box h2 {
                        text-align: center;
                        margin-bottom: 30px;
                        font-weight: 600;
                        color: #1f2937;
                        font-size: 24px;
                    }

                    .input-container {
                        margin-bottom: 20px;
                        position: relative;
                    }

                    .input-wrapper {
                        position: relative;
                        display: flex;
                        align-items: center;
                        background: var(--input-bg);
                        border: 1.5px solid var(--input-border);
                        border-radius: 14px;
                        transition: all 0.2s ease;
                        padding: 4px 16px;
                        height: 52px;
                    }

                    .input-wrapper i.field-icon {
                        color: var(--icon-color);
                        font-size: 18px;
                        width: 24px;
                        text-align: center;
                        margin-right: 12px;
                    }

                    .input-wrapper input {
                        flex: 1;
                        border: none;
                        background: transparent;
                        outline: none;
                        font-size: 15px;
                        color: #374151;
                        height: 100%;
                    }

                    .input-wrapper input::placeholder {
                        color: #9ca3af;
                    }

                    .input-wrapper:focus-within {
                        border-color: var(--primary-color);
                        box-shadow: 0 0 0 4px rgba(13, 110, 253, 0.1);
                    }

                    /* Error State Styling */
                    .input-container.has-error .input-wrapper {
                        border-color: var(--error-border);
                        background: var(--error-bg);
                    }

                    .error-hint {
                        display: none;
                        color: var(--error-text);
                        font-size: 13px;
                        margin-top: 6px;
                        align-items: center;
                        font-weight: 500;
                    }

                    .input-container.has-error .error-hint {
                        display: flex;
                    }

                    .error-hint i {
                        margin-right: 6px;
                        font-size: 12px;
                    }

                    .login-box button {
                        width: 100%;
                        padding: 14px;
                        background: var(--primary-color);
                        border: none;
                        color: white;
                        border-radius: 12px;
                        cursor: pointer;
                        margin-top: 10px;
                        font-size: 16px;
                        font-weight: 600;
                        transition: transform 0.1s, background 0.2s;
                    }

                    .login-box button:hover {
                        background: #0b5ed7;
                    }

                    .login-box button:active {
                        transform: scale(0.98);
                    }

                    .links {
                        text-align: center;
                        margin-top: 20px;
                        font-size: 14px;
                    }

                    .links a {
                        color: var(--primary-color);
                        text-decoration: none;
                        font-weight: 500;
                    }

                    .links a:hover {
                        text-decoration: underline;
                    }

                    .system-message {
                        margin-top: 20px;
                        padding: 12px;
                        border-radius: 10px;
                        text-align: center;
                        font-size: 14px;
                    }

                    .error-msg {
                        background: #fee2e2;
                        color: #dc2626;
                        border: 1px solid #fecaca;
                    }

                    .success-msg {
                        background: #f0fdf4;
                        color: #16a34a;
                        border: 1px solid #bbf7d0;
                    }
                </style>
            </head>

            <body>

                <div class="login-box">
                    <h2>Quên mật khẩu</h2>

                    <form id="forgotForm" action="<%=request.getContextPath()%>/authen" method="post" novalidate>
                        <input type="hidden" name="action" value="forgot" />

                        <!-- Email Field -->
                        <div class="input-container" id="emailContainer">
                            <div class="input-wrapper">
                                <i class="fas fa-envelope field-icon"></i>
                                <input type="email" name="email" id="email" placeholder="Nhập email của bạn" required>
                            </div>
                            <div class="error-hint">
                                <i class="fas fa-exclamation-triangle"></i>
                                Vui lòng nhập email hợp lệ
                            </div>
                        </div>

                        <button type="submit">Gửi mã OTP</button>
                    </form>

                    <c:if test="${not empty message}">
                        <div class="system-message success-msg">${message}</div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="system-message error-msg">${error}</div>
                    </c:if>

                    <div class="links">
                        <a href="<%=request.getContextPath()%>/authen">← Quay về đăng nhập</a>
                    </div>
                </div>

                <script>
                    const form = document.getElementById('forgotForm');
                    const emailInput = document.getElementById('email');
                    const emailContainer = document.getElementById('emailContainer');

                    form.addEventListener('submit', function (event) {
                        let isValid = true;
                        const emailValue = emailInput.value.trim();
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                        if (!emailValue || !emailRegex.test(emailValue)) {
                            emailContainer.classList.add('has-error');
                            isValid = false;
                        } else {
                            emailContainer.classList.remove('has-error');
                        }

                        if (!isValid) {
                            event.preventDefault();
                        }
                    });

                    emailInput.addEventListener('input', () => {
                        if (emailInput.value.trim()) emailContainer.classList.remove('has-error');
                    });
                </script>

            </body>

            </html>