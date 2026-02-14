<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TamCare - Quản lý chăm sóc</title>
            <link rel="stylesheet" href="assets/css/style.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                body {
                    background-color: #f8fafc;
                    display: flex;
                    min-height: 100vh;
                }

                /* Sidebar */
                .sidebar {
                    width: 300px;
                    background: var(--white);
                    border-right: 2px solid #edf2f7;
                    padding: 40px 24px;
                    display: flex;
                    flex-direction: column;
                    position: fixed;
                    height: 100vh;
                }

                .sidebar-logo {
                    font-size: 28px;
                    font-weight: 700;
                    color: var(--primary);
                    margin-bottom: 50px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    text-decoration: none;
                }

                .sidebar-menu {
                    flex: 1;
                }

                .menu-link {
                    display: flex;
                    align-items: center;
                    gap: 16px;
                    padding: 16px 20px;
                    color: var(--text-muted);
                    text-decoration: none;
                    border-radius: 16px;
                    margin-bottom: 8px;
                    font-weight: 500;
                    transition: var(--transition);
                }

                .menu-link:hover,
                .menu-link.active {
                    background: var(--primary-light);
                    color: var(--primary);
                }

                .menu-link i {
                    font-size: 20px;
                    width: 24px;
                }

                /* Main */
                .main-content {
                    margin-left: 300px;
                    padding: 40px 60px;
                    width: calc(100% - 300px);
                }

                .dashboard-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 40px;
                }

                .stat-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 30px;
                    margin-bottom: 50px;
                }

                .stat-card-inner {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                }

                .stat-icon {
                    width: 64px;
                    height: 64px;
                    border-radius: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 28px;
                }

                .table-section {
                    background: var(--white);
                    border-radius: 24px;
                    padding: 30px;
                    box-shadow: var(--shadow-soft);
                }

                table {
                    width: 100%;
                    border-collapse: separate;
                    border-spacing: 0 12px;
                }

                th {
                    text-align: left;
                    padding: 10px 20px;
                    color: var(--text-muted);
                    font-weight: 600;
                }

                td {
                    padding: 24px 20px;
                    background: #fcfcfd;
                    border-top: 1px solid #f1f5f9;
                    border-bottom: 1px solid #f1f5f9;
                }

                td:first-child {
                    border-left: 1px solid #f1f5f9;
                    border-radius: 16px 0 0 16px;
                }

                td:last-child {
                    border-right: 1px solid #f1f5f9;
                    border-radius: 0 16px 16px 0;
                }

                .status-pill {
                    padding: 6px 16px;
                    border-radius: 30px;
                    font-size: 14px;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>
            <% User acc=(User) session.getAttribute("account"); if(acc==null) { response.sendRedirect("login.jsp");
                return; } %>

                <aside class="sidebar">
                    <a href="index.jsp" class="sidebar-logo">
                        <i class="fa-solid fa-hand-holding-heart"></i> TamCare
                    </a>
                    <nav class="sidebar-menu">
                        <a href="#" class="menu-link active"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
                        <a href="#" class="menu-link"><i class="fa-solid fa-users"></i> Người thân của tôi</a>
                        <a href="#" class="menu-link"><i class="fa-solid fa-capsules"></i> Lịch uống thuốc</a>
                        <a href="#" class="menu-link"><i class="fa-solid fa-bell"></i> Cảnh báo khẩn</a>
                        <a href="#" class="menu-link"><i class="fa-solid fa-calendar-alt"></i> Lịch hẹn thăm</a>
                    </nav>
                    <a href="logout" class="menu-link" style="color: var(--accent); margin-top: auto;">
                        <i class="fa-solid fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </aside>

                <main class="main-content">
                    <div class="dashboard-header animate-up">
                        <div>
                            <h1 style="font-size: 32px; color: var(--primary);">Xin chào, <%= acc.getFullName() %> 👋
                            </h1>
                            <p style="color: var(--text-muted);">Hôm nay bạn muốn kiểm tra tình trạng của ai?</p>
                        </div>
                        <a href="#" class="btn btn-primary"><i class="fa-solid fa-plus-circle"></i> Thêm Hồ Sơ Mới</a>
                    </div>

                    <div class="stat-grid">
                        <div class="card animate-up" style="animation-delay: 0.1s;">
                            <div class="stat-card-inner">
                                <div class="stat-icon" style="background: var(--primary-light); color: var(--primary);">
                                    <i class="fa-solid fa-user-check"></i>
                                </div>
                                <div>
                                    <p style="color: var(--text-muted); font-size: 14px;">Đang theo dõi</p>
                                    <h2 style="font-size: 28px;">02 Hồ sơ</h2>
                                </div>
                            </div>
                        </div>
                        <div class="card animate-up" style="animation-delay: 0.2s;">
                            <div class="stat-card-inner">
                                <div class="stat-icon" style="background: #fff5f2; color: var(--accent);">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                </div>
                                <div>
                                    <p style="color: var(--text-muted); font-size: 14px;">Cảnh báo mới</p>
                                    <h2 style="font-size: 28px; color: var(--accent);">01 Tin</h2>
                                </div>
                            </div>
                        </div>
                        <div class="card animate-up" style="animation-delay: 0.3s;">
                            <div class="stat-card-inner">
                                <div class="stat-icon" style="background: #f2fcf2; color: var(--secondary);">
                                    <i class="fa-solid fa-check-double"></i>
                                </div>
                                <div>
                                    <p style="color: var(--text-muted); font-size: 14px;">Uống thuốc hôm nay</p>
                                    <h2 style="font-size: 28px;">85% Xong</h2>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="table-section animate-up" style="animation-delay: 0.4s;">
                        <h3 style="margin-bottom: 24px; color: var(--primary);">📋 Cập nhật sức khỏe gần đây</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Người thân</th>
                                    <th>Chỉ số chính</th>
                                    <th>Trạng thái</th>
                                    <th>Cập nhật cuối</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight: 600;">Ông Nguyễn Văn A</td>
                                    <td>Huyết áp: 125/80</td>
                                    <td><span class="status-pill"
                                            style="background: #e6f7ef; color: #2d9d78;">Tốt</span></td>
                                    <td style="color: var(--text-muted);">10:15 Sáng nay</td>
                                    <td><a href="#" style="color: var(--primary); font-weight: 600;">Chi tiết</a></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: 600;">Bà Trần Thị B</td>
                                    <td>Nhịp tim: 88 bpm</td>
                                    <td><span class="status-pill" style="background: #fff9e6; color: #d9a016;">Cần chú
                                            ý</span></td>
                                    <td style="color: var(--text-muted);">08:30 Sáng nay</td>
                                    <td><a href="#" style="color: var(--primary); font-weight: 600;">Chi tiết</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </main>
        </body>

        </html>