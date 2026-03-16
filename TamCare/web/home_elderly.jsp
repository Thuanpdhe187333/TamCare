<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User"%>
<%@page import="dal.ProfileDAO"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    User acc = (User) session.getAttribute("account");
    if(acc == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String myKey = (acc.getLinkKey() != null) ? acc.getLinkKey() : "Chưa có mã";
    ProfileDAO profileDao = new ProfileDAO();
    int pId = profileDao.getProfileIDByUserID(acc.getUserID());
    String[] latestAI = profileDao.getLatestAISolution(pId > 0 ? pId : acc.getUserID(), "Nutrition");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Dành cho Ông Bà</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        :root {
            --primary: #2c5282;
            --success: #16a34a;
            --danger: #ef4444;
            --warning: #f39c12;
            --bg: #f0f7ff;
        }

        body {
            font-family: 'Lexend', sans-serif;
            margin: 0;
            background-color: var(--bg);
            font-size: 20px; 
        }

        .main-container {
            max-width: 1300px;
            margin: 100px auto 50px;
            padding: 0 30px;
        }

        /* THANH MÃ KẾT NỐI (ĐÃ BỎ ĐIỂM BỊ TRÙNG) */
        .top-info-bar {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }
        .connection-pill {
            background: white;
            padding: 15px 40px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            color: var(--primary);
        }

        /* BANNER CHÍNH */
        .hero-banner {
            background: linear-gradient(135deg, #2c5282 0%, #4299e1 100%);
            padding: 60px 40px;
            border-radius: 40px;
            text-align: center;
            color: white;
            box-shadow: 0 15px 40px rgba(44, 82, 130, 0.2);
            margin-bottom: 40px;
        }
        .btn-checkin {
            background: white;
            color: var(--primary);
            border: none;
            padding: 25px 70px;
            border-radius: 60px;
            font-size: 32px;
            font-weight: 800;
            cursor: pointer;
            margin-top: 30px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            transition: 0.3s;
        }

        /* GRID THÔNG TIN */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        .big-card {
            background: white;
            border-radius: 35px;
            padding: 35px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            border-bottom: 8px solid var(--primary);
        }
        .big-card.nutrition { border-bottom-color: var(--success); }

        /* MỤC BẢN ĐỒ MỚI */
        .map-section {
            background: white;
            border-radius: 40px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }
        .map-wrapper {
            border-radius: 25px;
            overflow: hidden;
            height: 450px;
            border: 1px solid #eee;
        }

        /* SOS */
        .btn-sos {
            background: var(--danger);
            color: white;
            padding: 35px;
            border-radius: 30px;
            text-align: center;
            text-decoration: none;
            font-size: 40px;
            font-weight: 800;
            display: block;
            box-shadow: 0 15px 35px rgba(239, 68, 68, 0.4);
            margin-bottom: 40px;
        }

        .animate-up { animation: fadeInUp 0.6s ease both; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <%@include file="header.jsp" %>

    <div class="main-container">
        
        <div class="top-info-bar animate-up">
            <div class="connection-pill">
                <i class="fa-solid fa-key fa-2x"></i>
                <span style="font-weight: 600;">Mã kết nối của bác: </span>
                <strong style="font-size: 32px; letter-spacing: 2px;"><%= myKey %></strong>
            </div>
        </div>

        <section class="hero-banner animate-up">
            <h1 style="font-size: 45px; font-weight: 800;">CHÚC BÁC MỘT NGÀY TỐT LÀNH!</h1>
            <p style="font-size: 24px;">Bác nhớ bấm nút dưới đây để gia đình yên tâm nhé ạ</p>
            <button class="btn-checkin" onclick="location.href='daily-checkin'">
                <i class="fa-solid fa-face-smile"></i> ĐIỂM DANH NGAY
            </button>
        </section>

        <div class="info-grid">
            <div class="big-card animate-up" style="animation-delay: 0.2s;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2 style="font-size: 30px; color: var(--primary); margin: 0;"><i class="fa-solid fa-newspaper"></i> Mẹo Sống Khỏe</h2>
                    <a href="blog.jsp" style="font-size: 20px; color: var(--primary); font-weight: 700; text-decoration: none;">Xem tất cả ></a>
                </div>
                <div style="display: flex; gap: 25px; align-items: center;">
                    <img src="https://img.freepik.com/free-vector/elderly-health-concept-illustration_114360-6023.jpg" style="width: 140px; height: 140px; border-radius: 20px; object-fit: cover;">
                    <div style="font-size: 22px; color: #475569; line-height: 1.6;">
                        <strong style="color: #1e293b;">Giữ ấm cơ thể</strong><br>
                        Bác nhớ quàng khăn và đi tất ấm mỗi sáng sớm để bảo vệ sức khỏe...
                    </div>
                </div>
            </div>

            <div class="big-card nutrition animate-up" style="animation-delay: 0.3s;">
                <h2 style="font-size: 30px; color: var(--success); margin: 0 0 20px 0;"><i class="fa-solid fa-utensils"></i> Dinh dưỡng hôm nay</h2>
                <div style="font-size: 22px; color: #475569; line-height: 1.8;">
                    <% if (latestAI != null && latestAI[0] != null) { %>
                        <%= latestAI[0].replace("\n", "<br>") %>
                    <% } else { %>
                        <p style="font-style: italic; color: #94a3b8;">Bác hãy cập nhật hồ sơ bệnh án để nhận gợi ý món ăn tốt nhất.</p>
                        <a href="GenerateNutritionServlet?profileId=<%= acc.getUserID() %>" style="color: var(--success); font-weight: 800; text-decoration: none;">+ Bấm để tạo gợi ý</a>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="map-section animate-up" style="animation-delay: 0.4s;">
            <h2 style="font-size: 30px; color: var(--primary); margin: 0 0 20px 0;"><i class="fa-solid fa-map-location-dot"></i> Vị trí </h2>
            <div class="map-wrapper">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.4855345754974!2d105.5248756113887!3d21.013244988225573!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345b465a4e65fb%3A0xaae60567ad2213d0!2zS2h1IEPDtG5nIG5naOG7hyBDYW8gSMOyYSBM4bqhYw!5e0!3m2!1svi!2s!4v1710520000000!5m2!1svi!2s" 
                        width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>

        <a href="tel:115" class="btn-sos animate-up" style="animation-delay: 0.5s;">
            <i class="fa-solid fa-phone-volume"></i> GỌI KHẨN CẤP CHO CON CHÁU
        </a>

    </div>

    <%@include file="footer.jsp" %>
</body>
</html>