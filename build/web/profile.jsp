<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="dal.UserDAO"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin cá nhân - TamCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f7fb;
                margin: 0;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                min-height: 100vh;
                padding-top: 60px;
            }
            .card {
                background: #ffffff;
                border-radius: 24px;
                box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
                padding: 30px;
                width: 580px;
            }
            .card-header {
                display: flex;
                align-items: center;
                gap: 18px;
                margin-bottom: 20px;
            }
            .avatar {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                background: #e0f2fe;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                color: #0369a1;
                font-weight: 800;
            }
            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px dashed #e2e8f0;
                font-size: 15px;
            }
            .info-row span:first-child {
                color: #64748b;
            }
            .chip {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
                background: #e0f2fe;
                color: #0369a1;
                margin-left: 6px;
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                text-decoration: none;
                color: #0f766e;
                font-size: 14px;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <%
            User acc = (User) session.getAttribute("account");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // Tạm thời: tuổi, giới tính chưa có trong bảng Users nên hiển thị "Chưa cập nhật"
            String fullName = acc.getFullName();
            String initial = (fullName != null && !fullName.isEmpty()) ? fullName.substring(0,1).toUpperCase() : "?";

            String roleLabel = "Tài khoản";
            String backHref = "index.jsp";
            if ("Elderly".equalsIgnoreCase(acc.getRole())) {
                roleLabel = "Ông/Bà đang được chăm sóc";
                backHref = "home_elderly.jsp";
            } else if ("Caregiver".equalsIgnoreCase(acc.getRole())) {
                roleLabel = "Người chăm sóc";
                backHref = "home_caregiver.jsp";
            } else if ("Admin".equalsIgnoreCase(acc.getRole())) {
                roleLabel = "Quản trị viên";
                backHref = "home_admin.jsp";
            }
        %>

        <div class="card">
            <a href="<%= backHref %>" class="back-link">
                <i class="fa-solid fa-arrow-left"></i> Quay lại trang chính
            </a>

            <div class="card-header">
                <div class="avatar"><%= initial %></div>
                <div>
                    <h2 style="margin:0;"><%= fullName %></h2>
                    <p style="margin:4px 0 0; color:#64748b; font-size:14px;">
                        Vai trò: <b><%= roleLabel %></b>
                    </p>
                </div>
            </div>

            <form method="post" action="UpdateProfileServlet">
                <div class="info-row">
                    <span>Họ và tên</span>
                    <span>
                        <input type="text" name="fullName" value="<%= fullName %>" style="border:1px solid #e2e8f0;border-radius:8px;padding:6px 10px;">
                    </span>
                </div>
                <div class="info-row">
                    <span>Giới tính</span>
                    <span>
                        <select name="gender" style="border:1px solid #e2e8f0;border-radius:8px;padding:6px 10px;">
                            <option value="">Chưa chọn</option>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </span>
                </div>
                <div class="info-row">
                    <span>Năm sinh</span>
                    <span>
                        <input type="number" name="birthYear" min="1900" max="2100" style="width:90px;border:1px solid #e2e8f0;border-radius:8px;padding:6px 10px;">
                    </span>
                </div>
                <div class="info-row">
                    <span>Email đăng nhập</span>
                    <span><%= acc.getEmail() %></span>
                </div>
                <div class="info-row">
                    <span>Số điện thoại</span>
                    <span>
                        <input type="text" name="phoneNumber" value="<%= acc.getPhoneNumber() != null ? acc.getPhoneNumber() : "" %>" style="border:1px solid #e2e8f0;border-radius:8px;padding:6px 10px;">
                    </span>
                </div>
                <div class="info-row">
                    <span>Mã kết nối (đọc-only)</span>
                    <span><%= acc.getLinkKey() != null ? acc.getLinkKey() : "Chưa có mã" %></span>
                </div>

                <div style="text-align:right;margin-top:15px;">
                    <button type="submit" style="background:#0f766e;color:white;border:none;border-radius:999px;padding:8px 18px;cursor:pointer;">
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>

