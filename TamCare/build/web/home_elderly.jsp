<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%> 
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ (Dành cho Ông Bà)</title>
    <style>
        /* GIAO DIỆN TỐI GIẢN - BIG UI */
        body { font-family: Arial, sans-serif; background-color: #f9fff9; margin: 0; padding: 20px; }
        
        .header { background-color: #28a745; color: white; padding: 30px; border-radius: 20px; text-align: center; margin-bottom: 40px; }
        .header h1 { margin: 0; font-size: 36px; }
        
        .big-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; max-width: 1000px; margin: 0 auto; }
        
        .big-card {
            background: white; border: 3px solid #28a745; border-radius: 20px;
            padding: 40px; text-align: center; cursor: pointer; transition: 0.2s;
            text-decoration: none; color: #333; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .big-card:hover { background-color: #e8f5e9; transform: scale(1.02); }
        
        .icon { font-size: 80px; display: block; margin-bottom: 20px; }
        .label { font-size: 30px; font-weight: bold; display: block; }
        .desc { font-size: 18px; color: #666; margin-top: 10px; }

        .sos-btn {
            display: block; width: 100%; background-color: #dc3545; color: white;
            padding: 30px; text-align: center; border-radius: 20px; font-size: 40px; font-weight: bold;
            text-decoration: none; margin-top: 40px; border: 5px solid #bd2130;
        }
        
        .logout { position: fixed; top: 20px; right: 20px; font-size: 20px; color: white; text-decoration: underline; }
    </style>
</head>
<body>
    <% User acc = (User) session.getAttribute("account"); if(acc == null) { response.sendRedirect("login.jsp"); return; } %>

    <div class="header">
        <a href="logout" class="logout">Đăng xuất</a>
        <h1>Chào bác <%= acc.getFullName() %> 👋</h1>
        <p style="font-size: 24px;">Chúc bác một ngày vui vẻ và mạnh khỏe!</p>
    </div>

    <div class="big-grid">
        <a href="survey" class="big-card">
            <span class="icon">❤️</span>
            <span class="label">Sức Khỏe Của Tôi</span>
            <span class="desc">Cập nhật huyết áp, đau nhức...</span>
        </a>

        <a href="#" onclick="toggleChat()" class="big-card">
            <span class="icon">💬</span>
            <span class="label">Trò Chuyện</span>
            <span class="desc">Hỏi đáp với trợ lý ảo</span>
        </a>
    </div>

    <a href="#" class="sos-btn">🆘 GỌI CON CHÁU NGAY</a>

    <jsp:include page="chatbox.jsp"></jsp:include>
</body>
</html>