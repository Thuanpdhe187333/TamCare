<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - TamCare</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                height: 100vh;
                margin: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(rgba(0, 80, 80, 0.4), rgba(0, 80, 80, 0.6)),
                url('${pageContext.request.contextPath}/assets/img/login-bg.png');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                font-family: 'Lexend', sans-serif;
                overflow: hidden;
                position: relative;
            }

            /* Watermark healthcare pattern overlay */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 1;
                pointer-events: none;
                opacity: 0.07;
                background-image:
                    /* Heart icons */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/%3E%3C/svg%3E"),
                    /* Medical cross */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='35' height='35' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10h-4v4h-2v-4H7v-2h4V7h2v4h4v2z'/%3E%3C/svg%3E"),
                    /* Lotus/leaf */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='45' height='45' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M17.8 2.8C16 2.09 13.86 2 12 2c-1.86 0-4 .09-5.8.8C3.53 3.84 2 6.05 2 8.86c0 2.94 1.56 5.81 4.2 7.58.91.61 1.97 1.09 3.09 1.43C10.46 20.57 11.27 22 12 22c.73 0 1.54-1.43 2.71-4.13 1.12-.34 2.18-.82 3.09-1.43C20.44 14.67 22 11.8 22 8.86c0-2.81-1.53-5.02-4.2-6.06zM12 19.5c-.5-1.5-1-2.7-1.5-3.6.5.1 1 .1 1.5.1s1 0 1.5-.1c-.5.9-1 2.1-1.5 3.6z'/%3E%3C/svg%3E"),
                    /* Heartbeat pulse */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='30' viewBox='0 0 60 30' fill='none' stroke='white' stroke-width='2'%3E%3Cpolyline points='0,15 10,15 15,5 20,25 25,10 30,20 35,15 60,15'/%3E%3C/svg%3E"),
                    /* Elderly person icon */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='35' height='35' viewBox='0 0 24 24' fill='white'%3E%3Ccircle cx='12' cy='4.5' r='2'/%3E%3Cpath d='M10.5 7.5c0 0-3.5 2-3.5 6v3h2v5h6v-5h2v-3c0-4-3.5-6-3.5-6h-3z'/%3E%3C/svg%3E"),
                    /* Caring hands */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='white'%3E%3Cpath d='M12.1 18.55l-.1.1-7.1-7.1C3.7 10.35 3 8.76 3 7.08 3 4.83 4.5 3.08 6.75 3.08c1.32 0 2.5.68 3.25 1.51l2-.02c.75-.83 1.93-1.49 3.25-1.49C17.5 3.08 19 4.83 19 7.08c0 1.68-.7 3.27-1.9 4.47l-5 5z'/%3E%3Cpath d='M19 15h-3l-2.09 2.09-1.41-1.42L15.17 13H19c.55 0 1 .45 1 1s-.45 1-1 1zM5 15h3l2.09 2.09 1.41-1.42L8.83 13H5c-.55 0-1 .45-1 1s.45 1 1 1z' opacity='.6'/%3E%3C/svg%3E");
                background-position:
                    5% 8%, 25% 5%, 50% 3%, 75% 8%, 92% 5%, 15% 15%,
                    85% 18%, 40% 20%, 65% 15%, 10% 28%, 30% 32%, 55% 25%,
                    80% 30%, 95% 25%, 5% 40%, 20% 45%, 45% 38%, 70% 42%,
                    90% 45%, 15% 55%, 35% 58%, 60% 52%, 85% 55%, 8% 65%,
                    28% 68%, 50% 62%, 75% 65%, 95% 68%, 12% 78%, 38% 75%,
                    62% 80%, 88% 78%, 5% 88%, 25% 92%, 48% 85%, 72% 90%, 92% 88%;
                background-repeat: no-repeat;
                background-size: 40px, 35px, 45px, 60px, 35px, 40px,
                    35px, 45px, 60px, 40px, 35px, 45px,
                    60px, 40px, 35px, 45px, 40px, 60px,
                    35px, 40px, 45px, 35px, 60px, 40px,
                    35px, 45px, 60px, 40px, 35px, 45px,
                    40px, 60px, 35px, 45px, 40px, 60px, 35px;
            }

            /* Soft glow overlay */
            body::after {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 1;
                pointer-events: none;
                background:
                    radial-gradient(circle at 10% 20%, rgba(255, 255, 255, 0.05) 0%, transparent 50%),
                    radial-gradient(circle at 85% 30%, rgba(255, 255, 255, 0.06) 0%, transparent 40%),
                    radial-gradient(circle at 50% 70%, rgba(255, 255, 255, 0.04) 0%, transparent 50%),
                    radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.05) 0%, transparent 40%),
                    radial-gradient(circle at 80% 85%, rgba(255, 255, 255, 0.04) 0%, transparent 45%);
            }

            .login-container {
                position: relative;
                width: 100%;
                max-width: 450px;
                padding: 20px;
                z-index: 10;
            }

            .login-card {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(15px);
                -webkit-backdrop-filter: blur(15px);
                border-radius: 24px;
                border: 1px solid rgba(255, 255, 255, 0.4);
                padding: 40px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                text-align: center;
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .login-logo {
                width: 70px;
                height: 70px;
                background: #008080;
                color: white;
                border-radius: 18px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 35px;
                margin: 0 auto 20px;
                box-shadow: 0 8px 16px rgba(0, 128, 128, 0.3);
            }

            .login-header h2 {
                font-size: 28px;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 8px;
            }

            .login-header p {
                color: #5f6c7b;
                font-size: 15px;
                margin-bottom: 30px;
            }

            .back-home {
                position: fixed;
                top: 30px;
                left: 30px;
                color: white;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
                text-decoration: none;
                background: rgba(0, 0, 0, 0.3);
                padding: 10px 20px;
                border-radius: 40px;
                backdrop-filter: blur(5px);
                transition: all 0.3s ease;
                z-index: 20;
            }

            .back-home:hover {
                background: rgba(0, 0, 0, 0.5);
                transform: translateX(-5px);
            }

            .error-box {
                background: #fff5f5;
                color: #e53e3e;
                padding: 12px;
                border-radius: 12px;
                margin-bottom: 20px;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 10px;
                border: 1px solid #fed7d7;
                text-align: left;
            }

            .form-group {
                text-align: left;
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
            }

            .input-wrapper {
                position: relative;
            }

            .input-wrapper i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #008080;
                opacity: 0.7;
            }

            .input-wrapper input {
                width: 100%;
                padding: 14px 14px 14px 45px;
                border-radius: 12px;
                border: 1px solid #dcdde1;
                background: white;
                font-size: 15px;
                box-sizing: border-box;
                transition: border-color 0.3s;
            }

            .input-wrapper input:focus {
                outline: none;
                border-color: #008080;
            }

            .btn-login {
                width: 100%;
                padding: 15px;
                background: #008080;
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: background 0.3s;
                margin-top: 10px;
            }

            .btn-login:hover {
                background: #006666;
            }

            .register-link {
                margin-top: 25px;
                color: #5f6c7b;
                font-size: 14px;
            }

            .register-link a {
                color: #008080;
                text-decoration: none;
                font-weight: 700;
            }
        </style>
    </head>

    <body>

        <a href="${pageContext.request.contextPath}/index.jsp" class="back-home">
            <i class="fa-solid fa-arrow-left"></i> Trang chủ
        </a>

        <div class="login-container">
            <div class="login-card">
                <div class="login-logo">
                    <i class="fa-solid fa-hand-holding-heart"></i>
                </div>

                <div class="login-header">
                    <h2>Xin Chào!</h2>
                    <p>Đăng nhập để chăm sóc sức khỏe tốt hơn</p>
                </div>

                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="error-box">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <span>
                            <%= error %>
                        </span>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/login" method="POST">
                            <div class="form-group">
                                <label for="email">Tài khoản Email</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-envelope"></i>
                                    <input type="email" id="email" name="email" placeholder="example@gmail.com"
                                        required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="password">Mật khẩu</label>
                                <div class="input-wrapper">
                                    <i class="fa-solid fa-lock"></i>
                                    <input type="password" id="password" name="password" placeholder="••••••••"
                                        required>
                                </div>
                            </div>

                            <button type="submit" class="btn-login">
                                Đăng Nhập <i class="fa-solid fa-arrow-right-to-bracket"></i>
                            </button>
                        </form>

                        <div class="register-link">
                            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp">Đăng ký
                                ngay</a>
                        </div>
            </div>
        </div>

    </body>

    </html>