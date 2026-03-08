<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - TamCare</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        
        /* Sidebar (Tận dụng lại style của home_caregiver) */
        .sidebar { width: 250px; background-color: #2c3e50; color: white; height: 100vh; padding: 20px; position: fixed; }
        .sidebar h2 { color: #3498db; text-align: center; }
        .menu a { display: block; padding: 15px; color: #ecf0f1; text-decoration: none; border-bottom: 1px solid #34495e; }
        .menu a:hover, .menu a.active { background-color: #34495e; border-left: 4px solid #3498db; }
        
        .main { margin-left: 290px; padding: 30px; width: calc(100% - 290px); }
        
        /* Profile Layout */
        .profile-header { background: white; padding: 30px; border-radius: 15px; display: flex; align-items: center; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .avatar-circle { width: 100px; height: 100px; background-color: #3498db; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; font-weight: bold; margin-right: 25px; }
        
        .user-meta h2 { margin: 0; color: #2c3e50; }
        .user-meta p { margin: 5px 0; color: #7f8c8d; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-card { background: white; padding: 25px; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .info-card h3 { border-bottom: 2px solid #f1f2f6; padding-bottom: 10px; margin-top: 0; color: #34495e; }
        
        .detail-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed #eee; }
        .detail-row span:first-child { font-weight: bold; color: #7f8c8d; }
        .detail-row span:last-child { color: #2c3e50; }

        .btn-edit { background-color: #3498db; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; float: right; }
    </style>
</head>
<body>
    <%
        User u = (User) request.getAttribute("user");
        if(u == null) { response.sendRedirect("login"); return; }
        
        // Lấy ký tự đầu để làm avatar giả
        String initial = u.getFullName().substring(0, 1).toUpperCase();
    %>

    <div class="sidebar">
        <h2>👨‍⚕️ TamCare</h2>
        <div class="menu">
            <a href="home_caregiver.jsp">📊 Tổng quan</a>
            <a href="profile" class="active">👤 Hồ sơ cá nhân</a>
            <a href="#">👥 Người thân theo dõi</a>
            <a href="logout" style="color: #e74c3c;">🚪 Đăng xuất</a>
        </div>
    </div>

    <div class="main">
        <div class="profile-header">
            <div class="avatar-circle"><%= initial %></div>
            <div class="user-meta">
                <h2><%= u.getFullName() %></h2>
                <p>Vai trò: <b>Người chăm sóc (Caregiver)</b></p>
                <p>Thành viên từ: <%= u.getDateCreated() %></p>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>Thông tin tài khoản</h3>
                <div class="detail-row">
                    <span>Email:</span>
                    <span><%= u.getEmail() %></span>
                </div>
                <div class="detail-row">
                    <span>Mã người dùng:</span>
                    <span>#TC-<%= u.getUserID() %></span>
                </div>
                <div class="detail-row">
                    <span>Trạng thái:</span>
                    <span style="color: #27ae60;">● Đang hoạt động</span>
                </div>
                <button class="btn-edit" onclick="alert('Tính năng cập nhật đang phát triển!')">Chỉnh sửa thông tin</button>
            </div>

            <div class="info-card">
                <h3>Thông tin liên hệ</h3>
                <div class="detail-row">
                    <span>Số điện thoại:</span>
                    <span><%= u.getPhoneNumber() %></span>
                </div>
                <div class="detail-row">
                    <span>Địa chỉ:</span>
                    <span>Chưa cập nhật</span>
                </div>
                <div class="detail-row">
                    <span>Zalo ID:</span>
                    <span>Liên kết qua SĐT</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>