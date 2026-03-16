<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
    <title>Thống kê hệ thống - TamCare</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f1f2f6; display: flex; margin: 0; }
        .sidebar { width: 250px; height: 100vh; background: #2f3542; color: white; position: fixed; }
        .main { margin-left: 250px; padding: 30px; width: 100%; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .chart-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        h2 { color: #2f3542; margin-top: 0; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2 style="padding: 20px;">🛡️ Admin</h2>
        <a href="admin" style="color: white; display: block; padding: 15px; text-decoration: none;">👥 Quản lý người dùng</a>
        <a href="admin-stats" style="color: #ff4757; display: block; padding: 15px; text-decoration: none; font-weight: bold;">📊 Thống kê hệ thống</a>
    </div>

    <div class="main">
        <h1>Báo cáo thống kê hệ thống</h1>

        <div class="grid">
            <div class="chart-card">
                <h3>Cơ cấu vai trò người dùng</h3>
                <canvas id="pieChart"></canvas>
            </div>

            <div class="chart-card">
                <h3>Tăng trưởng tài khoản mới</h3>
                <canvas id="lineChart"></canvas>
            </div>

            <div class="chart-card">
                <h3>Thống kê bệnh nền phổ biến</h3>
                <canvas id="barChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        // Dữ liệu giả định từ Server (Sau này bạn sẽ parse từ Map sang JS)
        // Biểu đồ Tròn
        new Chart(document.getElementById('pieChart'), {
            type: 'pie',
            data: {
                labels: ['Người già', 'Người chăm sóc', 'Quản trị'],
                datasets: [{
                    data: [45, 30, 5],
                    backgroundColor: ['#1e90ff', '#ffa502', '#2f3542']
                }]
            }
        });

        // Biểu đồ Đường (Chuỗi thời gian)
        new Chart(document.getElementById('lineChart'), {
            type: 'line',
            data: {
                labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4'],
                datasets: [{
                    label: 'Người dùng mới',
                    data: [10, 25, 45, 80],
                    borderColor: '#2ed573',
                    fill: false,
                    tension: 0.3
                }]
            }
        });

        // Biểu đồ Cột (Thống kê bệnh nền)
        new Chart(document.getElementById('barChart'), {
            type: 'bar',
            data: {
                labels: ['Tiểu đường', 'Huyết áp', 'Tim mạch', 'Xương khớp'],
                datasets: [{
                    label: 'Số ca ghi nhận',
                    data: [65, 40, 20, 55],
                    backgroundColor: '#ff4757'
                }]
            }
        });
    </script>
</body>
</html>