<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%
    User headerAcc = (User) session.getAttribute("account");
    // Lấy tên file hiện tại để set class active cho menu
    String uri = request.getRequestURI();
    String currentPage = uri.substring(uri.lastIndexOf("/") + 1);
%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-bg: #e0effa; 
        --primary-text: #2c5282;
        --white: #ffffff; 
        --text-main: #1e293b; 
        --text-muted: #64748b;
        --accent: #ef4444; 
        --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .navbar {
        height: 75px; background: var(--primary-bg); display: flex;
        justify-content: space-between; align-items: center; padding: 0 40px;
        position: fixed; top: 0; width: 100%; z-index: 1001;
        box-shadow: 0 2px 15px rgba(0,0,0,0.05); box-sizing: border-box;
    }

    .nav-left { display: flex; align-items: center; gap: 30px; }
    .navbar .logo { font-size: 24px; font-weight: 800; color: var(--primary-text); text-decoration: none; display: flex; align-items: center; gap: 10px; }
    
    .nav-menu { display: flex; align-items: center; gap: 5px; }
    .nav-link { 
        display: flex; align-items: center; gap: 8px; padding: 10px 16px; 
        color: var(--primary-text); text-decoration: none; border-radius: 12px; 
        font-size: 14px; font-weight: 600; transition: var(--transition);
    }
    .nav-link:hover, .nav-link.active { background: rgba(44, 82, 130, 0.08); }
    .nav-link.active { color: #1a365d; background: rgba(44, 82, 130, 0.15); }

    .header-actions { display: flex; align-items: center; gap: 10px; }
    .header-item-wrapper { position: relative; padding: 10px 5px; }

    .noti-btn {
        width: 42px; height: 42px; display: flex; align-items: center; justify-content: center;
        background: var(--white); color: var(--primary-text); border-radius: 50%;
        border: 1px solid #c3dafe; cursor: pointer; transition: var(--transition);
        position: relative;
    }
    .noti-btn:hover { background: var(--primary-text); color: var(--white); }
    .noti-dot { 
        position: absolute; top: 10px; right: 10px; width: 8px; height: 8px; 
        background: var(--accent); border-radius: 50%; border: 2px solid var(--white); 
    }

    .user-pill {
        display: flex; align-items: center; gap: 10px; background: var(--white);
        padding: 6px 14px; border-radius: 30px; border: 1px solid #c3dafe; 
        cursor: pointer; transition: var(--transition);
    }
    .user-pill:hover { border-color: var(--primary-text); box-shadow: 0 4px 12px rgba(44, 82, 130, 0.1); }

    .dropdown-box { 
        position: absolute; top: 65px; right: 5px; width: 260px; background: var(--white); 
        border-radius: 18px; box-shadow: 0 15px 35px rgba(0,0,0,0.12); 
        display: none; flex-direction: column; overflow: hidden; 
        border: 1px solid #e2e8f0; z-index: 1002;
        animation: slideDown 0.3s ease;
    }
    
    .header-item-wrapper::after {
        content: ''; position: absolute; top: 40px; left: 0; width: 100%; height: 30px;
    }

    .header-item-wrapper:hover .dropdown-box { display: flex; }

    .noti-header { padding: 15px 20px; border-bottom: 1px solid #f1f5f9; font-weight: 700; color: var(--primary-text); font-size: 15px; }
    .noti-item { padding: 12px 20px; font-size: 13px; color: var(--text-main); border-bottom: 1px solid #f8fafc; text-decoration: none; display: block; }
    .noti-item:hover { background: #f0f7ff; }

    .profile-info { padding: 20px; background: var(--primary-bg); display: flex; align-items: center; gap: 12px; }
    .dropdown-link { 
        padding: 12px 20px; text-decoration: none; color: var(--text-main); 
        font-size: 14px; display: flex; align-items: center; gap: 12px; transition: 0.2s; 
    }
    .dropdown-link:hover { background: #f0f7ff; color: var(--primary-text); padding-left: 25px; }

    @keyframes slideDown {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<header class="navbar">
    <div class="nav-left">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        <nav class="nav-menu">
            <a href="home_caregiver.jsp" class="nav-link <%= currentPage.equals("home_caregiver.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-house"></i> <span>Tổng quan</span>
            </a>
            <a href="my_relatives.jsp" class="nav-link <%= currentPage.equals("my_relatives.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-users"></i> <span>Hồ sơ gia đình</span>
            </a>
            <a href="products" class="nav-link <%= currentPage.contains("products") ? "active" : "" %>">
                <i class="fa-solid fa-cart-shopping"></i> <span>Cửa hàng</span>
            </a>
            <a href="blog.jsp" class="nav-link <%= currentPage.equals("blog.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-newspaper"></i> <span>Tin tức</span>
            </a>
            <a href="about.jsp" class="nav-link <%= currentPage.equals("about.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-circle-info"></i> <span>Về chúng tôi</span>
            </a>
        </nav>
    </div>

    <div class="header-actions">
<div style="background: var(--white); padding: 8px 15px; border-radius: 12px; font-size: 13px; font-weight: 700; color: #f39c12; border: 1px solid #ffeeba; cursor: pointer;" 
         onclick="window.location.href='rewards.jsp'">
        <i class="fa-solid fa-star"></i> 
        <%-- Hiển thị điểm động nếu có trong session, không thì hiện tạm 0 --%>
        ${sessionScope.totalPoints != null ? sessionScope.totalPoints : "0"} pts
    </div>

        <div class="header-item-wrapper">
            <div class="noti-btn">
                <i class="fa-solid fa-bell"></i>
                <div class="noti-dot"></div>
            </div>
            <div class="dropdown-box" style="width: 300px;">
                <div class="noti-header">Thông báo mới</div>
                <a href="#" class="noti-item">
                    <strong>Sức khỏe:</strong> Cụ Thuận đã điểm danh sáng nay.
                    <small style="display:block; color:#94a3b8; margin-top:4px;">10 phút trước</small>
                </a>
                <a href="notifications.jsp" style="text-align:center; padding: 12px; font-size: 13px; font-weight: 600; color: var(--primary-text); background: #f8fafc; text-decoration: none;">Xem tất cả</a>
            </div>
        </div>

        <div class="header-item-wrapper">
            <div class="user-pill" onclick="window.location.href='profile.jsp'">
                <span style="font-weight: 700; font-size: 13px; color: var(--primary-text);">
                    <%= (headerAcc != null) ? headerAcc.getFullName() : "Khách" %>
                </span>
                <div style="width: 30px; height: 30px; border-radius: 50%; background: var(--primary-text); color: white; display: flex; align-items: center; justify-content: center; font-size: 12px;">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
            <div class="dropdown-box">
                <div class="profile-info">
                    <div style="width: 45px; height: 45px; border-radius: 50%; background: var(--white); color: var(--primary-text); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 800;">
                        <%= (headerAcc != null && !headerAcc.getFullName().isEmpty()) ? headerAcc.getFullName().substring(0,1).toUpperCase() : "K" %>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: var(--primary-text); font-size: 14px;"><%= (headerAcc != null) ? headerAcc.getFullName() : "Khách" %></div>
                        <div style="font-size: 11px; color: var(--text-muted);">Người chăm sóc</div>
                    </div>
                </div>
                <div style="padding: 10px 0;">
                    <a href="profile.jsp" class="dropdown-link"><i class="fa-solid fa-address-card" style="color: #6366f1;"></i> Hồ sơ cá nhân</a>
                    <a href="profile.jsp" class="dropdown-link"><i class="fa-solid fa-shield-halved" style="color: #10b981;"></i> Đổi mật khẩu</a>
                    <a href="profile.jsp" class="dropdown-link"><i class="fa-solid fa-gear" style="color: #64748b;"></i> Cài đặt</a>
                    <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 8px 0;">
                    <a href="logout" class="dropdown-link" style="color: var(--accent);"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</header>