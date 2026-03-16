<%@page pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@page import="model.Notification" %>
<%@page import="dal.NotificationDAO" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Date" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User headerAcc = (User) session.getAttribute("account");
    String uri = request.getRequestURI();
    String currentPage = uri.substring(uri.lastIndexOf("/") + 1);
    
    // --- LOGIC KIỂM TRA PREMIUM & THỜI HẠN ---
    boolean isPremium = false;
    long daysLeft = -1;
    if (headerAcc != null && headerAcc.isIsPremium()) {
        java.sql.Timestamp expiry = headerAcc.getPremiumExpiry();
        Date now = new Date();
        if (expiry != null && expiry.after(now)) {
            isPremium = true;
            // Tính số ngày còn lại
            long diff = expiry.getTime() - now.getTime();
            daysLeft = diff / (24 * 60 * 60 * 1000);
        }
    }

    // --- LOGIC THÔNG BÁO ---
    List<Notification> headerNotis = null;
    int unreadCount = 0;
    if (headerAcc != null) {
        NotificationDAO nDao = new NotificationDAO(); 
        headerNotis = nDao.getTop5Notifications(headerAcc.getUserID());
        unreadCount = nDao.getUnreadCount(headerAcc.getUserID());
    }
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
        position: relative;
    }
    .nav-link:hover, .nav-link.active { background: rgba(44, 82, 130, 0.08); }
    .nav-link.active { color: #1a365d; background: rgba(44, 82, 130, 0.15); font-weight: 800; }

    .lock-icon { font-size: 10px; margin-left: 4px; color: var(--text-muted); opacity: 0.7; }

    .header-actions { display: flex; align-items: center; gap: 10px; }
    .header-item-wrapper { position: relative; padding: 10px 5px; height: 100%; display: flex; align-items: center; }

    .noti-btn {
        width: 42px; height: 42px; display: flex; align-items: center; justify-content: center;
        background: var(--white); color: var(--primary-text); border-radius: 50%;
        border: 1px solid #c3dafe; cursor: pointer; transition: var(--transition);
        position: relative;
    }
    .noti-btn:hover { background: var(--primary-text); color: var(--white); }
    
    .noti-dot { 
        position: absolute; top: -2px; right: -2px; 
        background: var(--accent); color: white; 
        font-size: 10px; font-weight: 800;
        width: 18px; height: 18px; 
        border-radius: 50%; border: 2px solid var(--white);
        display: flex; align-items: center; justify-content: center;
    }

    .user-pill {
        display: flex; align-items: center; gap: 10px; background: var(--white);
        padding: 6px 14px; border-radius: 30px; border: 1px solid #c3dafe; 
        cursor: pointer; transition: var(--transition);
    }

    .dropdown-box { 
        position: absolute; top: 65px; right: 5px; width: 300px; background: var(--white); 
        border-radius: 18px; box-shadow: 0 15px 35px rgba(0,0,0,0.12); 
        display: none; flex-direction: column; overflow: hidden; 
        border: 1px solid #e2e8f0; z-index: 1002;
        animation: slideDown 0.3s ease;
    }
    .header-item-wrapper:hover .dropdown-box { display: flex; }

    .noti-header { padding: 15px 20px; border-bottom: 1px solid #f1f5f9; font-weight: 700; color: var(--primary-text); font-size: 15px; }
    .noti-scroll { max-height: 320px; overflow-y: auto; }
    .noti-item { padding: 15px 20px; font-size: 13px; color: var(--text-main); border-bottom: 1px solid #f8fafc; text-decoration: none; display: block; transition: 0.2s; }
    .noti-item:hover { background: #f0f7ff; }
    .noti-item.unread { background: #fdf4f4; border-left: 3px solid var(--accent); }

    .profile-info { padding: 20px; background: var(--primary-bg); display: flex; align-items: center; gap: 12px; }
    .dropdown-link { padding: 12px 20px; text-decoration: none; color: var(--text-main); font-size: 14px; display: flex; align-items: center; gap: 12px; transition: 0.2s; }
    .dropdown-link:hover { background: #f0f7ff; color: var(--primary-text); padding-left: 25px; }

    @keyframes slideDown { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
</style>

<header class="navbar">
    <div class="nav-left">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        <nav class="nav-menu">
            <a href="home_caregiver.jsp" class="nav-link <%= currentPage.equals("home_caregiver.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-house"></i> <span>Tổng quan</span>
            </a>
            <a href="<%= isPremium ? "my_relatives.jsp" : "membership.jsp?msg=lock" %>" class="nav-link">
                <i class="fa-solid fa-users"></i> <span>Gia đình</span>
                <% if (!isPremium) { %><i class="fa-solid fa-lock lock-icon"></i><% } %>
            </a>
            <a href="<%= isPremium ? "products" : "membership.jsp?msg=lock" %>" class="nav-link">
                <i class="fa-solid fa-cart-shopping"></i> <span>Cửa hàng</span>
                <% if (!isPremium) { %><i class="fa-solid fa-lock lock-icon"></i><% } %>
            </a>
            <a href="<%= isPremium ? "blog.jsp" : "membership.jsp?msg=lock" %>" class="nav-link">
                <i class="fa-solid fa-newspaper"></i> <span>Tin tức</span>
                <% if (!isPremium) { %><i class="fa-solid fa-lock lock-icon"></i><% } %>
            </a>
        </nav>
    </div>

    <div class="header-actions">
        <div style="background: var(--white); padding: 8px 15px; border-radius: 12px; font-size: 13px; font-weight: 700; color: #f39c12; border: 1px solid #ffeeba; cursor: pointer;" onclick="window.location.href='rewards'">
            <i class="fa-solid fa-star"></i> 
            <fmt:formatNumber value="${sessionScope.totalPoints != null ? sessionScope.totalPoints : 0}" type="number"/> pts
        </div>

        <div class="header-item-wrapper">
            <div class="noti-btn">
                <i class="fa-solid fa-bell"></i>
                <% if (unreadCount > 0) { %>
                    <div class="noti-dot"><%= unreadCount %></div>
                <% } %>
            </div>
            <div class="dropdown-box">
                <div class="noti-header">Thông báo mới</div>
                <div class="noti-scroll">
                    <% if (headerNotis != null && !headerNotis.isEmpty()) {
                        for (Notification n : headerNotis) { %>
                        <a href="notifications" class="noti-item <%= n.isRead() ? "" : "unread" %>">
                            <strong style="color: var(--primary-text);"><%= n.getTitle() %></strong>
                            <p style="margin: 4px 0 0 0; line-height: 1.4;"><%= n.getMessage() %></p>
                            <small style="display:block; color:#94a3b8; margin-top:6px;">
                                <i class="fa-regular fa-clock"></i> 
                                <%= new java.text.SimpleDateFormat("dd/MM HH:mm").format(n.getCreatedAt()) %>
                            </small>
                        </a>
                    <% } } else { %>
                        <div style="padding: 30px 20px; text-align: center; color: var(--text-muted); font-size: 13px;">
                            <i class="fa-solid fa-envelope-open" style="font-size: 24px; display: block; margin-bottom: 10px; opacity: 0.3;"></i>
                            Chưa có thông báo nào
                        </div>
                    <% } %>
                </div>
                <a href="notifications" style="text-align:center; padding: 12px; font-size: 13px; font-weight: 700; color: var(--primary-text); background: #f8fafc; text-decoration: none; border-top: 1px solid #f1f5f9;">Xem tất cả</a>
            </div>
        </div>

        <div class="header-item-wrapper">
            <div class="user-pill" onclick="window.location.href='profile.jsp'">
                <span style="font-weight: 700; font-size: 13px; color: var(--primary-text);"><%= (headerAcc != null) ? headerAcc.getFullName() : "Khách" %></span>
                <div style="width: 30px; height: 30px; border-radius: 50%; background: var(--primary-text); color: white; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-user"></i></div>
            </div>
            <div class="dropdown-box" style="width: 280px;">
                <div class="profile-info">
                    <div style="width: 45px; height: 45px; border-radius: 50%; background: var(--white); color: var(--primary-text); display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 800;">
                        <%= (headerAcc != null && !headerAcc.getFullName().isEmpty()) ? headerAcc.getFullName().substring(0,1).toUpperCase() : "?" %>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: var(--primary-text); font-size: 14px;"><%= (headerAcc != null) ? headerAcc.getFullName() : "Khách" %></div>
                        <div style="font-size: 11px; color: var(--text-muted); line-height: 1.4;">
                            <%= isPremium ? "Hội viên Premium ✨" : "Hội viên thường" %>
                            <% if (isPremium && headerAcc != null && headerAcc.getPremiumExpiry() != null) { %>
                                <div style="color: #16a34a; font-weight: 700; margin-top: 2px;">
                                    Hạn: <fmt:formatDate value="<%= headerAcc.getPremiumExpiry() %>" pattern="dd/MM/yyyy"/>
                                    <% if (daysLeft >= 0) { %>
                                        <span style="color: #e67e22; font-size: 10px;">(Còn <%= daysLeft %> ngày)</span>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <div style="padding: 10px 0;">
                    <a href="profile.jsp" class="dropdown-link"><i class="fa-solid fa-address-card" style="color: #6366f1;"></i> Hồ sơ cá nhân</a>
                    <a href="logout" class="dropdown-link" style="color: var(--accent); border-top: 1px solid #f1f5f9;"><i class="fa-solid fa-power-off"></i> Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</header>