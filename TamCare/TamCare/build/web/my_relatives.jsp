<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, java.util.List"%>
<%@page import="dal.UserDAO"%>

<%
    User acc = (User) session.getAttribute("account");
    if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    String msg = null;
    String msgType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String linkKey = request.getParameter("linkKey");
        if (linkKey != null && !linkKey.trim().isEmpty()) {
            Integer elderlyId = dao.getElderlyIdByLinkKey(linkKey.trim());
            if (elderlyId == null) {
                msg = "Mã kết nối không tồn tại hoặc không phải tài khoản Ông/Bà!";
                msgType = "error";
            } else {
                boolean ok = dao.linkCaregiverToElderly_Relationship(acc.getUserID(), elderlyId);
                if (ok) {
                    msg = "✅ Liên kết thành công!";
                    msgType = "success";
                } else {
                    msg = "❌ Liên kết thất bại hoặc đã tồn tại!";
                    msgType = "error";
                }
            }
        }
    }

    List<User> elderlyList = dao.getLinkedElderlyList_ByRelationship(acc.getUserID());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Người thân của tôi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080;
            --primary-dark: #006666;
            --primary-light: #e6f2f2;
            --white: #ffffff;
            --text-muted: #64748b;
            --bg-body: #f1f5f9;
            --accent: #ef4444;
            --bonus-gold: #f39c12;
            --transition: all 0.3s ease;
            --sidebar-width: 280px;
        }

        body { background-color: var(--bg-body); margin: 0; font-family: 'Lexend', sans-serif; display: flex; flex-direction: column; min-height: 100vh; }

        /* --- NAVBAR --- */
        .navbar {
            height: 70px; background: var(--primary);
            display: flex; justify-content: space-between; align-items: center;
            padding: 0 40px; position: fixed; top: 0; width: 100%;
            z-index: 1001; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            box-sizing: border-box; color: var(--white);
        }
        .navbar .logo { font-size: 26px; font-weight: 800; color: var(--white); text-decoration: none; display: flex; align-items: center; gap: 10px; }

        /* --- HEADER ACTIONS (GÓC PHẢI) --- */
        .header-actions { display: flex; align-items: center; gap: 15px; height: 100%; }

        .header-item-wrapper { 
            position: relative; 
            height: 100%; 
            display: flex; 
            align-items: center; 
            padding: 0 5px;
        }

        .icon-btn { 
            background: rgba(255, 255, 255, 0.2); color: white; border: none; 
            width: 40px; height: 40px; border-radius: 50%; cursor: pointer; 
            display: flex; align-items: center; justify-content: center; text-decoration: none; 
        }

        .user-pill {
            display: flex; align-items: center; gap: 10px; background: rgba(255, 255, 255, 0.1);
            padding: 5px 12px; border-radius: 30px; cursor: pointer; transition: 0.3s;
        }

        /* LỚP ĐỆM ĐỂ GIỮ CHUỘT KHÔNG BỊ MẤT BOX */
        .dropdown-menu {
            position: absolute; 
            top: 100%; /* Sát mép dưới của navbar */
            right: 0; 
            width: 240px;
            background: white; 
            border-radius: 0 0 12px 12px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            display: none; 
            flex-direction: column; 
            overflow: hidden; 
            border: 1px solid #e2e8f0; 
            z-index: 1002;
            padding-top: 5px; /* Tạo cảm giác liền mạch */
        }

        .header-item-wrapper:hover .dropdown-menu { display: flex; }
        /* Thêm vùng hover giả để không bị ngắt quãng */
        .header-item-wrapper::after {
            content: ''; position: absolute; top: 70px; right: 0; width: 100%; height: 10px;
        }

        .dropdown-link { padding: 12px 20px; text-decoration: none; color: #475569; font-size: 14px; display: flex; align-items: center; gap: 10px; transition: 0.2s; }
        .dropdown-link:hover { background: var(--primary-light); color: var(--primary); }

        /* --- SIDEBAR --- */
        .sidebar { width: var(--sidebar-width); background: var(--white); border-right: 1px solid #e2e8f0; padding: 100px 20px 30px; display: flex; flex-direction: column; position: fixed; height: 100vh; box-sizing: border-box; z-index: 1000; }
        .menu-link { display: flex; align-items: center; gap: 12px; padding: 14px 18px; color: var(--text-muted); text-decoration: none; border-radius: 12px; margin-bottom: 5px; font-weight: 500; transition: var(--transition); }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); }
        .menu-link.active { font-weight: 700; }

        .bonus-card { background: linear-gradient(135deg, #f1c40f, var(--bonus-gold)); padding: 20px; border-radius: 20px; color: var(--white); margin-top: auto; box-shadow: 0 4px 15px rgba(243, 156, 18, 0.3); }

        /* --- CONTENT --- */
        .main-content { margin-left: var(--sidebar-width); margin-top: 70px; padding: 40px 50px; flex: 1; }
        .link-form-card { background: var(--white); border-radius: 24px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); margin-bottom: 30px; display: flex; gap: 15px; align-items: center; }
        .input-link { flex: 1; padding: 14px 20px; border-radius: 14px; border: 1px solid #e2e8f0; outline: none; font-size: 15px; }
        .btn-submit { background: var(--primary); color: white; border: none; padding: 14px 25px; border-radius: 14px; font-weight: 600; cursor: pointer; }

        .relative-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 25px; }
        .relative-card { background: white; border-radius: 24px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); border: 1px solid transparent; }
        .initial-avatar { width: 55px; height: 55px; border-radius: 50%; background: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 800; }
        .btn-detail { display: block; width: 100%; text-align: center; padding: 12px; background: var(--primary-light); color: var(--primary); text-decoration: none; border-radius: 12px; font-weight: 700; margin-top: 15px; }
    </style>
