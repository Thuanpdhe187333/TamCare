<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page import="dal.CheckinNotificationDAO"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử thông báo - TamCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%
        User acc = (User) session.getAttribute("account");
        if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        CheckinNotificationDAO nDao = new CheckinNotificationDAO();
        List<CheckinNotificationDAO.CheckinNotificationView> notis =
                nDao.getByCaregiver(acc.getUserID());
    %>

    <style>
        :root {
            --primary: #008080;
            --bg: #f8fafc;
            --white: #ffffff;
            --text-muted: #64748b;
        }
        body { font-family: 'Lexend', sans-serif; background: var(--bg); margin: 0; padding-top: 90px; }
        
        /* Navbar đồng bộ với Header xanh */
        .navbar { 
            height: 70px; background: var(--primary); display: flex; 
            align-items: center; padding: 0 40px; position: fixed; 
            top: 0; width: 100%; z-index: 1001; box-sizing: border-box; 
        }
        .logo { font-size: 24px; font-weight: 800; color: white; text-decoration: none; }

        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .page-title { color: #1e293b; margin-bottom: 30px; display: flex; align-items: center; gap: 15px; }

        .noti-card {
            background: var(--white);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 15px;
            display: flex;
            gap: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
            border-left: 5px solid #cbd5e1;
            transition: 0.3s;
        }
        .noti-card.unread { border-left-color: var(--primary); background: #f0fdfa; }
        .noti-card:hover { transform: translateX(5px); box-shadow: 0 6px 20px rgba(0,0,0,0.05); }

        .noti-icon {
            width: 50px; height: 50px; border-radius: 50%;
            background: #e2e8f0; display: flex; align-items: center;
            justify-content: center; font-size: 20px; color: var(--primary);
        }
        .noti-card.emergency .noti-icon { background: #fee2e2; color: #ef4444; }
        .noti-card.emergency { border-left-color: #ef4444; }

        .noti-info h4 { margin: 0 0 5px 0; color: #334155; font-size: 16px; }
        .noti-info p { margin: 0; color: #64748b; font-size: 14px; line-height: 1.5; }
        .noti-time { font-size: 12px; color: #94a3b8; margin-top: 10px; display: block; }
        
        .empty-state { text-align: center; padding: 100px 0; color: var(--text-muted); }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="home_caregiver.jsp" class="logo"><i class="fa-solid fa-arrow-left"></i> Quay lại</a>
    </header>

    <div class="container">
        <div class="page-title">
            <i class="fa-solid fa-bell-concierge fa-2x" style="color: var(--primary);"></i>
            <h1>Lịch sử thông báo điểm danh</h1>
        </div>

        <div class="noti-list">
            <%
                if (notis != null && !notis.isEmpty()) {
                    for (dal.CheckinNotificationDAO.CheckinNotificationView v : notis) {
                        boolean unread = !v.isRead();
            %>
            <div class="noti-card <%= unread ? "unread" : "" %>">
                <div class="noti-icon"><i class="fa-solid fa-check-circle"></i></div>
                <div class="noti-info">
                    <h4>Điểm danh sức khỏe</h4>
                    <p><b><%= v.getElderlyName() %></b> đã điểm danh hôm nay và báo là vẫn ổn.</p>
                    <span class="noti-time">
                        <i class="fa-regular fa-clock"></i>
                        <%= new java.text.SimpleDateFormat("HH:mm dd/MM/yyyy").format(v.getCreatedAt()) %>
                    </span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">
                Hiện chưa có thông báo điểm danh nào từ người thân.
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>