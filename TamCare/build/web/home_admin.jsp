<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Trị Viên - TamCare</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #3498db; --success: #2ed573; --danger: #ff4757;
            --warning: #ffa502; --dark: #2f3542; --bg: #f1f2f6;
        }
        body { font-family: 'Segoe UI', sans-serif; background-color: var(--bg); margin: 0; display: flex; }
        
        /* SIDEBAR */
        .sidebar { width: 250px; height: 100vh; background-color: var(--dark); color: white; position: fixed; }
        .sidebar h2 { text-align: center; padding: 25px 0; border-bottom: 1px solid #57606f; margin: 0; color: var(--success); }
        .sidebar a { display: block; padding: 15px 20px; color: #dfe4ea; text-decoration: none; border-bottom: 1px solid #485460; transition: 0.3s; }
        .sidebar a:hover, .sidebar a.active { background-color: #57606f; color: white; border-left: 5px solid var(--success); }
        
        /* MAIN CONTENT */
        .main { margin-left: 250px; padding: 25px; width: calc(100% - 250px); box-sizing: border-box; }
        
        /* HEADER & TOP ACTIONS */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-add-new { background: var(--success); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: bold; box-shadow: 0 4px 6px rgba(46, 213, 115, 0.2); }

        /* BIỂU ĐỒ - LAYOUT GỌN GÀNG */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .chart-card { background: white; padding: 15px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); height: 240px; }
        .chart-card h4 { margin: 0 0 10px 0; font-size: 13px; color: #7f8c8d; text-align: center; border-bottom: 1px solid #f1f2f6; padding-bottom: 5px; }

        /* TABLE CRUD */
        .table-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; background: #f8f9fa; color: var(--dark); font-size: 13px; text-transform: uppercase; }
        td { padding: 12px; border-bottom: 1px solid #f1f2f6; font-size: 14px; }
        
        /* ACTIONS BUTTONS */
        .action-links a { text-decoration: none; font-weight: 600; font-size: 12px; margin-right: 10px; }
        .edit-link { color: var(--primary); }
        .delete-link { color: var(--danger); }
        
        .role-badge { padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: bold; color: white; }
        .elderly { background: var(--primary); }
        .caregiver { background: var(--warning); }
    </style>
</head>
<body>
    <%
        User acc = (User) session.getAttribute("account");
        if(acc == null || !"Admin".equals(acc.getRole())) { response.sendRedirect("login.jsp"); return; }
        List<User> list = (List<User>) request.getAttribute("listUsers");
    %>

    <div class="sidebar">
        <h2>TAMCARE</h2>
        <a href="admin" class="active">👥 Quản lý thành viên</a>
        <a href="system-logs">📜 Nhật ký hệ thống</a> <a href="logout">🚪 Đăng xuất</a>
    </div>

    <div class="main">
        <div class="header">
            <div>
                <h1 style="margin:0">Chào, <%= acc.getFullName() %> 👋</h1>
                <small style="color: #7f8c8d">Hệ thống đang hoạt động ổn định</small>
            </div>
            <a href="register.jsp" class="btn-add-new">+ Thêm thành viên mới</a>
        </div>

        <div class="stats-grid">
            <div class="chart-card">
                <h4>📊 Cơ cấu vai trò</h4>
                <canvas id="roleChart"></canvas>
            </div>
            <div class="chart-card">
                <h4>📈 Tăng trưởng (Tháng)</h4>
                <canvas id="growthChart"></canvas>
            </div>
            <div class="chart-card">
                <h4>🏥 Tình trạng sức khỏe</h4>
                <canvas id="healthChart"></canvas>
            </div>
        </div>

        <div class="table-card">
            <h3>Danh sách thành viên</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (list != null) { for (User u : list) { %>
                    <tr>
                        <td>#<%= u.getUserID() %></td>
                        <td><b><%= u.getFullName() %></b></td>
                        <td><%= u.getEmail() %></td>
                        <td>
                            <span class="role-badge <%= u.getRole().equals("Elderly") ? "elderly" : "caregiver" %>">
                                <%= u.getRole() %>
                            </span>
                        </td>
                        <td class="action-links">
                            <a href="edit-user?id=<%= u.getUserID() %>" class="edit-link">Sửa</a>
                            <a href="delete-user?id=<%= u.getUserID() %>" class="delete-link" onclick="return confirm('Xóa người dùng này?')">Xóa</a>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const commonOptions = {
            responsive: true, maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 10 } } } }
        };

        // Biểu đồ Tròn: Vai trò (Dùng bảng màu hiện đại)
        new Chart(document.getElementById('roleChart'), {
            type: 'doughnut',
            data: {
                labels: ['Người già', 'Chăm sóc'],
                datasets: [{ data: [60, 40], backgroundColor: ['#3498db', '#ffa502'], borderWidth: 0 }]
            },
            options: commonOptions
        });

        // Biểu đồ Đường: Tăng trưởng (Làm mượt đường cong)
        new Chart(document.getElementById('growthChart'), {
            type: 'line',
            data: {
                labels: ['T1', 'T2', 'T3', 'T4'],
                datasets: [{ 
                    label: 'User mới', data: [5, 18, 12, 30], 
                    borderColor: '#2ed573', backgroundColor: 'rgba(46, 213, 115, 0.1)',
                    fill: true, tension: 0.4 
                }]
            },
            options: commonOptions
        });

        // Biểu đồ Cột: Sức khỏe (Tối giản)
        new Chart(document.getElementById('healthChart'), {
            type: 'bar',
            data: {
                labels: ['Tốt', 'Khá', 'Yếu'],
                datasets: [{ label: 'Số lượng', data: [45, 20, 10], backgroundColor: '#ff4757', borderRadius: 5 }]
            },
            options: commonOptions
        });
    </script>
</body>
</html>