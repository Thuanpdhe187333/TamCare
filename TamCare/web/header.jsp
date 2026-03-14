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
            --transition: all 0.3s ease; --sidebar-width: 280px;
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

        /* HOVER DROPDOWN */
        .header-actions { display: flex; align-items: center; gap: 20px; height: 100%; }
        .header-item-wrapper { position: relative; height: 100%; display: flex; align-items: center; cursor: pointer; padding: 0 10px; }
        .header-item-wrapper::after { content: ''; position: absolute; top: 100%; left: 0; width: 100%; height: 15px; }
        .dropdown-menu { position: absolute; top: 70px; right: 0; width: 250px; background: white; border-radius: 0 0 16px 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); display: none; flex-direction: column; border: 1px solid #e2e8f0; z-index: 1002; padding: 5px 0; color: var(--text-main); }
        .header-item-wrapper:hover .dropdown-menu { display: flex; }
        .dropdown-link { padding: 12px 20px; text-decoration: none; color: var(--text-main); font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .dropdown-link:hover { background: var(--primary-light); color: var(--primary); }

        /* --- MAIN WRAPPER --- */
        .main-wrapper { display: flex; flex: 1; margin-top: 70px; width: 100%; }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width); background: var(--white);
            border-right: 2px solid #edf2f7; padding: 30px 24px;
            display: flex; flex-direction: column; position: fixed; 
            height: calc(100vh - 70px); box-sizing: border-box; z-index: 1000;
        }
        .menu-link { display: flex; align-items: center; gap: 16px; padding: 14px 20px; color: var(--text-muted); text-decoration: none; border-radius: 16px; margin-bottom: 8px; font-weight: 500; }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); font-weight: 700; }

        /* Bonus Card ở cuối Sidebar */
        .bonus-card { background: linear-gradient(135deg, #f1c40f, var(--bonus-gold)); padding: 24px; border-radius: 24px; color: var(--white); margin-top: auto; box-shadow: 0 8px 20px rgba(243, 156, 18, 0.2); }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: var(--sidebar-width); padding: 40px 60px; box-sizing: border-box; flex: 1; }
        
        /* Dashboard Components */
        .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 30px; border-radius: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; }
        .stat-icon { width: 60px; height: 60px; border-radius: 20px; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        .table-section { background: var(--white); border-radius: 35px; padding: 40px; box-shadow: 0 4px 25px rgba(0,0,0,0.03); }
        table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        td { padding: 20px; background: #fcfcfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        td:first-child { border-left: 1px solid #f1f5f9; border-radius: 20px 0 0 20px; }
        td:last-child { border-right: 1px solid #f1f5f9; border-radius: 0 20px 20px 0; }
        
        .animate-up { animation: fadeInUp 0.7s ease both; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-hand-holding-heart"></i> TamCare</a>
        <div class="header-actions">
            <div class="header-item-wrapper">
                <i class="fa-solid fa-bell fa-lg"></i>
                <div class="dropdown-menu" style="width: 300px; padding: 15px;">Không có thông báo mới</div>
            </div>
            <div class="header-item-wrapper">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div style="text-align: right;"><span style="font-weight: 700; display: block;"><%= (acc != null) ? acc.getFullName() : "Khách" %></span><small>Người chăm sóc</small></div>
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-user"></i></div>
                </div>
                <div class="dropdown-menu" style="width: 200px;">
                    <a href="profile_caregiver.jsp" class="dropdown-link">Hồ sơ cá nhân</a>
                    <a href="logout" class="dropdown-link" style="color: var(--accent); border-top: 1px solid #eee;">Đăng xuất</a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-wrapper">
        <aside class="sidebar">
            <nav style="flex: 1;">
            <a href="home_caregiver.jsp" class="menu-link"><i class="fa-solid fa-house"></i> Tổng quan</a>
            <a href="my_relatives.jsp" class="menu-link active"><i class="fa-solid fa-users"></i> Hồ sơ gia đình</a>
            <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
            <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
            <a href="about.jsp" class="menu-link"><i class="fa-solid fa-circle-info"></i> About us</a>
            </nav>
            <div class="bonus-card">
                <small>Điểm thưởng tích lũy</small>
                <h2 style="margin: 5px 0 0 0;">1.250 pts</h2>
            </div>
        </aside>