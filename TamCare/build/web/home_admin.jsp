<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.User"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare Admin - Tối ưu giao diện</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --primary: #3498db; --bg: #f0f2f5; --dark: #2c3e50; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); margin: 0; display: flex; }
        
        .sidebar { width: 240px; height: 100vh; background: var(--dark); color: white; position: fixed; }
        .sidebar a { display: block; padding: 15px 20px; color: #adb5bd; text-decoration: none; border-left: 4px solid transparent; }
        .sidebar a.active { background: #34495e; color: white; border-left-color: var(--primary); }

        .main { margin-left: 240px; padding: 25px; width: 100%; }
        
        /* Layout Thống kê thu nhỏ */
        .stats-row { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); /* Chia 3 cột đều nhau */
            gap: 20px; 
            margin-bottom: 25px; 
        }
        
        .chart-box { 
            background: white; 
            padding: 15px; 
            border-radius: 12px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            height: 250px; /* Thu nhỏ chiều cao biểu đồ */
        }
        .chart-box h3 { font-size: 15px; margin: 0 0 10px; color: #6c757d; text-align: center; }

        /* Table Area */
        .table-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #f0f2f5; color: #495057; font-size: 14px; }
        td { padding: 12px; border-bottom: 1px solid #f0f2f5; font-size: 14px; }

        .btn-add { background: var(--primary); color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; font-size: 14px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2 style="text-align: center; padding: 20px 0;">🛡️ Admin</h2>
        <a href="admin-stats" class="active">📊 Tổng quan</a>
        <a href="logout">🚪 Đăng xuất</a>
    </div>

    <div class="main">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="margin: 0;">Bảng điều khiển quản trị</h2>
            <a href="register.jsp" class="btn-add">+ Thêm User</a>
        </div>

        <div class="stats-row">
            <div class="chart-box">
                <h3>Cơ cấu vai trò</h3>
                <canvas id="roleChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>Tăng trưởng (Chuỗi)</h3>
                <canvas id="growthChart"></canvas>
            </div>
            <div class="chart-box">
                <h3>Thống kê bệnh nền</h3>
                <canvas id="healthChart"></canvas>
            </div>
        </div>

        <div class="table-card">
            <h3 style="margin-top: 0;">Danh sách người dùng mới nhất</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và Tên</th>
                        <th>Vai trò</th>
                        <th>Email</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Lặp dữ liệu List<User> --%>
                    <tr>
                        <td>#101</td>
                        <td><b>Nguyễn Văn An</b></td>
                        <td><span style="color: #3498db">Elderly</span></td>
                        <td>an@gmail.com</td>
                        <td><a href="#" style="color: #3498db; text-decoration: none;">Chi tiết</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Cấu hình chung để thu nhỏ biểu đồ
        const options = {
            responsive: true,
            maintainAspectRatio: false, // Quan trọng để thu nhỏ theo div cha
            plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 11 } } } }
        };

        // 1. Biểu đồ tròn thu nhỏ
        new Chart(document.getElementById('roleChart'), {
            type: 'doughnut',
            data: {
                labels: ['Già', 'Trẻ'],
                datasets: [{ data: [70, 30], backgroundColor: ['#3498db', '#ffa502'] }]
            },
            options: options
        });

        // 2. Biểu đồ đường thu nhỏ
        new Chart(document.getElementById('growthChart'), {
            type: 'line',
            data: {
                labels: ['T1', 'T2', 'T3', 'T4'],
                datasets: [{ label: 'User', data: [5, 15, 10, 25], borderColor: '#2ecc71', tension: 0.4 }]
            },
            options: options
        });

        // 3. Biểu đồ cột thu nhỏ
        new Chart(document.getElementById('healthChart'), {
            type: 'bar',
            data: {
                labels: ['HA', 'TĐ', 'TM'],
                datasets: [{ label: 'Số ca', data: [12, 19, 8], backgroundColor: '#e74c3c' }]
            },
            options: options
        });
    </script>
</body>
</html>