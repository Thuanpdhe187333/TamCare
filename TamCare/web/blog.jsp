<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User acc = (User) session.getAttribute("account");
    String userName = (acc != null) ? acc.getFullName() : "Khách";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare Blog - Kiến thức sức khỏe người cao tuổi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080;
            --primary-dark: #006666;
            --primary-light: #e6f2f2;
            --white: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --bg-body: #f5f7f9;
        }

        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 120px; }

        /* 1. HEADER (Đồng bộ mẫu Shopee/TamCare) */
        .header-fixed {
            background: linear-gradient(-180deg, var(--primary), var(--primary-dark));
            position: fixed; top: 0; width: 100%; z-index: 1002; padding-bottom: 10px;
        }
        .header-top-bar { max-width: 1200px; margin: 0 auto; display: flex; justify-content: flex-end; padding: 5px 20px; gap: 20px; font-size: 13px; color: white; }
        .header-main { max-width: 1200px; margin: 0 auto; display: flex; align-items: center; padding: 10px 20px; gap: 40px; }
        .logo { font-size: 30px; font-weight: 800; color: white; text-decoration: none; }
        .nav-links { display: flex; gap: 25px; }
        .nav-links a { color: white; text-decoration: none; font-weight: 500; font-size: 15px; }
        .nav-links a:hover { opacity: 0.8; }

        /* 2. BANNER / PAGE TITLE */
        .blog-banner {
            background: var(--white); border-bottom: 1px solid #e2e8f0;
            padding: 40px 0; margin-bottom: 30px; text-align: center;
        }
        .breadcrumb { font-size: 14px; color: var(--text-muted); margin-bottom: 10px; }
        .breadcrumb a { color: var(--primary); text-decoration: none; }

        /* LAYOUT CHÍNH */
        .main-container { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr 350px; gap: 30px; padding: 0 20px 60px; }

        /* 3. MAIN CONTENT (Blog Posts) */
        .blog-card {
            background: var(--white); border-radius: 20px; overflow: hidden;
            margin-bottom: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); transition: 0.3s;
        }
        .blog-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.07); }
        .blog-img { width: 100%; height: 300px; background: #eee; display: flex; align-items: center; justify-content: center; font-size: 60px; color: #cbd5e1; }
        .blog-card-body { padding: 30px; }
        .blog-tag { background: var(--primary-light); color: var(--primary); padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .blog-title { font-size: 26px; margin: 15px 0; line-height: 1.4; color: var(--text-main); }
        .blog-meta { font-size: 14px; color: var(--text-muted); display: flex; gap: 20px; margin-bottom: 15px; }
        .blog-excerpt { color: #475569; line-height: 1.8; margin-bottom: 20px; }
        .btn-readmore { 
            display: inline-block; padding: 12px 25px; background: var(--primary); color: white; 
            text-decoration: none; border-radius: 12px; font-weight: 600; transition: 0.3s;
        }
        .btn-readmore:hover { background: var(--primary-dark); padding-right: 35px; }

        /* 4. SIDEBAR */
        .sidebar-widget { background: var(--white); border-radius: 20px; padding: 25px; margin-bottom: 25px; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }
        .widget-title { font-size: 18px; font-weight: 700; margin-bottom: 20px; border-left: 4px solid var(--primary); padding-left: 15px; }
        .search-box { display: flex; gap: 5px; }
        .search-box input { flex: 1; padding: 12px; border: 1px solid #e2e8f0; border-radius: 10px; outline: none; }
        .category-list { list-style: none; padding: 0; }
        .category-list li { padding: 10px 0; border-bottom: 1px dotted #e2e8f0; }
        .category-list a { text-decoration: none; color: var(--text-main); font-size: 15px; display: flex; justify-content: space-between; }
        .category-list a:hover { color: var(--primary); }

        /* 5. PAGINATION */
        .pagination { display: flex; gap: 10px; justify-content: center; margin-top: 20px; }
        .page-item { width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; border-radius: 10px; background: white; color: var(--text-main); text-decoration: none; font-weight: 600; transition: 0.3s; }
        .page-item.active { background: var(--primary); color: white; }
        .page-item:hover:not(.active) { background: var(--primary-light); color: var(--primary); }

        /* 6. FOOTER */
        .footer { background: #1e293b; color: #94a3b8; padding: 60px 40px 20px; margin-top: auto; }
        .footer-grid { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1fr 1.5fr; gap: 40px; }
        .footer-col h4 { color: white; margin-bottom: 25px; }
        .footer-col a { color: #94a3b8; text-decoration: none; display: block; margin-bottom: 12px; font-size: 14px; }
        .footer-col a:hover { color: white; }
    </style>
</head>
<body>

    <div class="header-fixed">
        <div class="header-top-bar">
            <span>Hỗ trợ 24/7</span>
            <span>Chào, <%= userName %></span>
        </div>
        <header class="header-main">
            <a href="home_caregiver.jsp" class="logo">TamCare</a>
            <nav class="nav-links">
                <a href="home_caregiver.jsp">Tổng quan</a>
                <a href="products.jsp">Cửa hàng</a>
                <a href="blog.jsp" style="border-bottom: 2px solid white;">Tin tức</a>
                <a href="about.jsp">Giới thiệu</a>
            </nav>
        </header>
    </div>

    <div class="blog-banner">
        <div class="breadcrumb"><a href="home_caregiver.jsp">Trang chủ</a> > Blog</div>
        <h1 style="font-size: 36px; margin: 0;">Tin tức & Kiến thức sức khỏe</h1>
        <p style="color: var(--text-muted);">Cập nhật những thông tin mới nhất về chăm sóc người cao tuổi</p>
    </div>

    <div class="main-container">
        <main>
            <article class="blog-card">
                <div class="blog-img"><i class="fa-solid fa-apple-whole"></i></div>
                <div class="blog-card-body">
                    <span class="blog-tag">Dinh dưỡng</span>
                    <h2 class="blog-title">Chế độ ăn tốt nhất cho người cao tuổi bị cao huyết áp</h2>
                    <div class="blog-meta">
                        <span><i class="fa-regular fa-user"></i> Admin</span>
                        <span><i class="fa-regular fa-calendar"></i> 12 Tháng 3, 2026</span>
                    </div>
                    <p class="blog-excerpt">Kiểm soát lượng muối và bổ sung các thực phẩm giàu Kali là chìa khóa vàng giúp cha mẹ duy trì huyết áp ổn định...</p>
                    <a href="blog_detail.jsp?id=1" class="btn-readmore">Đọc thêm</a>
                </div>
            </article>

            <article class="blog-card">
                <div class="blog-img"><i class="fa-solid fa-person-walking"></i></div>
                <div class="blog-card-body">
                    <span class="blog-tag">Vận động</span>
                    <h2 class="blog-title">5 bài tập dưỡng sinh nhẹ nhàng giúp xương khớp dẻo dai</h2>
                    <div class="blog-meta">
                        <span><i class="fa-regular fa-user"></i> BS. Minh Tuấn</span>
                        <span><i class="fa-regular fa-calendar"></i> 10 Tháng 3, 2026</span>
                    </div>
                    <p class="blog-excerpt">Vận động vừa sức không chỉ giúp cải thiện thể chất mà còn mang lại tinh thần sảng khoái cho người cao tuổi mỗi ngày...</p>
                    <a href="#" class="btn-readmore">Đọc thêm</a>
                </div>
            </article>

            <div class="pagination">
                <a href="#" class="page-item"><i class="fa-solid fa-chevron-left"></i></a>
                <a href="#" class="page-item active">1</a>
                <a href="#" class="page-item">2</a>
                <a href="#" class="page-item">3</a>
                <a href="#" class="page-item"><i class="fa-solid fa-chevron-right"></i></a>
            </div>
        </main>

        <aside>
            <div class="sidebar-widget">
                <div class="widget-title">Tìm kiếm</div>
                <div class="search-box">
                    <input type="text" placeholder="Nhập từ khóa...">
                    <button style="border:none; background:var(--primary); color:white; border-radius:10px; padding:0 15px;"><i class="fa-solid fa-search"></i></button>
                </div>
            </div>

            <div class="sidebar-widget">
                <div class="widget-title">Danh mục</div>
                <ul class="category-list">
                    <li><a href="#">Sức khỏe tim mạch <span>(12)</span></a></li>
                    <li><a href="#">Dinh dưỡng <span>(8)</span></a></li>
                    <li><a href="#">Hướng dẫn thiết bị <span>(5)</span></a></li>
                    <li><a href="#">Tâm lý tuổi già <span>(3)</span></a></li>
                </ul>
            </div>

            <div class="sidebar-widget">
                <div class="widget-title">Bài viết phổ biến</div>
                <div style="display:flex; gap:10px; margin-bottom:15px;">
                    <div style="width:60px; height:60px; background:#eee; border-radius:8px;"></div>
                    <div style="font-size:13px; font-weight:600;">Cách sử dụng máy đo huyết áp Omron tại nhà</div>
                </div>
                <div style="display:flex; gap:10px;">
                    <div style="width:60px; height:60px; background:#eee; border-radius:8px;"></div>
                    <div style="font-size:13px; font-weight:600;">Lưu ý khi lựa chọn thực phẩm chức năng</div>
                </div>
            </div>
        </aside>
    </div>

    <footer class="footer">
        <div class="footer-grid">
            <div class="footer-col">
                <h2 style="color:white; margin-top:0;">TamCare</h2>
                <p style="font-size:14px; line-height:1.6;">Ứng dụng tiên phong trong việc kết nối và chăm sóc sức khỏe người cao tuổi tại Việt Nam.</p>
            </div>
            <div class="footer-col">
                <h4>Khám phá</h4>
                <a href="about.jsp">Về chúng tôi</a>
                <a href="blog.jsp">Tin tức</a>
                <a href="products.jsp">Cửa hàng</a>
            </div>
            <div class="footer-col">
                <h4>Hỗ trợ</h4>
                <a href="#">Điều khoản</a>
                <a href="#">Bảo mật</a>
                <a href="#">Liên hệ</a>
            </div>
            <div class="footer-col">
                <h4>Kết nối</h4>
                <p style="font-size:14px;"><i class="fa-solid fa-phone"></i> Hotline: 1900 1234</p>
                <div style="display:flex; gap:15px; font-size:20px; margin-top:20px;">
                    <i class="fa-brands fa-facebook"></i>
                    <i class="fa-brands fa-youtube"></i>
                </div>
            </div>
        </div>
        <div style="text-align:center; margin-top:40px; font-size:13px; color:#64748b;">
            &copy; 2026 TamCare Project. All rights reserved.
        </div>
    </footer>

</body>
</html>