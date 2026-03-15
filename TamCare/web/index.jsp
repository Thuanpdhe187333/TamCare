<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TamCare - Vì sức khỏe người cao tuổi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            /* Hệ màu mới: Xanh dương nhạt và Xanh chuyên nghiệp */
            --primary: #2c5282;
            --primary-light: #e0effa;
            --accent: #4299e1;
            --white: #ffffff;
            --text-dark: #1a365d;
            --text-muted: #64748b;
            --bg-body: #f8fafc;
            --shadow-soft: 0 10px 25px rgba(44, 82, 130, 0.1);
        }

        body {
            font-family: 'Lexend', sans-serif;
            background-color: var(--bg-body);
            margin: 0;
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* --- NAVIGATION --- */
        .nav-bar {
            height: 90px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: transparent;
        }

        .logo {
            font-size: 28px;
            font-weight: 800;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 15px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(44, 82, 130, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            background: var(--text-dark);
        }

        .btn-secondary {
            color: var(--primary);
            background: var(--primary-light);
        }

        /* --- HERO SECTION --- */
        .hero {
            padding: 80px 0 140px 0;
            background: linear-gradient(180deg, var(--primary-light) 0%, var(--bg-body) 100%);
            border-radius: 0 0 80px 80px;
        }

        .hero-flex {
            display: flex;
            align-items: center;
            gap: 60px;
        }

        .hero-text { flex: 1.2; }
        .hero-image { flex: 0.8; }

        .hero-text h1 {
            font-size: 56px;
            font-weight: 800;
            line-height: 1.1;
            color: var(--primary);
            margin-bottom: 24px;
        }

        .hero-text p {
            font-size: 20px;
            color: var(--text-muted);
            margin-bottom: 40px;
            max-width: 90%;
        }

        /* --- MISSION CARDS --- */
        .mission-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: -80px;
            position: relative;
            z-index: 10;
        }

        .card {
            background: var(--white);
            border-radius: 35px;
            padding: 45px 35px;
            box-shadow: var(--shadow-soft);
            border: 1px solid rgba(224, 239, 250, 0.5);
            transition: transform 0.3s ease;
        }

        .card:hover { transform: translateY(-10px); }

        .mission-card i {
            font-size: 40px;
            color: var(--primary);
            background: var(--primary-light);
            width: 85px;
            height: 85px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 25px;
            margin-bottom: 25px;
        }

        .mission-card h3 {
            font-size: 24px;
            margin-bottom: 15px;
            color: var(--primary);
        }

        /* --- FOOTER --- */
        .footer {
            margin-top: 100px;
            padding: 80px 0 40px 0;
            background: var(--primary);
            color: var(--white);
            border-radius: 60px 60px 0 0;
        }

        .footer p { color: var(--primary-light); opacity: 0.8; }

        .footer-logo {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 25px;
            display: block;
        }

        .social-links {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 25px;
            font-size: 24px;
        }

        .social-links i:hover { color: var(--primary-light); cursor: pointer; }

        .animate-up {
            animation: fadeInUp 0.8s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body>

    <nav class="nav-bar container">
        <a href="index.jsp" class="logo">
            <i class="fa-solid fa-hand-holding-heart"></i> TamCare
        </a>
        <div class="nav-links">
            <% User acc=(User) session.getAttribute("account"); if (acc !=null) { %>
                <a href="home_caregiver.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-user-gear"></i> Trang Quản Lý
                </a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-secondary">Đăng Nhập</a>
                <a href="register.jsp" class="btn btn-primary" style="margin-left: 15px;">Đăng Ký Ngay</a>
            <% } %>
        </div>
    </nav>

    <header class="hero">
        <div class="container hero-flex animate-up">
            <div class="hero-text">
                <h1>Chăm sóc sức khỏe<br><span style="color: var(--accent);">với trọn niềm yêu thương</span></h1>
                <p>Nền tảng công nghệ dành riêng cho người cao tuổi, mang lại sự an tâm tuyệt đối qua việc theo dõi y tế thông minh.</p>
                <div class="btn-group">
                    <a href="register.jsp" class="btn btn-primary">Bắt đầu ngay <i class="fa-solid fa-arrow-right"></i></a>
                </div>
            </div>
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                    alt="Elderly Care"
                    style="width: 100%; border-radius: 50px; box-shadow: 20px 20px 60px rgba(44, 82, 130, 0.2);">
            </div>
        </div>
    </header>

    <section class="container">
        <div class="mission-grid animate-up">
            <div class="card mission-card">
                <i class="fa-solid fa-person-walking-with-cane"></i>
                <h3>Tự chủ sức khỏe</h3>
                <p>Giúp người cao tuổi chủ động hơn trong việc theo dõi và chăm sóc sức khỏe hàng ngày một cách dễ dàng.</p>
            </div>
            <div class="card mission-card">
                <i class="fa-solid fa-heart-pulse"></i>
                <h3>Theo dõi liên tục</h3>
                <p>Giám sát chỉ số sức khỏe 24/7, phát hiện sớm các dấu hiệu bất thường để hỗ trợ kịp thời.</p>
            </div>
            <div class="card mission-card">
                <i class="fa-solid fa-pills"></i>
                <h3>Nhắc nhở y tế</h3>
                <p>Hỗ trợ quản lý lịch trình và tự động nhắc nhở uống thuốc đúng giờ, đúng liều lượng mỗi ngày.</p>
            </div>
        </div>
    </section>

    <section class="container" style="text-align: center; padding: 100px 0;">
        <h2 style="font-size: 42px; color: var(--primary); margin-bottom: 25px; font-weight: 800;">Sứ mệnh của TamCare</h2>
        <p style="max-width: 800px; margin: 0 auto; color: var(--text-muted); font-size: 18px;">Chúng tôi tin rằng công nghệ chỉ thực sự có ý nghĩa khi nó mang lại hơi ấm và sự an tâm. TamCare là cầu nối yêu thương giữa các thế hệ trong gia đình.</p>
    </section>

    <footer class="footer">
        <div class="container" style="text-align: center;">
            <span class="footer-logo">👵 TamCare</span>
            <p>© 2026 TamCare Project. Nền tảng chăm sóc sức khỏe nhân văn.</p>
            <div class="social-links">
                <i class="fa-brands fa-facebook"></i>
                <i class="fa-brands fa-youtube"></i>
                <i class="fa-solid fa-envelope"></i>
            </div>
        </div>
    </footer>

</body>
</html>