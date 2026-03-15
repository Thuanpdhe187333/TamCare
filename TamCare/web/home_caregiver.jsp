<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@page import="java.util.List" %>
<%@page import="dal.CaregiverDashboardDAO" %>
<%
    User acc = (User) session.getAttribute("account");
    if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    CaregiverDashboardDAO dashDao = new CaregiverDashboardDAO();
    List<CaregiverDashboardDAO.ElderlyCheckinStatus> checkins = dashDao.getElderlyCheckinStatuses(acc.getUserID());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Tổng quan quản lý</title>
    <style>
        body { background-color: #f8fafc; margin: 0; font-family: 'Lexend', sans-serif; }
        .main-content { margin-top: 75px; padding: 40px 10%; box-sizing: border-box; }
        .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 30px; border-radius: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; border: 1px solid #e0effa; }
        .stat-icon { width: 60px; height: 60px; border-radius: 20px; display: flex; align-items: center; justify-content: center; font-size: 26px; }
        .table-section { background: white; border-radius: 35px; padding: 40px; box-shadow: 0 4px 25px rgba(0,0,0,0.03); border: 1px solid #e0effa; }
        table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        td { padding: 20px; background: #fcfcfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        td:first-child { border-left: 1px solid #f1f5f9; border-radius: 20px 0 0 20px; }
        td:last-child { border-right: 1px solid #f1f5f9; border-radius: 0 20px 20px 0; }
        .status-pill { padding: 6px 16px; border-radius: 30px; font-size: 13px; font-weight: 700; }
        .btn-connect { background: #2c5282; color: white; padding: 14px 30px; border-radius: 18px; text-decoration: none; font-weight: 700; }
        .animate-up { animation: fadeInUp 0.7s ease both; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>

    <main class="main-content">
        <div class="dashboard-header animate-up">
            <div>
                <h1 style="font-size: 36px; margin: 0; color: #2c5282;">Xin chào, <%= acc.getFullName() %> 👋</h1>
                <p style="color: #64748b; margin-top: 10px;">Hôm nay người thân của bạn thế nào?</p>
            </div>
            <a href="my_relatives.jsp" class="btn-connect">+ Kết nối hồ sơ mới</a>
        </div>

        <div class="stat-grid animate-up">
            <div class="stat-card">
                <div class="stat-icon" style="background: #e0effa; color: #2c5282;"><i class="fa-solid fa-user-check"></i></div>
                <div><small>Đang theo dõi</small><h2 style="margin:0;">02 Người thân</h2></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #fff5f2; color: #ef4444;"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div><small>Cảnh báo mới</small><h2 style="margin:0; color: #ef4444;">01 Tin khẩn</h2></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #f2fcf2; color: #16a34a;"><i class="fa-solid fa-check-double"></i></div>
                <div><small>Lịch uống thuốc</small><h2 style="margin:0;">85% Hoàn thành</h2></div>
            </div>
        </div>

        <div class="table-section animate-up">
            <h3 style="margin-top: 0; color: #2c5282; margin-bottom: 30px;">
                <i class="fa-solid fa-check-circle"></i> Trạng thái điểm danh hôm nay
            </h3>
            <table>
                <thead>
                    <tr style="text-align: left; color: #64748b;">
                        <th>Người thân</th>
                        <th>Mã kết nối</th>
                        <th>Điểm danh hôm nay</th>
                        <th>Ghi chú</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (checkins != null && !checkins.isEmpty()) {
                        for (CaregiverDashboardDAO.ElderlyCheckinStatus es : checkins) {
                            boolean done = es.isCheckedInToday(); %>
                    <tr>
                        <td style="font-weight: 700;"><%= es.getElderly().getFullName() %></td>
                        <td><%= es.getElderly().getLinkKey() %></td>
                        <td>
                            <span class="status-pill" style="<%= done ? "background:#e6f7ef; color:#16a34a;" : "background:#fff9e6; color:#d97706;" %>">
                                <%= done ? "ĐÃ ĐIỂM DANH" : "CHƯA ĐIỂM DANH" %>
                            </span>
                        </td>
                        <td><%= done ? "Hôm nay người thân đã khỏe." : "Bạn nên chủ động hỏi thăm." %></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="4" style="text-align:center; padding:30px;">Chưa có người thân liên kết.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="animate-up" style="margin-top: 50px;">
            <h3 style="color: #2c5282; margin-bottom: 20px;"><i class="fa-solid fa-map-location-dot"></i> Vị trí hỗ trợ</h3>
            <div style="border-radius: 25px; overflow: hidden; border: 4px solid white; box-shadow: 0 10px 30px rgba(0,0,0,0.05);">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.485534575!2d105.5248756!3d21.013214!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345b465a4e65fb%3A0xa6159654ef2433e!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQ!5e0!3m2!1svi!2s!4v1700000000000" width="100%" height="400" style="border:0;"></iframe>
            </div>
        </div>
    </main>

    <%@include file="footer.jsp" %>
</body>
</html>