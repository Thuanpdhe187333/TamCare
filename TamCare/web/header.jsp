<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%
    User acc = (User) session.getAttribute("account");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080; --primary-dark: #006666; --primary-light: #e6f2f2;
            --white: #ffffff; --text-main: #1e293b; --text-muted: #64748b;
            --bg-body: #f1f5f9; --accent: #ef4444; --bonus-gold: #f39c12;
            --sidebar-width: 280px;
        }

        body {
            background-color: var(--bg-body); margin: 0; font-family: 'Lexend', sans-serif;
            display: flex; flex-direction: column; min-height: 100vh; color: var(--text-main);
        }

        /* --- NAVBAR --- */
        .navbar {
            height: 70px; background: var(--primary); display: flex;
            justify-content: space-between; align-items: center; padding: 0 40px;
            position: fixed; top: 0; width: 100%; z-index: 1001;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); box-sizing: border-box; color: var(--white);
        }
        .navbar .logo { font-size: 26px; font-weight: 800; color: var(--white); text-decoration: none; display: flex; align-items: center; gap: 12px; }

        .header-actions { display: flex; align-items: center; gap: 20px; height: 100%; }

        /* HOVER DROPDOWN */
        .header-item-wrapper { position: relative; height: 100%; display: flex; align-items: center; cursor: pointer; padding: 0 10px; }
        .header-item-wrapper::after { content: ''; position: absolute; top: 100%; left: 0; width: 100%; height: 15px; }
        .dropdown-menu { position: absolute; top: 70px; right: 0; width: 280px; background: white; border-radius: 0 0 16px 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); display: none; flex-direction: column; overflow: hidden; border: 1px solid #e2e8f0; z-index: 1002; padding: 5px 0; }
        .header-item-wrapper:hover .dropdown-menu { display: flex; }
        .dropdown-link { padding: 12px 20px; text-decoration: none; color: var(--text-main); font-size: 14px; display: flex; align-items: center; gap: 10px; transition: 0.2s; }
        .dropdown-link:hover { background: var(--primary-light); color: var(--primary); }

        /* --- LAYOUT CHÍNH --- */
        .main-wrapper { display: flex; flex: 1; margin-top: 70px; }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width); background: var(--white);
            border-right: 2px solid #edf2f7; padding: 30px 24px;
            display: flex; flex-direction: column; position: fixed; 
            height: calc(100vh - 70px); box-sizing: border-box; z-index: 1000;
        }
        .menu-link { display: flex; align-items: center; gap: 16px; padding: 14px 20px; color: var(--text-muted); text-decoration: none; border-radius: 16px; margin-bottom: 8px; font-weight: 500; transition: var(--transition); }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); }
        .menu-link.active { font-weight: 700; }

        .bonus-card { background: linear-gradient(135deg, #f1c40f, var(--bonus-gold)); padding: 24px; border-radius: 24px; color: var(--white); margin-top: auto; margin-bottom: 20px; box-shadow: 0 8px 20px rgba(243, 156, 18, 0.2); }

        /* --- CONTENT AREA --- */
        .main-content {
            margin-left: var(--sidebar-width); /* Đẩy nội dung né Sidebar */
            padding: 40px 60px;
            width: calc(100% - var(--sidebar-width));
            box-sizing: border-box;
            flex: 1;
        }

        /* Thống kê & Bảng */
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 30px; border-radius: 24px; box-shadow: var(--shadow-soft); display: flex; align-items: center; gap: 20px; }
        .table-section { background: var(--white); border-radius: 24px; padding: 35px; box-shadow: var(--shadow-soft); }
        table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
        td { padding: 22px 20px; background: #fcfcfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        td:first-child { border-left: 1px solid #f1f5f9; border-radius: 16px 0 0 16px; }
        td:last-child { border-right: 1px solid #f1f5f9; border-radius: 0 16px 16px 0; }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        <div class="header-actions">
            <div class="header-item-wrapper">
                <div style="position: relative;">
                    <i class="fa-solid fa-bell fa-lg"></i>
                    <span style="position: absolute; top: -10px; right: -10px; background: var(--accent); color: white; font-size: 10px; padding: 2px 6px; border-radius: 10px; border: 2px solid var(--primary);">3</span>
                </div>
                <div class="dropdown-menu">
                    <div style="padding: 15px; font-weight: 700; color: #333; border-bottom: 1px solid #eee;">Thông báo mới</div>
                    <a href="#" class="dropdown-link">Ông Nguyễn Văn A vừa cập nhật sức khỏe</a>
                </div>
            </div>
            <div class="header-item-wrapper">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span style="font-weight: 700;"><%= (acc != null) ? acc.getFullName() : "Khách" %></span>
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-user-tie"></i></div>
                </div>
                <div class="dropdown-menu" style="width: 200px;">
                    <a href="profile_caregiver.jsp" class="dropdown-link">Hồ sơ</a>
                    <a href="logout" class="dropdown-link" style="color: var(--accent);">Đăng xuất</a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-wrapper"> <aside class="sidebar">
            <nav style="flex: 1;">
                <a href="home_caregiver.jsp" class="menu-link active"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
                <a href="my_relatives.jsp" class="menu-link"><i class="fa-solid fa-users"></i> Hồ sơ gia đình</a>
                <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng</a>
                <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog</a>
            </nav>
            <div class="bonus-card">
                <small>Điểm tích lũy</small>
                <h2 style="margin: 5px 0 0 0;">1.250 pts</h2>
            </div>
            <a href="logout" class="menu-link" style="color: var(--accent); margin-top: 20px;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </aside>