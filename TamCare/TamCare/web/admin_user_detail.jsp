<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, model.ElderlyProfile"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng - TamCare Admin</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f1f2f6; margin: 0; padding: 40px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .header { border-bottom: 2px solid #1e90ff; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .section-title { font-weight: bold; color: #1e90ff; text-transform: uppercase; font-size: 14px; margin-bottom: 15px; display: block; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .info-item { background: #f8f9fa; padding: 15px; border-radius: 8px; border: 1px solid #eee; }
        .info-item label { color: #747d8c; font-size: 12px; display: block; margin-bottom: 5px; }
        .info-item span { font-weight: 600; color: #2f3542; font-size: 16px; }
        .btn-back { text-decoration: none; color: white; background: #2f3542; padding: 10px 20px; border-radius: 5px; font-weight: bold; }
        .btn-back:hover { background: #57606f; }
    </style>
</head>
<body>
    <div class="container">
        <% 
            User u = (User) request.getAttribute("u");
            ElderlyProfile p = (ElderlyProfile) request.getAttribute("p");
            if (u == null) { response.sendRedirect("admin"); return; }
        %>
        
        <div class="header">
            <h2>Hồ sơ chi tiết: <%= u.getFullName() %></h2>
            <a href="admin" class="btn-back">Quay lại danh sách</a>
        </div>

        <div class="section" style="margin-bottom: 30px;">
            <span class="section-title">Thông tin định danh hệ thống</span>
            <div class="info-grid">
                <div class="info-item"><label>ID người dùng</label><span>#<%= u.getUserID() %></span></div>
                <div class="info-item"><label>Email đăng ký</label><span><%= u.getEmail() %></span></div>
                <div class="info-item"><label>Số điện thoại</label><span><%= u.getPhoneNumber() %></span></div>
                <div class="info-item"><label>Vai trò (Role)</label>
                    <span style="color: <%= u.getRole().equals("Elderly") ? "#2ed573" : "#1e90ff" %>">
                        <%= u.getRole().equals("Elderly") ? "Người Cao Tuổi" : "Người Chăm Sóc" %>
                    </span>
                </div>
            </div>
        </div>

        <% if (u.getRole().equals("Elderly")) { %>
        <div class="section">
            <span class="section-title">Hồ sơ sức khỏe & Chỉ số sinh tồn</span>
            <% if (p != null) { %>
            <div class="info-grid">
                <div class="info-item"><label>Ngày sinh</label><span><%= p.getDateOfBirth() %></span></div>
                <div class="info-item"><label>Địa chỉ thường trú</label><span><%= p.getAddress() %></span></div>
                <div class="info-item"><label>Chiều cao</label><span><%= p.getHeight() %> cm</span></div>
                <div class="info-item"><label>Cân nặng</label><span><%= p.getWeight() %> kg</span></div>
                <div class="info-item" style="grid-column: span 2; border-left: 4px solid #ff4757;">
                    <label>Bệnh nền & Tình trạng mãn tính</label>
                    <span style="color: #ff4757;"><%= p.getChronicConditions() %></span>
                </div>
            </div>
            <% } else { %>
                <div style="padding: 20px; background: #fff5f5; border-radius: 8px; color: #c0392b; border: 1px dashed #e74c3c;">
                    Người dùng này chưa thực hiện khảo sát thông tin sức khỏe.
                </div>
            <% } %>
        </div>
        <% } %>
    </div>
</body>
</html>