</head>
<body>

    <header class="navbar">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        
        <div class="header-actions">
            <div class="header-item-wrapper">
                <a href="notifications.jsp" class="icon-btn"><i class="fa-solid fa-bell"></i></a>
                <div class="dropdown-menu">
                    <div style="padding:15px; border-bottom:1px solid #eee; font-weight:700; color:#333;">Thông báo mới</div>
                    <a href="notifications.jsp" class="dropdown-link">Bạn có thông báo mới từ hệ thống</a>
                </div>
            </div>

            <div class="header-item-wrapper">
                <div class="user-pill" onclick="window.location.href='profile_caregiver.jsp'">
                    <div style="width:30px; height:30px; border-radius:50%; background:white; color:var(--primary); display:flex; align-items:center; justify-content:center;">
                        <i class="fa-solid fa-user-tie"></i>
                    </div>
                    <span style="font-size: 14px; font-weight: 600;"><%= acc.getFullName() %></span>
                </div>
                <div class="dropdown-menu">
                    <a href="profile_caregiver.jsp" class="dropdown-link"><i class="fa-solid fa-id-card"></i> Hồ sơ cá nhân</a>
                    <a href="change_password.jsp" class="dropdown-link"><i class="fa-solid fa-key"></i> Đổi mật khẩu</a>
                    <a href="settings.jsp" class="dropdown-link"><i class="fa-solid fa-sliders"></i> Cài đặt</a>
                    <hr style="border:0; border-top:1px solid #eee; margin:0;">
                    <a href="logout" class="dropdown-link" style="color:var(--accent);"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
                </div>
            </div>
        </div>
    </header>

    <aside class="sidebar">
        <nav style="flex: 1;">
            <a href="home_caregiver.jsp" class="menu-link"><i class="fa-solid fa-house"></i> Tổng quan</a>
            <a href="my_relatives.jsp" class="menu-link active"><i class="fa-solid fa-users"></i> Hồ sơ gia đình</a>
            <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
            <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
            <a href="about.jsp" class="menu-link"><i class="fa-solid fa-circle-info"></i> About us</a>
            <a href="profile_caregiver.jsp" class="menu-link"><i class="fa-solid fa-user-gear"></i> Trang cá nhân</a>
        </nav>

        <div class="bonus-card">
            <small style="opacity: 0.9;">Điểm thưởng tích lũy</small>
            <h2 style="margin: 5px 0 0 0; font-size: 24px;">1.250 <span style="font-size: 14px;">pts</span></h2>
        </div>
        <a href="logout" class="menu-link" style="color: var(--accent); margin-top: 20px;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
    </aside>

    <main class="main-content">
        <h1 style="font-size: 28px; color: #1e293b; margin-bottom: 30px;">Quản lý người thân</h1>

        <div class="link-form-card">
            <form action="" method="post" style="display: contents;">
                <input name="linkKey" class="input-link" placeholder="Nhập mã kết nối của Ông/Bà (Ví dụ: TC123456)" required>
                <button type="submit" class="btn-submit">Liên kết hồ sơ</button>
            </form>
        </div>

        <% if (msg != null) { %>
            <div style="padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; font-size: 14px; 
                 <%= "error".equals(msgType) ? "background:#fee2e2; color:#ef4444;" : "background:#f0fdf4; color:#16a34a;" %>">
                <%= msg %>
            </div>
        <% } %>

        <div class="relative-grid">
            <% 
                if (elderlyList != null && !elderlyList.isEmpty()) {
                    for (User u : elderlyList) {
                        String initial = (u.getFullName() != null && !u.getFullName().isEmpty()) ? u.getFullName().substring(0, 1).toUpperCase() : "U";
            %>
            <div class="relative-card">
                <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
                    <div class="initial-avatar"><%= initial %></div>
                    <div>
                        <h3 style="margin: 0; font-size: 18px; color: #1e293b;"><%= u.getFullName() %></h3>
                        <p style="margin: 4px 0 0; font-size: 13px; color: var(--text-muted);">ID: #<%= (u.getLinkKey() != null) ? u.getLinkKey() : u.getUserID() %></p>
                    </div>
                </div>
                <div style="border-top: 1px solid #f1f5f9; padding-top: 15px;">
                    <a href="elderly_detail.jsp?id=<%= u.getUserID() %>" class="btn-detail">Xem chi tiết sức khỏe</a>
                </div>
            </div>
            <% } } %>
        </div>
    </main>
</body>
</html>