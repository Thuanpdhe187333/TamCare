<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, model.ElderlyProfile"%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết thông tin người thân</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f7f6; padding: 30px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 30px; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { color: #0066cc; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        .section { margin-bottom: 30px; }
        .info-row { display: flex; padding: 10px 0; border-bottom: 1px solid #fafafa; }
        .label { width: 200px; font-weight: bold; color: #555; }
        .btn-back { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #0066cc; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <a href="view-elderly-list" class="btn-back">← Quay lại danh sách</a>
        
        <% 
            User info = (User) request.getAttribute("elderlyInfo");
            ElderlyProfile profile = (ElderlyProfile) request.getAttribute("elderlyProfile");
        %>

        <h2>Thông tin cơ bản</h2>
        <div class="section">
            <div class="info-row"><div class="label">Họ và tên:</div><div><%= info.getFullName() %></div></div>
            <div class="info-row"><div class="label">Email:</div><div><%= info.getEmail() %></div></div>
            <div class="info-row"><div class="label">Số điện thoại:</div><div><%= info.getPhoneNumber() %></div></div>
        </div>

        <h2>Hồ sơ sức khỏe chi tiết</h2>
        <div class="section">
            <% if(profile != null) { %>
                <div class="info-row"><div class="label">Ngày sinh:</div><div><%= profile.getDateOfBirth() %></div></div>
                <div class="info-row"><div class="label">Địa chỉ:</div><div><%= profile.getAddress() %></div></div>
                <div class="info-row"><div class="label">Chiều cao:</div><div><%= profile.getHeight() %> cm</div></div>
                <div class="info-row"><div class="label">Cân nặng:</div><div><%= profile.getWeight() %> kg</div></div>
                <div class="info-row"><div class="label">Bệnh nền:</div><div style="color: #d63031; font-weight: bold;"><%= profile.getChronicConditions() %></div></div>
            <% } else { %>
                <p>Người thân chưa cập nhật hồ sơ sức khỏe chi tiết.</p>
            <% } %>
        </div>
    </div>
</body>
</html>