<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký - TamCare</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                padding: 60px 0;
                margin: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, #e0f2f1 0%, #f0f4f8 40%, #e8f5e9 70%, #f0f4f8 100%);
                position: relative;
                overflow-x: hidden;
            }

            /* Watermark background pattern */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 0;
                pointer-events: none;
                opacity: 0.06;
                background-image:
                    /* Heart icons */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='%23008080'%3E%3Cpath d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/%3E%3C/svg%3E"),
                    /* Medical cross */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='35' height='35' viewBox='0 0 24 24' fill='%23008080'%3E%3Cpath d='M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10h-4v4h-2v-4H7v-2h4V7h2v4h4v2z'/%3E%3C/svg%3E"),
                    /* Lotus/leaf */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='45' height='45' viewBox='0 0 24 24' fill='%23008080'%3E%3Cpath d='M17.8 2.8C16 2.09 13.86 2 12 2c-1.86 0-4 .09-5.8.8C3.53 3.84 2 6.05 2 8.86c0 2.94 1.56 5.81 4.2 7.58.91.61 1.97 1.09 3.09 1.43C10.46 20.57 11.27 22 12 22c.73 0 1.54-1.43 2.71-4.13 1.12-.34 2.18-.82 3.09-1.43C20.44 14.67 22 11.8 22 8.86c0-2.81-1.53-5.02-4.2-6.06zM12 19.5c-.5-1.5-1-2.7-1.5-3.6.5.1 1 .1 1.5.1s1 0 1.5-.1c-.5.9-1 2.1-1.5 3.6z'/%3E%3C/svg%3E"),
                    /* Heartbeat pulse */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='60' height='30' viewBox='0 0 60 30' fill='none' stroke='%23008080' stroke-width='2'%3E%3Cpolyline points='0,15 10,15 15,5 20,25 25,10 30,20 35,15 60,15'/%3E%3C/svg%3E"),
                    /* Elderly person icon */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='35' height='35' viewBox='0 0 24 24' fill='%23008080'%3E%3Ccircle cx='12' cy='4.5' r='2'/%3E%3Cpath d='M10.5 7.5c0 0-3.5 2-3.5 6v3h2v5h6v-5h2v-3c0-4-3.5-6-3.5-6h-3z'/%3E%3C/svg%3E"),
                    /* Caring hands */
                    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='%23008080'%3E%3Cpath d='M12.1 18.55l-.1.1-7.1-7.1C3.7 10.35 3 8.76 3 7.08 3 4.83 4.5 3.08 6.75 3.08c1.32 0 2.5.68 3.25 1.51l2-.02c.75-.83 1.93-1.49 3.25-1.49C17.5 3.08 19 4.83 19 7.08c0 1.68-.7 3.27-1.9 4.47l-5 5z'/%3E%3Cpath d='M19 15h-3l-2.09 2.09-1.41-1.42L15.17 13H19c.55 0 1 .45 1 1s-.45 1-1 1zM5 15h3l2.09 2.09 1.41-1.42L8.83 13H5c-.55 0-1 .45-1 1s.45 1 1 1z' opacity='.6'/%3E%3C/svg%3E");
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

            /* Floating animated circles */
            body::after {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 0;
                pointer-events: none;
                background:
                    radial-gradient(circle at 10% 20%, rgba(0, 128, 128, 0.04) 0%, transparent 50%),
                    radial-gradient(circle at 85% 30%, rgba(0, 128, 128, 0.05) 0%, transparent 40%),
                    radial-gradient(circle at 50% 70%, rgba(0, 128, 128, 0.03) 0%, transparent 50%),
                    radial-gradient(circle at 20% 80%, rgba(76, 175, 80, 0.04) 0%, transparent 40%),
                    radial-gradient(circle at 80% 85%, rgba(0, 128, 128, 0.04) 0%, transparent 45%);
            }

            .reg-card {
                width: 100%;
                max-width: 650px;
                padding: 50px;
                position: relative;
                z-index: 1;
                background: rgba(255, 255, 255, 0.85);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.5);
                box-shadow: 0 20px 50px rgba(0, 128, 128, 0.08), 0 5px 15px rgba(0, 0, 0, 0.05);
            }

            .role-selection {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin: 30px 0;
            }

            .role-option {
                position: relative;
            }

            .role-option input[type="radio"] {
                display: none;
            }

            .role-label {
                display: block;
                padding: 24px;
                text-align: center;
                border: 2px solid #edf2f7;
                border-radius: 20px;
                cursor: pointer;
                transition: var(--transition);
                background: rgba(255, 255, 255, 0.7);
            }

            .role-label:hover {
                border-color: rgba(0, 128, 128, 0.3);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 128, 128, 0.1);
            }

            .role-label i {
                font-size: 32px;
                margin-bottom: 12px;
                color: var(--text-muted);
                display: block;
            }

            .role-option input[type="radio"]:checked+.role-label {
                border-color: var(--primary);
                background: var(--primary-light);
            }

            .role-option input[type="radio"]:checked+.role-label i {
                color: var(--primary);
            }

            .back-home {
                position: fixed;
                top: 20px;
                left: 20px;
                color: #008080;
                z-index: 10;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                background: rgba(255, 255, 255, 0.8);
                padding: 10px 20px;
                border-radius: 40px;
                backdrop-filter: blur(5px);
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                transition: all 0.3s ease;
            }

            .back-home:hover {
                background: rgba(0, 128, 128, 0.1);
                transform: translateX(-3px);
            }

            /* Subtle animation */
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

            .animate-up {
                animation: fadeInUp 0.6s ease-out;
            }
        </style>
    </head>

    <body>

        <a href="index.jsp" class="back-home">
            <i class="fa-solid fa-arrow-left"></i> Trang chủ
        </a>

        <div class="card reg-card animate-up">
            <div style="text-align: center; margin-bottom: 40px;">
                <h2 style="color: var(--primary); font-size: 32px;">📝 Đăng Ký Tài Khoản</h2>
                <p style="color: var(--text-muted);">Cùng chúng tôi bảo vệ sức khẻ cho người thân</p>
            </div>

            <form action="register" method="POST">
                <p style="text-align: center; font-weight: 600;">Bạn là ai?</p>
                <div class="role-selection">
                    <div class="role-option">
                        <input type="radio" id="role_elderly" name="role" value="Elderly" checked>
                        <label for="role_elderly" class="role-label">
                            <i class="fa-solid fa-person-cane"></i>
                            <span style="font-weight: 700; display: block;">Người Cao Tuổi</span>
                            <span style="font-size: 13px; color: var(--text-muted);">Chữ to, dễ thao tác</span>
                        </label>
                    </div>

                    <div class="role-option">
                        <input type="radio" id="role_caregiver" name="role" value="Caregiver">
                        <label for="role_caregiver" class="role-label">
                            <i class="fa-solid fa-user-nurse"></i>
                            <span style="font-weight: 700; display: block;">Người Chăm Sóc</span>
                            <span style="font-size: 13px; color: var(--text-muted);">Quản lý & Theo dõi</span>
                        </label>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="fullname" required placeholder="Nguyễn Văn A">
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <input type="text" name="phone" required placeholder="09xx xxx xxx">
                    </div>
                </div>

                <div class="form-group">
                    <label>Email liên hệ</label>
                    <input type="email" name="email" required placeholder="email@vi-du.com">
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" required placeholder="••••••••">
                </div>

                <button type="submit" class="btn btn-primary"
                    style="width: 100%; justify-content: center; padding: 18px; margin-top: 20px;">
                    Tham Gia TamCare Ngay <i class="fa-solid fa-heart-pulse"></i>
                </button>
            </form>

            <p style="text-align: center; margin-top: 30px; color: var(--text-muted);">
                Bạn đã có tài khoản? <a href="login.jsp" style="color: var(--primary); font-weight: 600;">Đăng nhập</a>
            </p>
        </div>
    </body>

    </html>