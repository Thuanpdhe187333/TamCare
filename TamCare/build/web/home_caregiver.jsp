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
    <title>TamCare - Tổng quan quản lý</title>
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

        .header-actions { display: flex; align-items: center; gap: 20px; height: 100%; }
        .header-item-wrapper { position: relative; height: 100%; display: flex; align-items: center; cursor: pointer; padding: 0 10px; }
        .header-item-wrapper::after { content: ''; position: absolute; top: 100%; left: 0; width: 100%; height: 15px; }
        
        .dropdown-menu { 
            position: absolute; top: 70px; right: 0; width: 220px; background: white; 
            border-radius: 0 0 15px 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
            display: none; flex-direction: column; overflow: hidden; border: 1px solid #e2e8f0; z-index: 1002; 
        }
        .header-item-wrapper:hover .dropdown-menu { display: flex; }
        .dropdown-link { padding: 12px 20px; text-decoration: none; color: var(--text-main); font-size: 14px; display: flex; align-items: center; gap: 10px; transition: 0.2s; }
        .dropdown-link:hover { background: var(--primary-light); color: var(--primary); }

        /* --- MAIN WRAPPER --- */
        .main-wrapper { display: flex; flex: 1; margin-top: 70px; }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width); background: var(--white);
            border-right: 2px solid #edf2f7; padding: 30px 24px;
            display: flex; flex-direction: column; position: fixed; 
            height: calc(100vh - 70px); box-sizing: border-box; z-index: 1000;
        }
        .menu-link { display: flex; align-items: center; gap: 16px; padding: 14px 20px; color: var(--text-muted); text-decoration: none; border-radius: 16px; margin-bottom: 8px; font-weight: 500; transition: var(--transition); }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); font-weight: 700; }

        .bonus-card { background: linear-gradient(135deg, #f1c40f, var(--bonus-gold)); padding: 24px; border-radius: 24px; color: var(--white); margin-top: auto; box-shadow: 0 8px 20px rgba(243, 156, 18, 0.2); }

        /* --- MAIN CONTENT AREA --- */
        .main-content { margin-left: var(--sidebar-width); padding: 40px 60px; width: calc(100% - var(--sidebar-width)); box-sizing: border-box; flex: 1; }

        /* Dashboard UI */
        .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 30px; border-radius: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; }
        .stat-icon { width: 60px; height: 60px; border-radius: 20px; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        
        .table-section { background: var(--white); border-radius: 35px; padding: 40px; box-shadow: 0 4px 25px rgba(0,0,0,0.03); }
        table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        td { padding: 20px; background: #fcfcfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        td:first-child { border-left: 1px solid #f1f5f9; border-radius: 20px 0 0 20px; }
        td:last-child { border-right: 1px solid #f1f5f9; border-radius: 0 20px 20px 0; }
        .status-pill { padding: 6px 16px; border-radius: 30px; font-size: 13px; font-weight: 700; }

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
                <div class="dropdown-menu" style="width: 300px; padding: 15px; font-weight: 700; color: #333;">Không có thông báo mới</div>
            </div>
            <div class="header-item-wrapper">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div style="text-align: right;"><span style="font-weight: 700; display: block;"><%= (acc != null) ? acc.getFullName() : "Thuận" %></span><small>Người chăm sóc</small></div>
                    <div style="width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-user"></i></div>
                </div>
                <div class="dropdown-menu">
                    <a href="profile_caregiver.jsp" class="dropdown-link"><i class="fa-solid fa-user-circle"></i> Hồ sơ cá nhân</a>
                    <a href="logout" class="dropdown-link" style="color: var(--accent); border-top: 1px solid #eee;"><i class="fa-solid fa-sign-out-alt"></i> Đăng xuất</a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-wrapper">
        <aside class="sidebar">
            <nav style="flex: 1;">
                <a href="home_caregiver.jsp" class="menu-link active"><i class="fa-solid fa-house"></i> Tổng quan</a>
                <a href="my_relatives.jsp" class="menu-link"><i class="fa-solid fa-users"></i> Hồ sơ gia đình</a>
                <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
                <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
                <a href="about.jsp" class="menu-link"><i class="fa-solid fa-circle-info"></i> About us</a>
            </nav>
            <div class="bonus-card">
                <small>Điểm thưởng tích lũy</small>
                <h2 style="margin: 5px 0 0 0;">1.250 pts</h2>
            </div>
        </aside>

        <main class="main-content">
            <div class="dashboard-header animate-up">
                <div>
                    <h1 style="font-size: 36px; margin: 0; color: var(--primary);">Xin chào, <%= (acc != null) ? acc.getFullName() : "Thuận" %> 👋</h1>
                    <p style="color: var(--text-muted); margin-top: 10px;">Hôm nay người thân của bạn thế nào?</p>
                </div>
                <a href="my_relatives.jsp" style="background: var(--primary); color: white; padding: 14px 30px; border-radius: 18px; text-decoration: none; font-weight: 700; box-shadow: 0 4px 15px rgba(0, 128, 128, 0.2);">+ Kết nối hồ sơ mới</a>
            </div>

            <div class="stat-grid animate-up">
                <div class="stat-card">
                    <div class="stat-icon" style="background: var(--primary-light); color: var(--primary);"><i class="fa-solid fa-user-check"></i></div>
                    <div><small>Đang theo dõi</small><h2 style="margin:0;">02 Người thân</h2></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: #fff5f2; color: var(--accent);"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div><small>Cảnh báo mới</small><h2 style="margin:0; color: var(--accent);">01 Tin khẩn</h2></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background: #f2fcf2; color: #16a34a;"><i class="fa-solid fa-check-double"></i></div>
                    <div><small>Lịch uống thuốc</small><h2 style="margin:0;">85% Hoàn thành</h2></div>
                </div>
            </div>

            <div class="table-section animate-up">
                <h3 style="margin-top: 0; color: var(--primary); margin-bottom: 30px;"><i class="fa-solid fa-notes-medical"></i> Cập nhật sức khỏe gần đây</h3>
                <table>
                    <thead><tr style="text-align: left; color: var(--text-muted);"><th>Người thân</th><th>Chỉ số</th><th>Trạng thái</th><th>Thời gian</th><th>Hành động</th></tr></thead>
                    <tbody>
                        <tr><td style="font-weight: 700;">Ông Nguyễn Văn A</td><td>125/80 mmHg</td><td><span class="status-pill" style="background: #e6f7ef; color: #16a34a;">Ổn định</span></td><td>10:15 Sáng nay</td><td><a href="#" style="color: var(--primary); font-weight: 700; text-decoration: none;">Chi tiết</a></td></tr>
                        <tr><td style="font-weight: 700;">Bà Trần Thị B</td><td>88 bpm</td><td><span class="status-pill" style="background: #fff9e6; color: #d9a016;">Cần chú ý</span></td><td>08:30 Sáng nay</td><td><a href="#" style="color: var(--primary); font-weight: 700; text-decoration: none;">Chi tiết</a></td></tr>
                    </tbody>
                </table>
            </div>
                        <div class="animate-up" style="margin-top: 50px; animation-delay: 0.3s;">

        <h3 style="color: var(--primary); margin-bottom: 20px;"><i class="fa-solid fa-map-location-dot"></i> Vị trí trung tâm hỗ trợ</h3>

        <div style="border-radius: 25px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); border: 4px solid white;">

            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.5063419330964!2d105.52487047585324!3d21.012416688344643!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345b465a4e65fb%3A0xaae6040cf059ef4d!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgSMOgIE7hu5lp!5e0!3m2!1svi!2s!4v1716300000000!5m2!1svi!2s" 

                width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>

        </div>

    </div>
        </main>
    </div> <%@include file="footer.jsp" %>
</body>
</html>