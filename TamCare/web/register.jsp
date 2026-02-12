<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - TamCare</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f0f8ff; display: flex; justify-content: center; padding: 50px 0; }
        .container { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); width: 600px; }
        
        h2 { text-align: center; color: #0066cc; }
        input[type=text], input[type=email], input[type=password] {
            width: 100%; padding: 15px; margin: 10px 0; border: 1px solid #ccc; border-radius: 10px; box-sizing: border-box; font-size: 16px;
        }

        /* CSS cho phần chọn Role dạng thẻ */
        .role-selection { display: flex; gap: 20px; margin: 20px 0; }
        .role-option {
            flex: 1; border: 2px solid #ddd; border-radius: 15px; padding: 15px; text-align: center; cursor: pointer; transition: 0.3s;
        }
        .role-option:hover { border-color: #0066cc; background-color: #e6f2ff; }
        
        /* Ẩn nút radio mặc định */
        input[type="radio"] { display: none; }
        
        /* Khi radio được chọn thì đổi màu thẻ bao quanh */
        input[type="radio"]:checked + label {
            background-color: #0066cc; color: white; border-color: #0066cc; box-shadow: 0 5px 15px rgba(0,102,204,0.3);
        }
        input[type="radio"]:checked + label .icon { filter: brightness(0) invert(1); } /* Đổi icon sang trắng */

        .role-label { display: block; width: 100%; height: 100%; border-radius: 13px; padding: 10px 0; }
        .icon { font-size: 40px; display: block; margin-bottom: 10px; }
        .title { font-weight: bold; font-size: 18px; }

        .btn-submit { background-color: #28a745; color: white; border: none; padding: 15px; width: 100%; font-size: 20px; border-radius: 10px; cursor: pointer; margin-top: 20px; }
        .btn-submit:hover { background-color: #218838; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📝 Đăng Ký Tài Khoản</h2>
        
        <form action="register" method="POST">
            <p style="text-align: center; font-weight: bold;">Bạn là ai?</p>
            <div class="role-selection">
                <div class="role-option" style="padding: 0;">
                    <input type="radio" id="role_elderly" name="role" value="Elderly" checked>
                    <label for="role_elderly" class="role-label">
                        <span class="icon">👴👵</span>
                        <span class="title">Người Cao Tuổi</span>
                        <div style="font-size: 13px; margin-top: 5px;">(Giao diện chữ to, dễ dùng)</div>
                    </label>
                </div>

                <div class="role-option" style="padding: 0;">
                    <input type="radio" id="role_caregiver" name="role" value="Caregiver">
                    <label for="role_caregiver" class="role-label">
                        <span class="icon">🧑‍⚕️🏠</span>
                        <span class="title">Người Chăm Sóc</span>
                        <div style="font-size: 13px; margin-top: 5px;">(Quản lý hồ sơ, lịch trình)</div>
                    </label>
                </div>
            </div>

            <label>Họ và tên:</label>
            <input type="text" name="fullname" required placeholder="Nguyễn Văn A">

            <label>Email:</label>
            <input type="email" name="email" required placeholder="email@example.com">

            <label>Mật khẩu:</label>
            <input type="password" name="password" required>

            <label>Số điện thoại:</label>
            <input type="text" name="phone" required placeholder="0912...">

            <input type="submit" value="Đăng Ký Ngay" class="btn-submit">
        </form>
        <p style="text-align: center;"><a href="login.jsp">Đã có tài khoản? Đăng nhập</a></p>
    </div>
</body>
</html>