<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%> 
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare - Quản lý chăm sóc</title>
    <style>
        /* GIAO DIỆN QUẢN LÝ - DASHBOARD STYLE */
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; display: flex; }
        
        .sidebar { width: 250px; background-color: #2c3e50; color: white; height: 100vh; padding: 20px; position: fixed; }
        .sidebar h2 { color: #3498db; text-align: center; }
        .menu a { display: block; padding: 15px; color: #ecf0f1; text-decoration: none; border-bottom: 1px solid #34495e; }
        .menu a:hover { background-color: #34495e; border-left: 4px solid #3498db; }
        
        .main { margin-left: 290px; padding: 30px; width: 100%; }
        
        .stat-cards { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { flex: 1; background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .card h3 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .card .number { font-size: 32px; font-weight: bold; color: #2c3e50; margin: 10px 0; }
        
        .table-container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; color: #333; }
        
        .status-ok { color: green; font-weight: bold; }
        .status-warning { color: orange; font-weight: bold; }
        
        .btn-add { background-color: #3498db; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; float: right; }
    </style>
</head>
<body>
    <% User acc = (User) session.getAttribute("account"); if(acc == null) { response.sendRedirect("login.jsp"); return; } %>

    <div class="sidebar">
        <h2>👨‍⚕️ Caregiver Panel</h2>
        <div class="menu">
            <a href="#">📊 Tổng quan</a>
            <a href="#">👥 Danh sách người thân</a>
            <a href="#">💊 Lịch thuốc</a>
            <a href="#">🔔 Cảnh báo (Alerts)</a>
            <a href="logout" style="color: #e74c3c;">🚪 Đăng xuất</a>
        </div>
    </div>

    <div class="main">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <h1>Xin chào, <%= acc.getFullName() %></h1>
            <a href="#" class="btn-add">+ Thêm hồ sơ người thân</a>
        </div>
        
        <div class="stat-cards">
            <div class="card">
                <h3>Người thân đang theo dõi</h3>
                <div class="number">2</div>
            </div>
            <div class="card">
                <h3>Cảnh báo sức khỏe</h3>
                <div class="number" style="color: orange;">1</div>
            </div>
            <div class="card">
                <h3>Lịch nhắc thuốc</h3>
                <div class="number">Hoàn thành 80%</div>
            </div>
        </div>

        <div class="table-container">
            <h3>📋 Tình trạng người thân hôm nay</h3>
            <table>
                <thead>
                    <tr>
                        <th>Họ tên</th>
                        <th>Tuổi</th>
                        <th>Tình trạng sức khỏe</th>
                        <th>Cập nhật lần cuối</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Nguyễn Văn A (Bố)</td>
                        <td>72</td>
                        <td class="status-ok">Ổn định (BMI: 22.1)</td>
                        <td>Hôm nay, 08:30</td>
                        <td><a href="#">Xem chi tiết</a></td>
                    </tr>
                    <tr>
                        <td>Trần Thị B (Mẹ)</td>
                        <td>68</td>
                        <td class="status-warning">⚠️ Huyết áp hơi cao</td>
                        <td>Hôm qua, 18:00</td>
                        <td><a href="#">Xem chi tiết</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>