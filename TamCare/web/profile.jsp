<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="dal.UserDAO"%>
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
                justify-content: center;
                align-items: flex-start;
                min-height: 100vh;
                padding: 60px 20px;
                color: var(--text-main);
            }

            .card {
                background: var(--white);
                border-radius: 24px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                padding: 35px;
                width: 100%;
                max-width: 600px;
                border: 1px solid var(--primary-light);
            }

            .card-header {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 25px;
            }

            .avatar {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: var(--primary-light);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 36px;
                color: var(--primary-blue);
                font-weight: 800;
                border: 2px solid var(--white);
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }

            /* MỤC ĐIỂM THƯỞNG MỚI */
            .reward-section {
                background: linear-gradient(135deg, var(--primary-light), #ffffff);
                border: 1px solid #c3dafe;
                padding: 15px 25px;
                border-radius: 18px;
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                cursor: pointer;
                transition: 0.3s;
            }
            .reward-section:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(44, 82, 130, 0.1);
            }
            .reward-info { display: flex; align-items: center; gap: 15px; }
            .reward-icon {
                font-size: 24px;
                color: var(--gold);
                background: white;
                width: 45px;
                height: 45px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            }
            .reward-text b { font-size: 18px; color: var(--primary-blue); }

            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 15px 0;
                border-bottom: 1px dashed #e2e8f0;
                font-size: 15px;
                align-items: center;
            }
            .info-row span:first-child { color: var(--text-muted); font-weight: 500; }
            
            input, select {
                border: 1px solid #cbd5e1;
                border-radius: 10px;
                padding: 8px 12px;
                outline: none;
                transition: 0.3s;
            }
            input:focus { border-color: var(--primary-blue); background: #fdfdfd; }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                color: var(--primary-blue);
                font-size: 14px;
                margin-bottom: 15px;
                font-weight: 600;
            }
            
            .btn-save {
                background: var(--primary-blue);
                color: white;
                border: none;
                border-radius: 12px;
                padding: 12px 25px;
                cursor: pointer;
                font-weight: 700;
                transition: 0.3s;
                margin-top: 20px;
            }
            .btn-save:hover { background: var(--primary-dark); transform: translateY(-2px); }
        </style>
    </head>
    <body>
        <%
            User acc = (User) session.getAttribute("account");
            if (acc == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String fullName = acc.getFullName();
            String initial = (fullName != null && !fullName.isEmpty()) ? fullName.substring(0,1).toUpperCase() : "?";

            String roleLabel = "Thành viên";
            String backHref = "home_caregiver.jsp";
            if ("Elderly".equalsIgnoreCase(acc.getRole())) {
                roleLabel = "Ông/Bà";
                backHref = "home_elderly.jsp";
            } else if ("Caregiver".equalsIgnoreCase(acc.getRole())) {
                roleLabel = "Người chăm sóc";
                backHref = "home_caregiver.jsp";
            }
        %>

        <div class="card">
            <a href="<%= backHref %>" class="back-link">
                <i class="fa-solid fa-arrow-left"></i> Quay lại trang chính
            </a>

            <div class="card-header">
                <div class="avatar"><%= initial %></div>
                <div>
                    <h2 style="margin:0; color: var(--primary-blue);"><%= fullName %></h2>
                    <p style="margin:4px 0 0; color: var(--text-muted); font-size:14px;">
                        Vai trò: <span style="color: var(--primary-blue); font-weight: 700;"><%= roleLabel %></span>
                    </p>
                </div>
            </div>

<div class="reward-section" onclick="window.location.href='rewards'">
    <div class="reward-info">
        <div class="reward-icon">
            <i class="fa-solid fa-star"></i>
        </div>
        <div class="reward-text">
            <small style="color: var(--text-muted); display: block;">Điểm thưởng tích lũy</small>
            <b>${sessionScope.totalPoints != null ? sessionScope.totalPoints : "0"} pts</b>
        </div>
    </div>
    <i class="fa-solid fa-chevron-right" style="color: var(--primary-blue);"></i>
</div>

            <form method="post" action="UpdateProfileServlet">
                <h4 style="margin: 0 0 10px 0; color: var(--primary-blue);">Thông tin cá nhân</h4>
                
                <div class="info-row">
                    <span>Họ và tên</span>
                    <input type="text" name="fullName" value="<%= fullName %>">
                </div>
                
                <div class="info-row">
                    <span>Giới tính</span>
                    <select name="gender">
                        <option value="">Chưa chọn</option>
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                        <option value="Khác">Khác</option>
                    </select>
                </div>
                
                <div class="info-row">
                    <span>Năm sinh</span>
                    <input type="number" name="birthYear" min="1900" max="2100" style="width:100px;">
                </div>
                
                <div class="info-row">
                    <span>Email đăng nhập</span>
                    <span style="font-weight: 600;"><%= acc.getEmail() %></span>
                </div>
                
                <div class="info-row">
                    <span>Số điện thoại</span>
                    <input type="text" name="phoneNumber" value="<%= acc.getPhoneNumber() != null ? acc.getPhoneNumber() : "" %>">
                </div>
                
                <div class="info-row" style="border-bottom: none;">
                    <span>Mã kết nối</span>
                    <span style="background: #f1f5f9; padding: 4px 10px; border-radius: 8px; font-family: monospace; font-weight: bold;">
                        <%= acc.getLinkKey() != null ? acc.getLinkKey() : "CHƯA CÓ" %>
                    </span>
                </div>

                <div style="text-align:right;">
                    <button type="submit" class="btn-save">
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </body>
</html>