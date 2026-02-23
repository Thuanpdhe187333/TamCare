<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Người thân của tôi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Tận dụng lại CSS từ Dashboard của bạn */
        :root { --primary: #0066cc; --primary-light: #e6f0ff; --text-muted: #64748b; --white: #ffffff; }
        body { background-color: #f8fafc; font-family: 'Segoe UI', sans-serif; display: flex; margin: 0; }
        
        /* Sidebar Styles (Giữ nguyên như trang chủ) */
        .sidebar { width: 300px; background: var(--white); border-right: 2px solid #edf2f7; padding: 40px 24px; position: fixed; height: 100vh; }
        .sidebar-logo { font-size: 28px; font-weight: 700; color: var(--primary); text-decoration: none; display: flex; align-items: center; gap: 12px; margin-bottom: 50px; }
        .menu-link { display: flex; align-items: center; gap: 16px; padding: 16px 20px; color: var(--text-muted); text-decoration: none; border-radius: 16px; margin-bottom: 8px; font-weight: 500; }
        .menu-link.active { background: var(--primary-light); color: var(--primary); }

        /* Content Area */
        .main-content { margin-left: 300px; padding: 40px 60px; width: calc(100% - 300px); }
        .page-title { font-size: 32px; color: var(--primary); margin-bottom: 30px; }

        /* Card Layout cho Người thân */
        .relative-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 25px; }
        .relative-card { background: white; border-radius: 24px; padding: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; transition: 0.3s; }
        .relative-card:hover { transform: translateY(-5px); border-color: var(--primary); }
        
        .card-header { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; }
        .user-avatar { width: 60px; height: 60px; background: var(--primary-light); color: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; }
        
        .user-info h3 { margin: 0; font-size: 20px; color: #1e293b; }
        .user-info p { margin: 5px 0 0; font-size: 14px; color: var(--text-muted); }

        .card-body { border-top: 1px solid #f1f5f9; padding-top: 15px; }
        .info-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 15px; }
        .info-label { color: var(--text-muted); }
        .info-value { font-weight: 600; color: #334155; }

        .btn-view-detail { display: block; width: 100%; text-align: center; padding: 12px; background: var(--primary); color: white; text-decoration: none; border-radius: 12px; font-weight: 600; margin-top: 15px; }
        
        .empty-state { text-align: center; padding: 100px 0; color: var(--text-muted); }
        .empty-state i { font-size: 60px; margin-bottom: 20px; opacity: 0.5; }
    </style>
</head>
<body>
    <% 
        User acc = (User) session.getAttribute("account"); 
        if(acc == null) { response.sendRedirect("login.jsp"); return; } 
    %>

    <aside class="sidebar">
        <a href="index.jsp" class="sidebar-logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        <nav class="sidebar-menu">
            <a href="home" class="menu-link"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
            <a href="view-elderly-list" class="menu-link active"><i class="fa-solid fa-users"></i> Người thân của tôi</a>
            <a href="#" class="menu-link"><i class="fa-solid fa-capsules"></i> Lịch uống thuốc</a>
            <a href="#" class="menu-link"><i class="fa-solid fa-bell"></i> Cảnh báo khẩn</a>
        </nav>
        <a href="logout" class="menu-link" style="color: #e11d48; margin-top: auto;"><i class="fa-solid fa-sign-out-alt"></i> Đăng xuất</a>
    </aside>

    <main class="main-content">
        <h1 class="page-title">Danh sách người thân</h1>

        <div class="relative-grid">
            <% 
                List<User> list = (List<User>) request.getAttribute("elderlyList");
                if (list != null && !list.isEmpty()) {
                    for (User u : list) {
                        String initial = u.getFullName().substring(0, 1).toUpperCase();
            %>
            <div class="relative-card">
                <div class="card-header">
                    <div class="user-avatar"><%= initial %></div>
                    <div class="user-info">
                        <h3><%= u.getFullName() %></h3>
                        <p>ID: #TC-<%= u.getUserID() %></p>
                    </div>
                </div>
                <div class="card-body">
                    <div class="info-item">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= u.getEmail() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Số điện thoại:</span>
                        <span class="info-value"><%= u.getPhoneNumber() %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Vai trò:</span>
                        <span class="info-value" style="color: var(--primary);">Người cao tuổi</span>
                    </div>
                    <a href="view-elderly-detail?id=<%= u.getUserID() %>" class="btn-view-detail">Xem hồ sơ sức khỏe</a>
                </div>
            </div>
            <% 
                    }
                } else { 
            %>
            <div class="empty-state">
                <i class="fa-solid fa-user-slash"></i>
                <h2>Chưa có người thân nào</h2>
                <p>Bạn chưa được liên kết với hồ sơ người cao tuổi nào.</p>
                <a href="#" class="btn-view-detail" style="width: auto; display: inline-block; padding: 12px 30px;">Yêu cầu liên kết mới</a>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>