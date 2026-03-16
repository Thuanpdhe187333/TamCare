<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="dal.UserDAO"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin cá nhân - TamCare</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary-blue: #2c5282;
                --primary-light: #e0effa;
                --white: #ffffff;
                --text-main: #1e293b;
                --text-muted: #64748b;
                --gold: #f39c12;
            }

            body {
                font-family: 'Lexend', sans-serif;
                background-color: #f8fafc;
                margin: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                color: var(--text-main);
            }

            .content-wrapper {
                margin-top: 100px;
                display: flex;
                justify-content: center;
                padding: 0 20px 60px;
            }

            .card {
                background: var(--white);
                border-radius: 30px;
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
                padding: 40px;
                width: 100%;
                max-width: 650px;
                border: 1px solid var(--primary-light);
            }

            .card-header {
                display: flex;
                align-items: center;
                gap: 25px;
                margin-bottom: 30px;
            }

            .avatar {
                width: 100px; height: 100px; border-radius: 50%;
                background: var(--primary-light); display: flex;
                align-items: center; justify-content: center;
                font-size: 40px; color: var(--primary-blue); font-weight: 800;
                border: 3px solid var(--white); box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .info-box {
                padding: 20px 25px;
                border-radius: 20px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                text-decoration: none;
                transition: 0.3s;
                border: 1px solid transparent;
            }
            
            .reward-box {
                background: linear-gradient(135deg, var(--primary-light), #ffffff);
                border-color: #c3dafe;
            }
            .reward-box:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(44, 82, 130, 0.1); }

            .status-box { display: flex; align-items: center; gap: 20px; width: 100%; }
            .icon-circle {
                width: 55px; height: 55px; border-radius: 15px;
                display: flex; align-items: center; justify-content: center;
                font-size: 24px; color: white;
            }

            .form-section-title {
                color: var(--primary-blue);
                font-size: 20px;
                font-weight: 700;
                margin: 30px 0 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid var(--primary-light);
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 18px 0;
                border-bottom: 1px dashed #e2e8f0;
                align-items: center;
            }
            .info-row label { color: var(--text-muted); font-weight: 600; font-size: 16px; }
            
            input, select {
                border: 1px solid #cbd5e1;
                border-radius: 12px;
                padding: 10px 15px;
                font-size: 16px;
                font-family: 'Lexend';
                outline: none;
                transition: 0.3s;
            }

            .btn-save {
                background: var(--primary-blue);
                color: white; border: none; border-radius: 15px;
                padding: 15px 35px; cursor: pointer; font-weight: 700;
                font-size: 18px; transition: 0.3s; margin-top: 30px;
                width: 100%;
            }
            .btn-save:hover { background: #1a365d; transform: translateY(-2px); }

            .back-link {
                text-decoration: none; color: var(--primary-blue);
                font-weight: 700; margin-bottom: 20px; display: inline-flex; align-items: center; gap: 8px;
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>

        <%
            // Lấy lại account từ session
            User profileUser = (User) session.getAttribute("account");
            if (profileUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String pFullName = profileUser.getFullName();
            String pInitial = (pFullName != null && !pFullName.isEmpty()) ? pFullName.substring(0,1).toUpperCase() : "?";

            // Logic tính ngày hết hạn - ĐỔI TÊN BIẾN TRÁNH TRÙNG VỚI HEADER
            boolean hasPremiumProfile = false;
            long profileDaysRemaining = -1;
            java.sql.Timestamp pExpiry = profileUser.getPremiumExpiry();
            
            if (pExpiry != null && pExpiry.after(new Date())) {
                hasPremiumProfile = true;
                long pDiff = pExpiry.getTime() - new Date().getTime();
                profileDaysRemaining = pDiff / (24 * 60 * 60 * 1000);
            }
            
            int pLevel = profileUser.getMemberLevel(); 
        %>

        <div class="content-wrapper">
            <div class="card">
                <a href="<%= "Elderly".equalsIgnoreCase(profileUser.getRole()) ? "home_elderly.jsp" : "home_caregiver.jsp" %>" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại trang chủ
                </a>

                <div class="card-header">
                    <div class="avatar"><%= pInitial %></div>
                    <div>
                        <h2 style="margin:0; color: var(--primary-blue); font-size: 28px;"><%= pFullName %></h2>
                        <span style="background: var(--primary-light); color: var(--primary-blue); padding: 4px 12px; border-radius: 20px; font-size: 14px; font-weight: 700;">
                            <%= profileUser.getRole() %>
                        </span>
                    </div>
                </div>

                <a href="rewards" class="info-box reward-box">
                    <div style="display:flex; align-items:center; gap:20px;">
                        <div class="icon-circle" style="background: #f39c12;"><i class="fa-solid fa-star"></i></div>
                        <div>
                            <small style="color: var(--text-muted); display: block;">Điểm thưởng tích lũy</small>
                            <b style="font-size: 22px; color: var(--primary-blue);">
                                <fmt:formatNumber value="${sessionScope.totalPoints != null ? sessionScope.totalPoints : 0}" type="number"/> pts
                            </b>
                        </div>
                    </div>
                    <i class="fa-solid fa-chevron-right" style="color: var(--primary-blue);"></i>
                </a>

                <% if (hasPremiumProfile && pLevel > 0) { 
                    String pBoxBg = (pLevel == 2) ? "#fff9eb" : "#eff6ff";
                    String pBorderCol = (pLevel == 2) ? "#ffeeb3" : "#bfdbfe";
                    String pIconCol = (pLevel == 2) ? "#f39c12" : "#3b82f6";
                    String pTitle = (pLevel == 2) ? "Hội viên Premium ✨" : "Hội viên Basic ☘️";
                    String pIconClass = (pLevel == 2) ? "fa-crown" : "fa-gem";
                %>
                    <div class="info-box" style="background: <%= pBoxBg %>; border: 1px solid <%= pBorderCol %>;">
                        <div class="status-box">
                            <div class="icon-circle" style="background: <%= pIconCol %>;">
                                <i class="fa-solid <%= pIconClass %>"></i>
                            </div>
                            <div>
                                <b style="font-size: 18px; color: <%= (pLevel == 2 ? "#926a00" : "#1e40af") %>;"><%= pTitle %></b>
                                <div style="font-size: 14px; color: #64748b; margin-top: 4px;">
                                    Hạn dùng: <b><fmt:formatDate value="<%= pExpiry %>" pattern="dd/MM/yyyy"/></b> 
                                    (<%= profileDaysRemaining >= 0 ? "Còn " + profileDaysRemaining + " ngày" : "Hết hạn" %>)
                                </div>
                            </div>
                        </div>
                        <a href="membership.jsp" style="font-size: 14px; color: var(--primary-blue); font-weight: 800; text-decoration: none;">Gia hạn</a>
                    </div>
                <% } else { %>
                    <div class="info-box" style="background: #f8fafc; border: 1px solid #e2e8f0;">
                        <div class="status-box">
                            <div class="icon-circle" style="background: #94a3b8;"><i class="fa-solid fa-user-slash"></i></div>
                            <div>
                                <b style="color: #64748b;">Hội viên thường</b>
                                <div style="font-size: 14px; color: #94a3b8; margin-top: 4px;">Nâng cấp để mở khóa tính năng AI</div>
                            </div>
                        </div>
                        <a href="membership.jsp" style="font-size: 14px; color: #e67e22; font-weight: 800; text-decoration: none;">Nâng cấp ngay</a>
                    </div>
                <% } %>

                <form method="post" action="UpdateProfileServlet">
                    <div class="form-section-title">Thông tin cá nhân</div>
                    
                    <div class="info-row">
                        <label>Họ và tên</label>
                        <input type="text" name="fullName" value="<%= pFullName %>" style="width: 250px;">
                    </div>
                    
                    <div class="info-row">
                        <label>Giới tính</label>
                        <select name="gender" style="width: 150px;">
                            <option value="Nam" <%= "Nam".equals(profileUser.getGender()) ? "selected" : "" %>>Nam</option>
                            <option value="Nữ" <%= "Nữ".equals(profileUser.getGender()) ? "selected" : "" %>>Nữ</option>
                            <option value="Khác" <%= "Khác".equals(profileUser.getGender()) ? "selected" : "" %>>Khác</option>
                        </select>
                    </div>
                    
                    <div class="info-row">
                        <label>Năm sinh</label>
                        <input type="number" name="birthYear" value="<%= profileUser.getBirthYear() != null ? profileUser.getBirthYear() : "" %>" style="width: 150px;">
                    </div>
                    
                    <div class="info-row">
                        <label>Số điện thoại</label>
                        <input type="text" name="phoneNumber" value="<%= profileUser.getPhoneNumber() != null ? profileUser.getPhoneNumber() : "" %>" style="width: 250px;">
                    </div>
                    
                    <div class="info-row" style="border-bottom: none;">
                        <label>Mã kết nối cá nhân</label>
                        <span style="background: #f1f5f9; padding: 8px 15px; border-radius: 10px; font-family: monospace; font-weight: 800; color: var(--primary-blue); font-size: 18px;">
                            <%= profileUser.getLinkKey() != null ? profileUser.getLinkKey() : "CHƯA CÓ" %>
                        </span>
                    </div>

                    <button type="submit" class="btn-save">Lưu tất cả thay đổi</button>
                </form>
            </div>
        </div>

        <%@include file="footer.jsp" %>
    </body>
</html>