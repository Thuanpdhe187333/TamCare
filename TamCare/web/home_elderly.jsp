<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User"%>
<%@page import="dal.ProfileDAO"%>
<%@page import="dal.AINutritionDAO"%>
<%
    User acc = (User) session.getAttribute("account");
    if(acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String myKey = acc.getLinkKey();
    if (myKey == null || myKey.trim().isEmpty()) {
        myKey = "Chưa có mã";
    }
    // Resolve ProfileID cho AISolutions: ưu tiên ElderlyProfile, không có thì dùng UserID (khi insert trực tiếp AISolutions/MedicalHistory theo UserID)
    ProfileDAO profileDao = new ProfileDAO();
    int profileIdForAI = profileDao.getProfileIDByUserID(acc.getUserID());
    if (profileIdForAI <= 0 && "Elderly".equalsIgnoreCase(acc.getRole())) {
        profileIdForAI = acc.getUserID();
    }
    String[] latestAI = null;
    if (profileIdForAI > 0) {
        latestAI = profileDao.getLatestAISolution(profileIdForAI, "Nutrition");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TamCare - Dành cho Ông Bà</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&family=Lexend:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #0066cc;
            --primary-light: #eef6ff;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #f1c40f;
            --white: #ffffff;
            --text-main: #1e293b;
            --sidebar-width: 300px;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            background-color: #f0f7ff;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            color: var(--text-main);
        }

        /* --- 1. HEADER (Navbar) --- */
        .main-header {
            background-color: var(--white);
            height: 70px;
            display: flex;
            justify-content: space-between; /* Đẩy cụm phải sang phải */
            align-items: center;
            padding: 0 40px;
            position: fixed; top: 0; left: 0; right: 0;
            z-index: 1001;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .header-logo {
            font-size: 26px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
            font-family: 'Lexend', sans-serif;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-right-group {
            display: flex;
            align-items: center;
            gap: 35px;
            height: 100%;
        }

        .header-nav-links { display: flex; gap: 25px; align-items: center; }
        .nav-link-top { text-decoration: none; color: var(--text-main); font-weight: 700; font-size: 16px; transition: 0.3s; }
        .nav-link-top:hover { color: var(--primary); }

        .header-actions { display: flex; align-items: center; gap: 5px; height: 100%; }

        /* HOVER DROPDOWN */
        .header-item-wrapper { position: relative; height: 100%; display: flex; align-items: center; cursor: pointer; padding: 0 15px; }
        .header-item-wrapper::after { content: ''; position: absolute; top: 100%; left: 0; width: 100%; height: 15px; }
        
        .dropdown-box {
            position: absolute; top: 70px; right: 0; width: 280px;
            background: white; border-radius: 0 0 15px 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: none; flex-direction: column; overflow: hidden;
            border: 1px solid #e2e8f0; z-index: 1002;
        }
        .header-item-wrapper:hover .dropdown-box { display: flex; }

        .noti-item { padding: 15px; border-bottom: 1px solid #f1f5f9; text-decoration: none; color: inherit; display: flex; gap: 10px; font-size: 14px; }
        .noti-item:hover { background: var(--primary-light); }

        /* --- 2. SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--white);
            border-right: 2px solid #e0e6ed;
            padding: 25px;
            display: flex;
            flex-direction: column;
            position: fixed; top: 70px; bottom: 0; left: 0;
            box-sizing: border-box; z-index: 1000;
        }

        .menu-link {
            display: flex; align-items: center; gap: 12px; padding: 14px 18px;
            color: #475569; text-decoration: none; border-radius: 12px;
            margin-bottom: 5px; font-weight: 600; transition: 0.3s;
        }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); }

        .sidebar-box {
            background: #f8f9fa; border-radius: 20px;
            padding: 20px; margin-top: 20px; border: 1px solid #dee2e6;
        }
        .sidebar-box h3 { margin: 0 0 10px 0; font-size: 16px; color: var(--primary); font-weight: 700; }

        /* --- 3. MAIN CONTENT --- */
        .main-wrapper { display: flex; flex: 1; margin-top: 70px; }
        .main-content {
            margin-left: var(--sidebar-width);
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
        }

        .checkin-hero-card {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            padding: 50px 30px; border-radius: 40px; text-align: center; color: white;
            box-shadow: 0 15px 35px rgba(56, 239, 125, 0.3); margin-bottom: 40px;
        }

        .btn-checkin-huge {
            background: white; color: #11998e; border: none;
            padding: 20px 60px; border-radius: 60px; font-size: 30px;
            font-weight: 900; cursor: pointer; margin-top: 25px; transition: 0.3s;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .btn-checkin-huge:hover { transform: scale(1.05); }

        .display-bar {
            background: var(--white); border-radius: 25px; padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); border-left: 8px solid var(--primary);
            margin-bottom: 25px;
        }
        /* Two-column: Healthy Tips | AI Nutrition */
        .two-col-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 25px;
        }
        @media (max-width: 900px) {
            .two-col-section { grid-template-columns: 1fr; }
        }
        .two-col-card {
            background: var(--white);
            border-radius: 25px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-left: 8px solid var(--primary);
        }
        .two-col-card.nutrition { border-left-color: var(--success); }
        .two-col-card h2 { margin: 0 0 15px 0; font-size: 22px; color: var(--primary); }
        .two-col-card.nutrition h2 { color: var(--success); }
        .ai-content { font-size: 15px; line-height: 1.7; color: #334155; }
        .ai-content .line { margin-bottom: 8px; }
        .ai-content strong { color: #1e293b; }
        .ai-placeholder { color: #64748b; font-style: italic; }

        .sos-btn {
            background: linear-gradient(to right, #ff416c, #ff4b2b);
            color: white; padding: 25px; border-radius: 25px;
            text-align: center; text-decoration: none; font-size: 26px;
            font-weight: 800; display: block; box-shadow: 0 8px 20px rgba(255, 75, 43, 0.3);
        }

        /* --- 4. FOOTER --- */
        .footer {
            background: #1e293b; color: #94a3b8; padding: 50px 80px;
            display: grid; grid-template-columns: 1.5fr 1fr 1fr; gap: 50px; margin-top: auto;
        }

        .animate-up { animation: fadeInUp 0.7s ease both; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <header class="main-header">
        <a href="home_elderly.jsp" class="header-logo">
            <i class="fa-solid fa-blind"></i> TamCare
        </a>
        
        <div class="header-right-group">
            <nav class="header-nav-links">
                <a href="home_elderly.jsp" class="nav-link-top">Tổng quan</a>
                <a href="blog.jsp" class="nav-link-top">Tin tức & Blog</a>
                <a href="products.jsp" class="nav-link-top">Cửa hàng y tế</a>
            </nav>

            <div class="header-actions">
                <div class="header-item-wrapper">
                    <div style="position: relative;">
                        <i class="fa-solid fa-bell fa-lg" style="color: var(--primary);"></i>
                        <span style="position: absolute; top: -10px; right: -10px; background: var(--danger); color: white; font-size: 10px; padding: 2px 6px; border-radius: 10px;">3</span>
                    </div>
                    <div class="dropdown-box">
                        <div style="padding: 15px; font-weight: 700; border-bottom: 1px solid #eee; color: #333;">Lời nhắn từ con cháu</div>
                        <a href="notifications.jsp" class="noti-item">
                            <i class="fa-solid fa-heart" style="color: var(--danger); margin-top: 3px;"></i>
                            <div>
                                <p style="margin:0; font-weight:600;">Con Thuận vừa gửi lời chúc bác!</p>
                                <small style="color: #888;">Vừa xong</small>
                            </div>
                        </a>
                        <a href="notifications.jsp" style="text-align: center; padding: 12px; color: var(--primary); font-weight: 700; text-decoration: none; background: #f8fafc; font-size: 13px;">Xem tất cả</a>
                    </div>
                </div>

                <div class="header-item-wrapper">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span style="font-weight: 700;"><%= acc.getFullName() %></span>
                        <div style="width: 38px; height: 38px; border-radius: 50%; background: var(--primary-light); display: flex; align-items: center; justify-content: center; border: 1px solid #d0e4ff;">
                            <i class="fa-solid fa-user-tie" style="color: var(--primary);"></i>
                        </div>
                    </div>
                    <div class="dropdown-box" style="width: 200px;">
                        <a href="profile.jsp" class="noti-item"><i class="fa-solid fa-id-card"></i> Hồ sơ của bác</a>
                        <a href="logout" class="noti-item" style="color: var(--danger);"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="main-wrapper">
        <aside class="sidebar">
            <nav style="flex: 1;">
                <a href="home_elderly.jsp" class="menu-link active"><i class="fa-solid fa-house"></i> Trang chủ</a>
                <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
                <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
                <a href="MedicalHistoryServlet?profileId=<%= acc.getUserID() %>" class="menu-link"><i class="fa-solid fa-file-medical"></i> Lịch sử bệnh án</a>
            </nav>

            <div class="sidebar-box">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <h3 style="margin:0;">Điểm của bác</h3>
                    <i class="fa-solid fa-star" style="color: var(--warning);"></i>
                </div>
                <div style="font-size: 24px; font-weight: 800; color: #d6a300;">1.250 <span style="font-size: 14px;">pts</span></div>
            </div>

            <div class="sidebar-box">
                <h3>Mã kết nối</h3>
                <div style="background: var(--primary); color: white; padding: 12px; border-radius: 12px; text-align: center; font-size: 22px; font-weight: 800; letter-spacing: 2px;">
                    <%= myKey %>
                </div>
                <p style="font-size: 12px; color: #666; margin-top: 10px; text-align: center;">Đưa mã này cho con cháu để kết nối bác nhé!</p>
            </div>
        </aside>

        <main class="main-content">
            <section class="checkin-hero-card animate-up">
                <p style="font-size: 32px; font-weight: 800; margin: 0;">CHÚC BÁC MỘT NGÀY TỐT LÀNH !</p>
                <p style="font-size: 18px; opacity: 0.9; margin-top: 10px;">Báo cho gia đình biết hôm nay bác vẫn khỏe mạnh nhé ạ</p>
                <%
                    String checkinMessage = (String) request.getAttribute("checkinMessage");
                %>
                <button class="btn-checkin-huge" onclick="location.href='daily-checkin'">
                    😊 ĐIỂM DANH NGAY
                </button>
                <% if (checkinMessage != null) { %>
                    <p style="margin-top:15px; font-size:16px; font-weight:600;"><%= checkinMessage %></p>
                <% } %>
            </section>

            <div class="animate-up" style="animation-delay: 0.2s;">
                <div class="two-col-section">
                    <section class="two-col-card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                            <h2 style="margin:0;">📰 Mẹo Sống Khỏe</h2>
                            <a href="blog.jsp" style="color: var(--success); font-weight: 700; text-decoration: none;">Xem thêm ></a>
                        </div>
                        <div style="display: flex; gap: 20px; align-items: center;">
                            <img src="https://via.placeholder.com/80" style="border-radius: 15px;" alt="health">
                            <div>
                                <b style="font-size: 18px;">Cách giữ ấm trong mùa lạnh</b>
                                <p style="margin: 5px 0 0; color: #666; font-size: 14px;">Bác nhớ quàng khăn và giữ ấm đôi chân mỗi sáng sớm nhé ạ...</p>
                            </div>
                        </div>
                    </section>
                    <section class="two-col-card nutrition">
                        <h2 style="margin:0 0 15px 0;">🥗 Gợi ý dinh dưỡng cho hôm nay</h2>
                        <% if (latestAI != null && latestAI[0] != null && !latestAI[0].isEmpty()) {
                            String[] lines = latestAI[0].split("\n");
                        %>
                        <div class="ai-content">
                            <% for (String line : lines) {
                                if (line.startsWith("Bệnh:")) { %>
                                <div class="line"><strong>Bệnh phát hiện:</strong> <%= line.substring(line.indexOf(":") + 1).trim() %></div>
                                <% } else if (line.startsWith("Nên tăng:")) { %>
                                <div class="line"><strong>Nên tăng:</strong> <%= line.substring(line.indexOf(":") + 1).trim() %></div>
                                <% } else if (line.startsWith("Nên giảm:")) { %>
                                <div class="line"><strong>Nên giảm:</strong> <%= line.substring(line.indexOf(":") + 1).trim() %></div>
                                <% } else if (line.startsWith("Thực phẩm:")) { %>
                                <div class="line"><strong>Thực phẩm gợi ý:</strong> <%= line.substring(line.indexOf(":") + 1).trim() %></div>
                                <% } else { %>
                                <div class="line"><%= line %></div>
                                <% }
                            } %>
                            <% if (latestAI[1] != null && !latestAI[1].isEmpty()) { %>
                            <p style="margin-top:12px; font-size:12px; color:#94a3b8;">Cập nhật: <%= latestAI[1] %></p>
                            <% } %>
                        </div>
                        <% } else if (profileIdForAI <= 0) { %>
                        <p class="ai-placeholder">Hoàn thiện hồ sơ sức khỏe (ElderlyProfile) để nhận gợi ý dinh dưỡng.</p>
                        <% } else { %>
                        <p class="ai-placeholder">Chưa có gợi ý. Cập nhật lịch sử bệnh án để hệ thống tạo gợi ý dinh dưỡng theo bệnh của bác.</p>
                        <p style="margin-top:10px;"><a href="GenerateNutritionServlet?profileId=<%= profileIdForAI %>" style="color:var(--success); font-weight:600;">Tạo gợi ý ngay</a></p>
                        <% } %>
                    </section>
                </div>

                <a href="tel:115" class="sos-btn">
                    <i class="fa-solid fa-phone-volume" style="margin-right: 15px;"></i> GỌI KHẨN CẤP CHO CON CHÁU
                </a>
            </div>
        </main>
    </div>

    <footer class="footer">
        <div>
            <h2 style="color: white; margin:0 0 15px 0;">TamCare</h2>
            <p style="font-size: 14px; line-height: 1.6;">Ứng dụng kết nối gia đình, chăm sóc sức khỏe người cao tuổi Việt Nam.</p>
        </div>
        <div>
            <h4 style="color: white; margin-bottom: 15px;">Liên hệ hỗ trợ</h4>
            <p style="font-size: 14px; margin: 5px 0;"><i class="fa-solid fa-phone"></i> 1900 1234</p>
            <p style="font-size: 14px; margin: 5px 0;"><i class="fa-solid fa-envelope"></i> troly@tamcare.vn</p>
        </div>
        <div style="text-align: right;">
            <p style="color: white; font-weight: 600;">Vì một tuổi già hạnh phúc ❤️</p>
            <p style="font-size: 12px; margin-top: 5px;">© 2026 TamCare Project</p>
        </div>
    </footer>

    <jsp:include page="chatbox.jsp"></jsp:include>

</body>
</html>