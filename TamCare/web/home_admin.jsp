<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Trị Viên - TamCare</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f1f2f6; margin: 0; }
        
        .sidebar {
            width: 250px; height: 100vh; background-color: #2f3542; color: white; position: fixed;
        }
        .sidebar h2 { text-align: center; padding: 20px 0; border-bottom: 1px solid #57606f; margin: 0; }
        .sidebar a { display: block; padding: 15px 20px; color: #dfe4ea; text-decoration: none; border-bottom: 1px solid #57606f; }
        .sidebar a:hover { background-color: #ff4757; color: white; }
        
        .main { margin-left: 250px; padding: 30px; }
        
        .header { display: flex; justify-content: space-between; align-items: center; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 30px; }
        
        /* Bảng quản lý User */
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #f1f2f6; }
        th { background-color: #2f3542; color: white; }
        tr:hover { background-color: #f1f2f6; }
        
        .role-tag { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .role-elderly { background-color: #2ed573; color: white; }
        .role-caregiver { background-color: #1e90ff; color: white; }
        
        .btn-delete { color: #ff4757; text-decoration: none; font-weight: bold; border: 1px solid #ff4757; padding: 5px 10px; border-radius: 5px; }
        .btn-delete:hover { background-color: #ff4757; color: white; }
    </style>
</head>
<body>
    <%
        User acc = (User) session.getAttribute("account");
        if(acc == null || !"Admin".equals(acc.getRole())) { response.sendRedirect("login.jsp"); return; }
        
        List<User> list = (List<User>) request.getAttribute("listUsers");
    %>

    <div class="sidebar">
        <h2>🛡️ Admin Panel</h2>
        <a href="admin">👥 Quản lý người dùng</a>
        <a href="#">📊 Thống kê hệ thống</a>
        <a href="logout">🚪 Đăng xuất</a>
    </div>

    <div class="main">
        <div class="header">
            <h1>Danh sách người dùng</h1>
            <div>Xin chào, <b><%= acc.getFullName() %></b></div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Họ và Tên</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Vai trò</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <% 
                   if (list != null) {
                       for (User u : list) {
                %>
                <tr>
                    <td>#<%= u.getUserID() %></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getPhoneNumber() %></td>
                    <td>
                        <% if(u.getRole().equals("Elderly")) { %>
                            <span class="role-tag role-elderly">Người Cao Tuổi</span>
                        <% } else { %>
                            <span class="role-tag role-caregiver">Người Chăm Sóc</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="delete-user?id=<%= u.getUserID() %>" 
                           class="btn-delete"
                           onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">
                           Xóa
                        </a>
                    </td>
                </tr>
                <% 
                       }
                   } 
                %>
            </tbody>
        </table>
    </div>
</body>
</html>