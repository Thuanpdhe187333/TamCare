<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="model.User" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TamCare - Vì sức khỏe người cao tuổi</title>
            <link rel="stylesheet" href="assets/css/style.css">
            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .hero {
                    padding: 80px 0;
                    background: linear-gradient(135deg, #f0f7f7 0%, #ffffff 100%);
                    border-radius: 0 0 50px 50px;
                }

                .hero-flex {
                    display: flex;
                    align-items: center;
                    gap: 60px;
                }

                .hero-text {
                    flex: 1.2;
                }

                .hero-image {
                    flex: 0.8;
                    text-align: center;
                }

                .hero-text h1 {
                    font-size: 52px;
                    line-height: 1.2;
                    color: var(--primary);
                    margin-bottom: 24px;
                }

                .hero-text p {
                    font-size: 22px;
                    color: var(--text-muted);
                    margin-bottom: 40px;
                }

                .mission-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 30px;
                    margin-top: -60px;
                    position: relative;
                    z-index: 10;
                }

                .mission-card {
                    text-align: center;
                    padding: 50px 30px;
                }

                .mission-card i {
                    font-size: 48px;
                    color: var(--accent);
                    margin-bottom: 24px;
                    background: rgba(255, 138, 101, 0.1);
                    width: 90px;
                    height: 90px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 25px;
                    margin-left: auto;
                    margin-right: auto;
                }

                .mission-card h3 {
                    font-size: 22px;
                    margin-bottom: 15px;
                    color: var(--primary);
                }

                .footer {
                    margin-top: 100px;
                    padding: 60px 0;
                    background: var(--text-dark);
                    color: var(--white);
                    border-radius: 50px 50px 0 0;
                }

                .footer p {
                    color: rgba(255, 255, 255, 0.7);
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
                            <i class="fa-solid fa-user-gear"></i> Vào Trang Quản Lý
                        </a>
                        <% } else { %>
                            <a href="login.jsp" class="btn btn-secondary">Đăng Nhập</a>
                            <a href="register.jsp" class="btn btn-primary" style="margin-left: 15px;">Mở Tài Khoản
                                Mới</a>
                            <% } %>
                </div>
            </nav>

            <header class="hero">
                <div class="container hero-flex animate-up">
                    <div class="hero-text">
                        <h1>Chăm sóc sức khỏe<br><span style="white-space: nowrap;"></span>với trọn niềm yêu
                            thương</span></h1>
                        <p>Nền tảng công nghệ dành riêng cho người cao tuổi, mang lại sự an tâm tuyệt đối cho con cháu
                            qua việc theo dõi và hỗ trợ y tế thông minh.</p>
                        <div class="btn-group">
                            <a href="register.jsp" class="btn btn-primary">Bắt đầu miễn phí <i
                                    class="fa-solid fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="hero-image">
                        <img src="https://images.unsplash.com/photo-1516703724594-826330ce123a?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80"
                            alt="Elderly Care"
                            style="width: 100%; border-radius: 40px; box-shadow: var(--shadow-bold);">
                    </div>
                </div>
            </header>

            <section class="container" style="padding-bottom: 80px;">
                <div class="mission-grid">
                    <div class="card mission-card">
                        <i class="fa-solid fa-person-walking-with-cane"></i>
                        <h3>Tự chủ sức khỏe</h3>
                        <p>Giúp người cao tuổi tự chủ và chủ động hơn trong việc theo dõi, chăm sóc sức khỏe bản thân
                            hàng ngày.</p>
                    </div>
                    <div class="card mission-card">
                        <i class="fa-solid fa-heart-pulse"></i>
                        <h3>Theo dõi liên tục</h3>
                        <p>Hệ thống giám sát các chỉ số sức khỏe 24/7, phát hiện sớm các dấu hiệu bất thường để xử lý
                            kịp thời.</p>
                    </div>
                    <div class="card mission-card">
                        <i class="fa-solid fa-pills"></i>
                        <h3>Nhắc nhở dùng thuốc</h3>
                        <p>Hỗ trợ quản lý lịch trình và tự động nhắc nhở uống thuốc đúng giờ, đúng liều lượng mỗi ngày.
                        </p>
                    </div>
                </div>
            </section>

            <section class="container" style="text-align: center; padding: 60px 0;">
                <h2 style="font-size: 36px; color: var(--primary); margin-bottom: 20px;">Sứ mệnh của TamCare</h2>
                <p style="max-width: 800px; margin: 0 auto; color: var(--text-muted);">Chúng tôi tin rằng công nghệ chỉ
                    thực sự có ý nghĩa khi nó mang lại hơi ấm và sự an tâm. TamCare là cầu nối yêu thương giữa các thế
                    hệ trong gia đình.</p>
            </section>

            <footer class="footer">
                <div class="container" style="text-align: center;">
                    <div style="font-size: 32px; font-weight: 700; margin-bottom: 20px;">👴 TamCare</div>
                    <p>© 2026 TamCare Project. Một dự án vì cộng đồng người cao tuổi.</p>
                    <div style="margin-top: 20px; font-size: 24px; display: flex; justify-content: center; gap: 20px;">
                        <i class="fa-brands fa-facebook-f"></i>
                        <i class="fa-brands fa-youtube"></i>
                        <i class="fa-brands fa-envelope"></i>
                    </div>
                </div>
            </footer>

        </body>

        </html>