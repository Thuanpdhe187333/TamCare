<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TamCare - Hệ thống chăm sóc sức khỏe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #0066cc; 
            --success: #28a745; 
            --danger: #dc3545;
            --warning: #f1c40f;
            --bg: #f0f7ff; 
            --white: #ffffff; 
            --sidebar-width: 300px;
        }

        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            background-color: var(--bg); 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh; 
            color: #333; 
        }

        /* --- 1. HEADER DỰ ÁN --- */
        .main-header {
            background-color: var(--white);
            height: 70px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1001;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-left { display: flex; align-items: center; gap: 20px; }
        .header-logo { font-size: 26px; font-weight: bold; color: var(--primary); text-decoration: none; }
        .header-right { display: flex; align-items: center; gap: 25px; }
        .nav-item { text-decoration: none; color: #495057; font-weight: 600; font-size: 17px; transition: 0.3s; }
        .nav-item:hover { color: var(--primary); }
        .noti-icon { position: relative; font-size: 22px; color: var(--primary); cursor: pointer; }
        .noti-badge { position: absolute; top: -5px; right: -5px; background: var(--danger); color: white; font-size: 10px; padding: 2px 5px; border-radius: 50%; }

        /* --- 2. THANH BÊN TRÁI (SIDEBAR) --- */
        .sidebar {
            width: var(--sidebar-width); 
            background: var(--white); 
            border-right: 2px solid #e0e6ed;
            padding: 20px; 
            display: flex; 
            flex-direction: column; 
            position: fixed; 
            top: 70px; bottom: 0; left: 0; 
            box-sizing: border-box;
            z-index: 1000;
        }
        .sidebar-box { 
            background: #f8f9fa; 
            border-radius: 20px; 
            padding: 20px; 
            margin-bottom: 25px; 
            border: 1px solid #dee2e6; 
        }
        .sidebar-box h3 { margin: 0 0 15px 0; font-size: 18px; color: var(--primary); border-bottom: 2px solid #e0e6ed; padding-bottom: 8px; }

        /* Combo Box Chọn Hồ Sơ */
        .profile-selector {
            width: 100%; padding: 12px; border-radius: 12px; border: 2px solid var(--primary);
            font-size: 16px; font-weight: bold; color: var(--primary); background: white; cursor: pointer; outline: none;
        }
        .point-display { margin-top: 15px; font-weight: bold; color: #d6a300; display: flex; align-items: center; gap: 10px; font-size: 19px; }

        /* --- 3. NỘI DUNG CHÍNH --- */
        .main-content { margin-top: 70px; margin-left: var(--sidebar-width); flex: 1; display: flex; flex-direction: column; }

        /* BOX ĐIỂM DANH LÀM NỔI BẬT NHẤT */
        .checkin-hero-card {
            margin: 25px;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            padding: 50px 30px;
            border-radius: 40px;
            text-align: center;
            color: white;
            box-shadow: 0 15px 35px rgba(56, 239, 125, 0.4);
            position: relative;
        }
        .checkin-title { font-size: 32px; font-weight: 800; margin: 0; text-shadow: 2px 2px 4px rgba(0,0,0,0.2); }
        .btn-checkin-huge {
            background: white; color: #11998e; border: none; padding: 22px 70px;
            border-radius: 60px; font-size: 34px; font-weight: 900; cursor: pointer;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15); transition: 0.3s; margin-top: 25px;
            text-transform: uppercase;
        }
        .btn-checkin-huge:hover { transform: scale(1.05); box-shadow: 0 12px 30px rgba(255,255,255,0.4); }

        /* Các thanh hiển thị ngang (Display Bars) */
        .content-scroll { padding: 0 25px 40px; display: flex; flex-direction: column; gap: 25px; }
        .display-bar { 
            background: var(--white); border-radius: 25px; padding: 25px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-left: 8px solid var(--primary);
        }
        .bar-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .bar-header h2 { margin: 0; font-size: 22px; color: var(--primary); }

        /* SOS Button */
        .sos-btn {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white; padding: 25px; border-radius: 25px; text-align: center;
            text-decoration: none; font-size: 30px; font-weight: bold; display: block;
            box-shadow: 0 8px 20px rgba(255, 75, 43, 0.3);
        }

        .footer { text-align: center; padding: 30px; background: #2f3542; color: #bdc3c7; margin-top: auto; }
    </style>
</head>
<body>
    <% 
        // Lấy tài khoản từ session
        User acc = (User) session.getAttribute("account"); 
        if(acc == null) { 
            response.sendRedirect("login.jsp"); 
            return; 
        } 
        // Lấy mã kết nối (LinkKey) từ database
        String myKey = (acc.getLinkKey() != null) ? acc.getLinkKey() : "TC888888";
    %>

    <header class="main-header">
        <div class="header-left">
            <a href="index.jsp" class="header-logo">👴 TamCare</a>
            <div style="width: 1px; height: 30px; background: #ddd; margin: 0 10px;"></div>
            <span style="font-weight: 600; color: #666;">Dành cho Ông Bà</span>
        </div>
        
        <div class="header-right">
            <a href="home_elderly.jsp" class="nav-item">Tổng quan</a>
            <a href="blog" class="nav-item">Tin tức</a>
            <a href="products" class="nav-item">Cửa hàng</a>
            <div class="noti-icon" onclick="alert('Bác có thông báo mới từ con cháu ạ!')">
                <i class="fa-solid fa-bell"></i>
                <span class="noti-badge">2</span>
            </div>
            <a href="logout" class="nav-item" style="color: var(--danger);">Đăng xuất</a>
        </div>
    </header>

    <aside class="sidebar">
        <div class="sidebar-box">
            <h3>Tài khoản của bác</h3>
            <select class="profile-selector" onchange="location.href=this.value">
                <option value="profile">👤 Thông tin cá nhân</option>
                <option value="points-history">⭐ Tích điểm của bác</option>
                <option value="medical-history">📋 Lịch sử bệnh án</option>
                <option value="change-password">🔑 Đổi mật khẩu</option>
            </select>

            <div class="point-display">
                <i class="fa-solid fa-star" style="color: var(--warning);"></i> 
                <span>Điểm tích lũy: 500</span>
            </div>
        </div>

        <div class="sidebar-box">
            <h3>Mã kết nối</h3>
            <p style="font-size: 14px; color: #666; margin-bottom: 10px;">Cung cấp mã này cho con cháu:</p>
            <div style="background: var(--primary); color: white; padding: 12px; border-radius: 12px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 2px;">
                <%= myKey %>
            </div>
        </div>

        <div class="sidebar-box" style="margin-top: auto; text-align: center;">
            <p style="font-size: 14px; margin: 0;">Hôm nay: <br><b style="font-size: 18px;">23/02/2026</b></p>
        </div>
    </aside>

    <div class="main-content">
        <section class="checkin-hero-card">
            <p class="checkin-title">BÁC ƠI, ĐẾN GIỜ ĐIỂM DANH RỒI!</p>
            <p style="font-size: 20px; opacity: 0.9; margin: 10px 0;">Bác báo cho con cháu biết mình đang khỏe nhé</p>
            <button class="btn-checkin-huge" onclick="location.href='daily-checkin'">
                😊 ĐIỂM DANH NGAY
            </button>
        </section>

        <div class="content-scroll">
            <section class="display-bar">
                <div class="bar-header">
                    <h2>📰 Mẹo Sống Khỏe</h2>
                    <a href="blog" style="color: var(--success); font-weight: bold; text-decoration: none;">Xem tất cả ></a>
                </div>
                <div style="display: flex; gap: 20px; align-items: center;">
                    <img src="https://via.placeholder.com/100" style="border-radius: 15px;" alt="Health Tip">
                    <div>
                        <b style="font-size: 20px;">Cách giữ ấm cơ thể trong mùa lạnh</b>
                        <p style="margin: 5px 0 0; color: #666;">Những lưu ý quan trọng để bảo vệ sức khỏe khi trời chuyển lạnh...</p>
                    </div>
                </div>
            </section>

            <section class="display-bar">
                <div class="bar-header"><h2>🛠 Tiện ích hồ sơ</h2></div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <a href="survey" style="background: #f0f7ff; padding: 25px; border-radius: 20px; text-align: center; text-decoration: none;">
                        <span style="font-size: 45px; display: block;">📋</span>
                        <b style="color: var(--primary); font-size: 20px;">Hồ sơ y tế</b>
                    </a>
                    <a href="javascript:void(0)" onclick="window.openChat()" style="background: #f0f7ff; padding: 25px; border-radius: 20px; text-align: center; text-decoration: none;">
                        <span style="font-size: 45px; display: block;">🤖</span>
                        <b style="color: var(--primary); font-size: 20px;">Trợ lý AI</b>
                    </a>
                </div>
            </section>

            <a href="tel:115" class="sos-btn">🆘 GỌI CON CHÁU KHẨN CẤP</a>
        </div>

        <footer class="footer">
            Được xây dựng với tình yêu thương ❤️ dành cho Người cao tuổi<br>
            <b>© 2026 TamCare Project</b>
        </footer>
    </div>

    <jsp:include page="chatbox.jsp"></jsp:include>
</body>
</html>