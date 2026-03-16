<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User, java.util.List"%>
<%@page import="dal.UserDAO"%>
<%@page import="dal.DailyCheckinDAO"%>

<%
    User acc = (User) session.getAttribute("account");
    if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    DailyCheckinDAO checkinDao = new DailyCheckinDAO();
    String msg = null;
    String msgType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String linkKey = request.getParameter("linkKey");
        if (linkKey != null && !linkKey.trim().isEmpty()) {
            Integer elderlyId = dao.getElderlyIdByLinkKey(linkKey.trim());
            if (elderlyId == null) {
                msg = "Mã kết nối không tồn tại hoặc không phải tài khoản Ông/Bà!";
                msgType = "error";
            } else {
                boolean ok = dao.linkCaregiverToElderly_Relationship(acc.getUserID(), elderlyId);
                if (ok) {
                    msg = "✅ Liên kết thành công!";
                    msgType = "success";
                } else {
                    msg = "❌ Liên kết thất bại hoặc đã tồn tại!";
                    msgType = "error";
                }
            }
        }
    }

    List<User> elderlyList = dao.getLinkedElderlyList_ByRelationship(acc.getUserID());
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Người thân của tôi</title>
    <style>
        body { background-color: #f8fafc; margin: 0; font-family: 'Lexend', sans-serif; }

        /* --- CONTENT AREA (Căn giữa khi không còn Sidebar) --- */
        .main-content-relatives { 
            margin-top: 75px; 
            padding: 40px 10%; 
            box-sizing: border-box; 
            min-height: 80vh;
        }

        .page-header { margin-bottom: 35px; }
        .page-header h1 { font-size: 32px; color: #2c5282; margin: 0; }
        .page-header p { color: #64748b; margin-top: 5px; }

        /* Form liên kết hồ sơ */
        .link-form-card { 
            background: #ffffff; 
            border-radius: 24px; 
            padding: 30px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.02); 
            margin-bottom: 40px; 
            display: flex; 
            gap: 15px; 
            align-items: center; 
            border: 1px solid #e0effa; 
        }
        .input-link { 
            flex: 1; 
            padding: 15px 20px; 
            border-radius: 14px; 
            border: 1px solid #c3dafe; 
            outline: none; 
            font-size: 15px; 
            transition: 0.3s;
        }
        .input-link:focus { border-color: #2c5282; box-shadow: 0 0 0 3px rgba(224, 239, 250, 0.5); }
        
        .btn-submit { 
            background: #2c5282; 
            color: white; 
            border: none; 
            padding: 15px 30px; 
            border-radius: 14px; 
            font-weight: 700; 
            cursor: pointer; 
            transition: 0.3s;
        }
        .btn-submit:hover { background: #1a365d; transform: translateY(-2px); }

        /* Grid hiển thị người thân */
        .relative-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); 
            gap: 25px; 
        }
        .relative-card { 
            background: white; 
            border-radius: 24px; 
            padding: 25px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.02); 
            border: 1px solid #e0effa; 
            transition: 0.3s; 
        }
        .relative-card:hover { transform: translateY(-5px); box-shadow: 0 12px 25px rgba(44, 82, 130, 0.08); }
        
        .initial-avatar { 
            width: 60px; 
            height: 60px; 
            border-radius: 18px; 
            background: #e0effa; 
            color: #2c5282; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 24px; 
            font-weight: 800; 
        }

        .btn-detail { 
            display: block; 
            width: 100%; 
            text-align: center; 
            padding: 12px; 
            background: #e0effa; 
            color: #2c5282; 
            text-decoration: none; 
            border-radius: 12px; 
            font-weight: 700; 
            margin-top: 20px; 
            transition: 0.3s;
        }
        .btn-detail:hover { background: #2c5282; color: white; }

        .alert-msg { padding: 15px 20px; border-radius: 15px; margin-bottom: 25px; font-weight: 600; font-size: 14px; }
    </style>
</head>
<body>

    <%@include file="header.jsp" %>

    <main class="main-content-relatives">
        <div class="page-header">
            <h1>Quản lý người thân</h1>
            <p>Kết nối và theo dõi sức khỏe các thành viên trong gia đình.</p>
        </div>

        <div class="link-form-card">
            <div style="background: #e0effa; width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #2c5282; font-size: 20px;">
                <i class="fa-solid fa-link"></i>
            </div>
            <form action="" method="post" style="display: contents;">
                <input name="linkKey" class="input-link" placeholder="Nhập mã kết nối (TC123456)..." required>
                <button type="submit" class="btn-submit">Liên kết ngay</button>
            </form>
        </div>

        <% if (msg != null) { %>
            <div class="alert-msg" style="<%= "error".equals(msgType) ? "background:#fee2e2; color:#ef4444;" : "background:#f0fdf4; color:#16a34a;" %>">
                <%= msg %>
            </div>
        <% } %>

        <div class="relative-grid">
            <% 
                if (elderlyList != null && !elderlyList.isEmpty()) {
                    for (User u : elderlyList) {
                        String initial = (u.getFullName() != null && !u.getFullName().isEmpty()) ? u.getFullName().substring(0, 1).toUpperCase() : "U";
            %>
            <div class="relative-card">
                <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 20px;">
                    <div class="initial-avatar"><%= initial %></div>
                    <div>
                        <h3 style="margin: 0; font-size: 18px; color: #2c5282;"><%= u.getFullName() %></h3>
                        <p style="margin: 4px 0 0; font-size: 13px; color: #64748b;">ID: #<%= (u.getLinkKey() != null) ? u.getLinkKey() : u.getUserID() %></p>
                    </div>
                </div>
                
                <div style="border-top: 1px solid #f1f5f9; padding-top: 20px;">
                    <%
                        boolean doneToday = checkinDao.hasCheckedInToday(u.getUserID());
                    %>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-size: 13px; color: #64748b;">Trạng thái hôm nay:</span>
                        <span style="font-size: 12px; font-weight: 800; color: <%= doneToday ? "#16a34a" : "#d97706" %>;">
                             <i class="fa-solid <%= doneToday ? "fa-circle-check" : "fa-clock" %>"></i> 
                             <%= doneToday ? "ĐÃ ĐIỂM DANH" : "CHƯA ĐIỂM DANH" %>
                        </span>
                    </div>
                    <a href="elderly_detail.jsp?id=<%= u.getUserID() %>" class="btn-detail">Xem chi tiết sức khỏe</a>
                </div>
            </div>
            <% } } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 60px; background: white; border-radius: 24px; border: 1px dashed #c3dafe;">
                    <i class="fa-solid fa-users-slash fa-3x" style="color: #cbd5e1; margin-bottom: 15px;"></i>
                    <p style="color: #64748b;">Chưa có người thân nào được liên kết. Hãy nhập mã kết nối ở trên.</p>
                </div>
            <% } %>
        </div>
    </main>

    <%@include file="footer.jsp" %>
</body>
</html>