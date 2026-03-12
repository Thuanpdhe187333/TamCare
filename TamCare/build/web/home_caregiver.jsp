<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TamCare - Quản lý chăm sóc người thân</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080;
            --primary-dark: #006666;
            --primary-light: #e6f2f2;
            --white: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --bg-body: #f1f5f9;
            --accent: #ef4444;
            --bonus-gold: #f39c12;
            --transition: all 0.3s ease;
            --sidebar-width: 280px;
            --shadow-soft: 0 4px 20px rgba(0,0,0,0.03);
        }

        /* --- GLOBAL --- */
        body {
            background-color: var(--bg-body);
            margin: 0;
            font-family: 'Lexend', sans-serif;
            display: flex;
            min-height: 100vh;
            color: var(--text-main);
        }

        /* --- NAVBAR --- */
        .navbar {
            height: 70px;
            background: var(--primary);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 40px;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1001;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            box-sizing: border-box;
            color: var(--white);
        }

        .navbar .logo {
            font-size: 26px;
            font-weight: 800;
            color: var(--white);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-actions { display: flex; align-items: center; gap: 20px; }

        /* NOTIFICATION */
        .noti-wrapper { position: relative; height: 100%; display: flex; align-items: center; }
        .noti-btn { 
            background: rgba(255, 255, 255, 0.15); color: white; border: none; 
            width: 40px; height: 40px; border-radius: 50%; cursor: pointer; 
            display: flex; align-items: center; justify-content: center; position: relative;
        }
        .noti-badge {
            position: absolute; top: -2px; right: -2px; background: var(--accent);
            color: white; font-size: 10px; padding: 2px 6px; border-radius: 10px; border: 2px solid var(--primary);
        }
        .noti-dropdown {
            position: absolute; top: 55px; right: 0; width: 320px;
            background: white; border-radius: 18px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            display: none; flex-direction: column; overflow: hidden; border: 1px solid #e2e8f0; animation: slideDown 0.3s ease;
        }
        .noti-wrapper:hover .noti-dropdown { display: flex; }
        .noti-item { padding: 15px; display: flex; gap: 12px; border-bottom: 1px solid #f1f5f9; text-decoration: none; transition: 0.2s; }
        .noti-item:hover { background: var(--primary-light); }

        /* --- SIDEBAR --- */
        .sidebar {
            width: var(--sidebar-width); background: var(--white);
            border-right: 2px solid #edf2f7; padding: 100px 24px 40px;
            display: flex; flex-direction: column; position: fixed; height: 100vh; box-sizing: border-box; z-index: 1000;
        }
        .sidebar-menu { flex: 1; }
        .menu-link {
            display: flex; align-items: center; gap: 16px; padding: 14px 20px;
            color: var(--text-muted); text-decoration: none; border-radius: 16px;
            margin-bottom: 8px; font-weight: 500; transition: var(--transition);
        }
        .menu-link:hover, .menu-link.active { background: var(--primary-light); color: var(--primary); }
        .menu-link.active { font-weight: 700; }
        .menu-link i { font-size: 20px; width: 24px; text-align: center; }

        .bonus-card {
            background: linear-gradient(135deg, #f1c40f, var(--bonus-gold));
            padding: 24px; border-radius: 24px; color: var(--white);
            margin-top: auto; margin-bottom: 20px; box-shadow: 0 8px 20px rgba(243, 156, 18, 0.2);
        }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: var(--sidebar-width); margin-top: 70px; padding: 40px 60px; width: calc(100% - var(--sidebar-width)); box-sizing: border-box; }
        
        .dashboard-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        
        /* Stat Grid */
        .stat-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; padding: 25px; border-radius: 24px; box-shadow: var(--shadow-soft); display: flex; align-items: center; gap: 20px; transition: 0.3s; }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon { width: 55px; height: 55px; border-radius: 18px; display: flex; align-items: center; justify-content: center; font-size: 24px; }

        /* Table Section */
        .table-section { background: var(--white); border-radius: 24px; padding: 35px; box-shadow: var(--shadow-soft); margin-bottom: 40px; }
        table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
        th { text-align: left; padding: 10px 20px; color: var(--text-muted); font-weight: 600; font-size: 14px; }
        td { padding: 20px; background: #fcfcfd; border-top: 1px solid #f1f5f9; border-bottom: 1px solid #f1f5f9; }
        td:first-child { border-left: 1px solid #f1f5f9; border-radius: 16px 0 0 16px; }
        td:last-child { border-right: 1px solid #f1f5f9; border-radius: 0 16px 16px 0; }

        .status-pill { padding: 6px 14px; border-radius: 30px; font-size: 13px; font-weight: 700; }

        /* Product Slider */
        .product-section { margin-bottom: 50px; }
        .product-row { display: flex; gap: 20px; overflow-x: auto; padding: 10px 5px; scrollbar-width: none; }
        .product-card { min-width: 240px; background: white; padding: 20px; border-radius: 24px; border: 1px solid #f1f5f9; text-align: center; transition: 0.3s; }
        .product-card:hover { border-color: var(--primary); transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.05); }

        /* --- TAMCARE AI COMPONENT --- */
        .ai-chat-trigger {
            position: fixed; bottom: 30px; right: 30px; width: 65px; height: 65px;
            background: var(--primary); color: white; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 8px 30px rgba(0, 128, 128, 0.4); cursor: pointer; z-index: 2000; transition: 0.4s;
        }
        .ai-chat-trigger:hover { transform: scale(1.1) rotate(5deg); background: var(--primary-dark); }
        
        .ai-chat-window {
            position: fixed; bottom: 110px; right: 30px; width: 400px; height: 550px;
            background: white; border-radius: 28px; box-shadow: 0 15px 60px rgba(0,0,0,0.2);
            display: none; flex-direction: column; overflow: hidden; z-index: 2001; border: 1px solid #e2e8f0; animation: slideUp 0.4s ease-out;
        }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        
        .ai-chat-header { background: var(--primary); color: white; padding: 20px 25px; display: flex; justify-content: space-between; align-items: center; }
        .ai-chat-body { flex: 1; padding: 25px; overflow-y: auto; background: #f8fbff; display: flex; flex-direction: column; gap: 15px; }
        .ai-msg { max-width: 85%; padding: 14px 18px; border-radius: 20px; font-size: 14px; line-height: 1.6; position: relative; }
        .ai-msg.bot { background: var(--white); color: var(--text-main); align-self: flex-start; border-bottom-left-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); }
        .ai-msg.user { background: var(--primary); color: white; align-self: flex-end; border-bottom-right-radius: 4px; }
        
        .ai-chat-footer { padding: 20px; background: white; border-top: 1px solid #f1f5f9; display: flex; gap: 12px; }
        .ai-input { flex: 1; border: 1px solid #e2e8f0; padding: 14px 18px; border-radius: 16px; outline: none; transition: 0.3s; font-family: inherit; }
        .ai-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(0, 128, 128, 0.1); }
        .ai-send-btn { background: var(--primary); color: white; border: none; width: 50px; height: 50px; border-radius: 16px; cursor: pointer; transition: 0.3s; }
        .ai-send-btn:hover { background: var(--primary-dark); }

        /* --- FOOTER --- */
        .footer {
            background: #1e293b; color: #94a3b8; padding: 80px 60px 40px 340px;
            display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 50px; margin-top: auto;
        }
        .footer h4 { color: white; margin-bottom: 25px; font-size: 18px; }
        .footer a { color: #94a3b8; text-decoration: none; display: block; margin-bottom: 12px; transition: 0.3s; }
        .footer a:hover { color: white; padding-left: 5px; }

        /* Animations */
        .animate-up { animation: fadeInUp 0.6s ease both; }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .btn-primary { background: var(--primary); color: white; padding: 14px 28px; border-radius: 16px; text-decoration: none; font-weight: 700; display: inline-flex; align-items: center; gap: 10px; transition: 0.3s; border: none; cursor: pointer; }
        .btn-primary:hover { background: var(--primary-dark); box-shadow: 0 8px 20px rgba(0, 128, 128, 0.2); }
    </style>
</head>

<body>
    <% 
        User acc = (User) session.getAttribute("account"); 
        if(acc == null) { response.sendRedirect("login.jsp"); return; } 
    %>

    <header class="navbar">
        <a href="index.jsp" class="logo">
            <i class="fa-solid fa-hand-holding-heart"></i> TamCare
        </a>

        <div class="header-actions">
            <div class="noti-wrapper">
                <button class="noti-btn">
                    <i class="fa-solid fa-bell"></i>
                    <span class="noti-badge">3</span>
                </button>
                <div class="noti-dropdown">
                    <div style="padding: 18px; background: #f8fafc; border-bottom: 1px solid #eee; font-weight: 700;">Thông báo mới</div>
                    <div class="noti-list">
                        <a href="#" class="noti-item">
                            <div style="width:10px; height:10px; background:var(--accent); border-radius:50%; margin-top:5px;"></div>
                            <div>
                                <p style="margin:0; font-size:14px;">Cảnh báo: Nhịp tim <b>Ông A</b> bất thường</p>
                                <small style="color:var(--text-muted);">10 phút trước</small>
                            </div>
                        </a>
                        <a href="#" class="noti-item">
                            <div style="width:10px; height:10px; background:var(--primary); border-radius:50%; margin-top:5px;"></div>
                            <div>
                                <p style="margin:0; font-size:14px;"><b>Bà B</b> đã uống thuốc buổi trưa</p>
                                <small style="color:var(--text-muted);">1 giờ trước</small>
                            </div>
                        </a>
                    </div>
                    <a href="notifications.jsp" style="display:block; padding:15px; text-align:center; color:var(--primary); text-decoration:none; font-weight:700; font-size:14px; background:#f1f5f9;">Xem tất cả</a>
                </div>
            </div>

            <div style="display: flex; align-items: center; gap: 15px; cursor: pointer;" onclick="window.location.href='profile_caregiver.jsp'">
                <div style="text-align: right;">
                    <span style="font-weight: 700; display: block; font-size: 15px;"><%= acc.getFullName() %></span>
                    <small style="opacity: 0.8; font-size: 11px; text-transform: uppercase;">Người chăm sóc</small>
                </div>
                <div style="width: 42px; height: 42px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; border: 1px solid rgba(255,255,255,0.3);">
                    <i class="fa-solid fa-user-tie"></i>
                </div>
            </div>
        </div>
    </header>

    <aside class="sidebar">
        <nav class="sidebar-menu">
            <a href="home_caregiver.jsp" class="menu-link active"><i class="fa-solid fa-chart-pie"></i> Tổng quan</a>
            <a href="my_relatives.jsp" class="menu-link"><i class="fa-solid fa-users"></i> Hồ sơ gia đình</a>
            <a href="products.jsp" class="menu-link"><i class="fa-solid fa-cart-shopping"></i> Cửa hàng y tế</a>
            <a href="blog.jsp" class="menu-link"><i class="fa-solid fa-newspaper"></i> Blog sức khỏe</a>
            <a href="about.jsp" class="menu-link"><i class="fa-solid fa-circle-info"></i> About us</a>
            <a href="profile_caregiver.jsp" class="menu-link"><i class="fa-solid fa-user-gear"></i> Trang cá nhân</a>
        </nav>

        <div class="bonus-card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                <i class="fa-solid fa-coins" style="font-size: 24px;"></i>
                <span style="font-size: 11px; font-weight: 800; background: rgba(255,255,255,0.2); padding: 3px 10px; border-radius: 20px;">BONUS</span>
            </div>
            <div style="margin-top: 15px;">
                <small style="opacity: 0.9; font-size: 12px;">Điểm thưởng tích lũy</small>
                <h2 style="margin: 5px 0 0 0; font-size: 28px;">1.250 <span style="font-size: 14px; font-weight: 400;">pts</span></h2>
            </div>
        </div>

        <a href="logout" class="menu-link" style="color: var(--accent); margin-top: 20px;">
            <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
        </a>
    </aside>

    <main class="main-content">
        <div class="dashboard-header animate-up">
            <div>
                <h1 style="font-size: 32px; margin: 0; color: var(--primary);">Xin chào, <%= acc.getFullName() %> 👋</h1>
                <p style="color: var(--text-muted); margin-top: 10px; font-size: 16px;">Hôm nay người thân của bạn thế nào?</p>
            </div>
            <a href="my_relatives.jsp" class="btn-primary"><i class="fa-solid fa-plus-circle"></i> Kết nối hồ sơ mới</a>
        </div>

        <div class="stat-grid">
            <div class="stat-card animate-up" style="animation-delay: 0.1s;">
                <div class="stat-icon" style="background: var(--primary-light); color: var(--primary);"><i class="fa-solid fa-user-check"></i></div>
                <div>
                    <p style="color: var(--text-muted); font-size: 14px; margin: 0;">Đang theo dõi</p>
                    <h2 style="margin: 5px 0 0; font-size: 24px;">02 Người thân</h2>
                </div>
            </div>
            <div class="stat-card animate-up" style="animation-delay: 0.2s;">
                <div class="stat-icon" style="background: #fff5f2; color: var(--accent);"><i class="fa-solid fa-triangle-exclamation"></i></div>
                <div>
                    <p style="color: var(--text-muted); font-size: 14px; margin: 0;">Cảnh báo mới</p>
                    <h2 style="margin: 5px 0 0; font-size: 24px; color: var(--accent);">01 Tin khẩn</h2>
                </div>
            </div>
            <div class="stat-card animate-up" style="animation-delay: 0.3s;">
                <div class="stat-icon" style="background: #f2fcf2; color: #16a34a;"><i class="fa-solid fa-check-double"></i></div>
                <div>
                    <p style="color: var(--text-muted); font-size: 14px; margin: 0;">Lịch uống thuốc</p>
                    <h2 style="margin: 5px 0 0; font-size: 24px;">85% Hoàn thành</h2>
                </div>
            </div>
        </div>

        <div class="table-section animate-up" style="animation-delay: 0.4s;">
            <h3 style="margin-top: 0; color: var(--primary); margin-bottom: 25px;"><i class="fa-solid fa-notes-medical"></i> Cập nhật sức khỏe gần đây</h3>
            <table>
                <thead>
                    <tr>
                        <th>Người thân</th>
                        <th>Chỉ số quan trọng</th>
                        <th>Trạng thái</th>
                        <th>Thời gian</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="font-weight: 700; color: var(--text-main);">Ông Nguyễn Văn A</td>
                        <td>Huyết áp: 125/80 mmHg</td>
                        <td><span class="status-pill" style="background: #e6f7ef; color: #16a34a;">Ổn định</span></td>
                        <td style="color: var(--text-muted);">10:15 Sáng nay</td>
                        <td><a href="#" style="color: var(--primary); font-weight: 700; text-decoration: none;">Chi tiết</a></td>
                    </tr>
                    <tr>
                        <td style="font-weight: 700; color: var(--text-main);">Bà Trần Thị B</td>
                        <td>Nhịp tim: 88 bpm</td>
                        <td><span class="status-pill" style="background: #fff9e6; color: #d9a016;">Cần chú ý</span></td>
                        <td style="color: var(--text-muted);">08:30 Sáng nay</td>
                        <td><a href="#" style="color: var(--primary); font-weight: 700; text-decoration: none;">Chi tiết</a></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="product-section animate-up" style="animation-delay: 0.5s;">
            <h3 style="color: var(--primary); margin-bottom: 20px;"><i class="fa-solid fa-store"></i> Thiết bị y tế đề xuất</h3>
            <div class="product-row">
                <div class="product-card">
                    <div style="width:100%; height:140px; background:#f8fafc; border-radius:15px; margin-bottom:15px; display:flex; align-items:center; justify-content:center;">
                        <i class="fa-solid fa-heart-pulse fa-3x" style="color:var(--primary);"></i>
                    </div>
                    <h4 style="margin:10px 0; font-size:16px;">Máy đo huyết áp Omron</h4>
                    <p style="color:var(--primary); font-weight:700;">1.250.000₫</p>
                </div>
                <div class="product-card">
                    <div style="width:100%; height:140px; background:#f8fafc; border-radius:15px; margin-bottom:15px; display:flex; align-items:center; justify-content:center;">
                        <i class="fa-solid fa-droplet fa-3x" style="color:#ef4444;"></i>
                    </div>
                    <h4 style="margin:10px 0; font-size:16px;">Máy đo đường huyết</h4>
                    <p style="color:var(--primary); font-weight:700;">850.000₫</p>
                </div>
                <div class="product-card">
                    <div style="width:100%; height:140px; background:#f8fafc; border-radius:15px; margin-bottom:15px; display:flex; align-items:center; justify-content:center;">
                        <i class="fa-solid fa-wheelchair fa-3x" style="color:var(--bonus-gold);"></i>
                    </div>
                    <h4 style="margin:10px 0; font-size:16px;">Xe lăn Haruka</h4>
                    <p style="color:var(--primary); font-weight:700;">2.400.000₫</p>
                </div>
            </div>
        </div>
    </main>

    <div class="ai-chat-trigger" onclick="toggleAIChat()">
        <i class="fa-solid fa-robot fa-xl"></i>
    </div>

    <div class="ai-chat-window" id="aiChatWindow">
        <div class="ai-chat-header">
            <div style="display: flex; align-items: center; gap: 12px;">
                <i class="fa-solid fa-robot"></i>
                <span style="font-weight: 800; font-size: 16px;">TamCare AI Assistant</span>
            </div>
            <i class="fa-solid fa-xmark" style="cursor: pointer; font-size: 20px;" onclick="toggleAIChat()"></i>
        </div>
        <div class="ai-chat-body" id="chatBody">
            <div class="ai-msg bot">
                Chào bạn! Tôi là trợ lý AI của TamCare. Tôi có thể giúp bạn giải đáp các thắc mắc về sức khỏe người già hoặc cách sử dụng thiết bị y tế.
            </div>
        </div>
        <div class="ai-chat-footer">
            <input type="text" class="ai-input" id="chatInput" placeholder="Hỏi AI về sức khỏe..." onkeypress="handleEnter(event)">
            <button class="ai-send-btn" onclick="sendMessage()"><i class="fa-solid fa-paper-plane"></i></button>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-col">
            <h2 style="color: white; margin: 0 0 20px;">TamCare</h2>
            <p style="line-height: 1.8;">Giải pháp công nghệ kết nối tình thân, chăm sóc sức khỏe người cao tuổi bằng sự thấu hiểu và yêu thương.</p>
        </div>
        <div class="footer-col">
            <h4>Khám phá</h4>
            <a href="about.jsp">Về chúng tôi</a>
            <a href="blog.jsp">Blog sức khỏe</a>
            <a href="products.jsp">Cửa hàng y tế</a>
        </div>
        <div class="footer-col">
            <h4>Hỗ trợ</h4>
            <a href="#">Điều khoản sử dụng</a>
            <a href="#">Chính sách bảo mật</a>
            <a href="#">Câu hỏi thường gặp</a>
        </div>
        <div class="footer-col">
            <h4>Liên hệ</h4>
            <p><i class="fa-solid fa-phone"></i> 1900 1234</p>
            <p><i class="fa-solid fa-envelope"></i> support@tamcare.vn</p>
            <div style="display: flex; gap: 15px; margin-top: 20px; font-size: 24px;">
                <i class="fa-brands fa-facebook"></i>
                <i class="fa-brands fa-youtube"></i>
            </div>
        </div>
    </footer>

    <script>
        function toggleAIChat() {
            const chat = document.getElementById('aiChatWindow');
            chat.style.display = (chat.style.display === 'flex') ? 'none' : 'flex';
        }

        function handleEnter(e) { if (e.key === 'Enter') sendMessage(); }

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const body = document.getElementById('chatBody');
            if (input.value.trim() !== "") {
                const userMsg = document.createElement('div');
                userMsg.className = 'ai-msg user';
                userMsg.innerText = input.value;
                body.appendChild(userMsg);
                
                const val = input.value;
                input.value = "";
                body.scrollTop = body.scrollHeight;

                // Giả lập bot trả lời
                setTimeout(() => {
                    const botMsg = document.createElement('div');
                    botMsg.className = 'ai-msg bot';
                    botMsg.innerText = "Đang phân tích yêu cầu về '" + val + "'... Vui lòng kết nối API AI để nhận câu trả lời chính xác!";
                    body.appendChild(botMsg);
                    body.scrollTop = body.scrollHeight;
                }, 800);
            }
        }
    </script>
</body>

</html>