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
        :root {
            --primary: #2c5282;
            --primary-light: #e0effa;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --white: #ffffff;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            padding: 60px 0;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            /* Gradient nền đồng bộ tông xanh dương nhẹ */
            background: linear-gradient(135deg, #e0effa 0%, #f0f4f8 40%, #ffffff 100%);
            position: relative;
            overflow-x: hidden;
            font-family: 'Lexend', sans-serif;
        }

        /* Watermark background pattern - Đổi sang màu xanh Primary nhẹ */
        body::before {
            content: '';
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            z-index: 0;
            pointer-events: none;
            opacity: 0.08;
            background-image:
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='40' height='40' viewBox='0 0 24 24' fill='%232c5282'%3E%3Cpath d='M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z'/%3E%3C/svg%3E"),
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='35' height='35' viewBox='0 0 24 24' fill='%232c5282'%3E%3Cpath d='M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10h-4v4h-2v-4H7v-2h4V7h2v4h4v2z'/%3E%3C/svg%3E");
            background-position: 5% 8%, 25% 5%, 50% 3%, 75% 8%, 92% 5%, 15% 15%;
            background-repeat: space;
            background-size: 40px;
        }

        .reg-card {
            width: 100%;
            max-width: 600px;
            padding: 40px;
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            border: 1px solid var(--primary-light);
            box-shadow: 0 20px 50px rgba(44, 82, 130, 0.1);
        }

        .role-selection {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 25px 0;
        }

        .role-option input[type="radio"] { display: none; }

        .role-label {
            display: block;
            padding: 20px;
            text-align: center;
            border: 2px solid #edf2f7;
            border-radius: 16px;
            cursor: pointer;
            transition: var(--transition);
            background: var(--white);
        }

        .role-label:hover {
            border-color: var(--primary-light);
            background: #f8fafc;
        }

        .role-label i {
            font-size: 28px;
            margin-bottom: 10px;
            color: var(--text-muted);
            display: block;
        }

        /* Khi chọn vai trò */
        .role-option input[type="radio"]:checked+.role-label {
            border-color: var(--primary);
            background: var(--primary-light);
        }

        .role-option input[type="radio"]:checked+.role-label i {
            color: var(--primary);
        }

        .back-home {
            position: fixed; top: 20px; left: 20px;
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            background: var(--white);
            padding: 10px 20px;
            border-radius: 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: 0.3s;
            z-index: 10;
        }

        .back-home:hover {
            background: var(--primary-light);
            transform: translateX(-3px);
        }

        /* Nút đăng ký chính */
        .btn-reg {
            background: var(--primary);
            color: white;
            border: none;
            width: 100%;
            padding: 16px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
        }

        .btn-reg:hover {
            background: var(--primary-dark);
            box-shadow: 0 8px 20px rgba(44, 82, 130, 0.3);
            transform: translateY(-2px);
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-main);
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            margin-bottom: 15px;
            box-sizing: border-box;
            outline: none;
        }

        .form-group input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-up { animation: fadeInUp 0.5s ease-out; }
    </style>
</head>

<body>

    <a href="index.jsp" class="back-home">
        <i class="fa-solid fa-arrow-left"></i> Trang chủ
    </a>

    <div class="reg-card animate-up">
        <div style="text-align: center; margin-bottom: 30px;">
            <h2 style="color: var(--primary); font-size: 28px; margin-bottom: 10px;">📝 Đăng Ký Tài Khoản</h2>
            <p style="color: var(--text-muted); font-size: 15px;">Cùng chúng tôi bảo vệ sức khỏe cho người thân</p>
        </div>

        <form action="register" method="POST">
            <p style="text-align: center; font-weight: 600; margin-bottom: 15px;">Bạn là ai?</p>
            <div class="role-selection">
                <div class="role-option">
                    <input type="radio" id="role_elderly" name="role" value="Elderly" checked>
                    <label for="role_elderly" class="role-label">
                        <i class="fa-solid fa-person-cane"></i>
                        <span style="font-weight: 700; display: block;">Người Cao Tuổi</span>
                        <span style="font-size: 12px; color: var(--text-muted);">Chữ to, dễ thao tác</span>
                    </label>
                </div>

                <div class="role-option">
                    <input type="radio" id="role_caregiver" name="role" value="Caregiver">
                    <label for="role_caregiver" class="role-label">
                        <i class="fa-solid fa-user-nurse"></i>
                        <span style="font-weight: 700; display: block;">Người Chăm Sóc</span>
                        <span style="font-size: 12px; color: var(--text-muted);">Quản lý & Theo dõi</span>
                    </label>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
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

            <button type="submit" class="btn-reg">
                Tham Gia TamCare Ngay <i class="fa-solid fa-heart-pulse"></i>
            </button>
        </form>

        <p style="text-align: center; margin-top: 25px; color: var(--text-muted);">
            Bạn đã có tài khoản? <a href="login.jsp" style="color: var(--primary); font-weight: 700; text-decoration: none;">Đăng nhập</a>
        </p>
    </div>
</body>

</html>