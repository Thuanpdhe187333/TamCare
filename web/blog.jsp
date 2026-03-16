<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>TamCare Blog - Kiến thức sức khỏe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #2c5282; --primary-light: #e0effa; --white: #ffffff; --text-main: #1e293b; --text-muted: #64748b; --bg-body: #f8fafc; }
        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; color: var(--text-main); }
        .main-wrapper { margin-top: 90px; }
        .blog-banner { background: var(--white); border-bottom: 1px solid var(--primary-light); padding: 50px 0; text-align: center; }
        .main-container { max-width: 1250px; margin: 40px auto; display: grid; grid-template-columns: 1fr 350px; gap: 40px; padding: 0 20px 60px; }
        .blog-card { background: var(--white); border-radius: 25px; overflow: hidden; margin-bottom: 35px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); transition: 0.3s; border: 1px solid var(--primary-light); }
        .blog-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(44, 82, 130, 0.1); }
        .blog-img-container { width: 100%; height: 350px; overflow: hidden; background: #e2e8f0; }
        .blog-img-container img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .blog-card-body { padding: 35px; }
        .blog-tag { background: var(--primary-light); color: var(--primary); padding: 6px 18px; border-radius: 20px; font-size: 14px; font-weight: 700; }
        .blog-title { font-size: 30px; margin: 20px 0; line-height: 1.4; color: var(--primary); font-weight: 800; }
        .blog-meta { font-size: 15px; color: var(--text-muted); display: flex; gap: 25px; margin-bottom: 20px; }
        .blog-excerpt { color: #4a5568; line-height: 1.8; font-size: 17px; margin-bottom: 25px; }
        .btn-readmore { display: inline-block; padding: 15px 35px; background: var(--primary); color: white; text-decoration: none; border-radius: 15px; font-weight: 700; transition: 0.3s; }
        .sidebar-widget { background: var(--white); border-radius: 25px; padding: 30px; margin-bottom: 30px; border: 1px solid var(--primary-light); }
        .widget-title { font-size: 20px; font-weight: 800; margin-bottom: 25px; color: var(--primary); display: flex; align-items: center; gap: 10px; }
        .search-box { display: flex; gap: 10px; }
        .search-box input { flex: 1; padding: 15px; border: 1px solid var(--primary-light); border-radius: 12px; outline: none; }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>
    <div class="main-wrapper">
        <div class="blog-banner">
            <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">
                <h1 style="font-size: 42px; margin: 0; color: var(--primary); font-weight: 800;">Cẩm nang Sức khỏe</h1>
                <p style="color: var(--text-muted); font-size: 20px; margin-top: 15px;">Kiến thức bổ ích giúp bác sống vui, sống khỏe mỗi ngày</p>
            </div>
        </div>
        <div class="main-container">
            <main>
                <c:if test="${empty blogList}"><div style="text-align: center; padding: 100px 0;">Hiện chưa có bài viết nào.</div></c:if>
                <c:forEach items="${blogList}" var="b">
                    <article class="blog-card">
                        <div class="blog-img-container">
                            <img src="${b.image}" alt="${b.title}" referrerpolicy="no-referrer"
                                 onerror="this.onerror=null;this.src='https://img.freepik.com/free-vector/health-medical-care-icons-set_53876-64503.jpg';">
                        </div>
                        <div class="blog-card-body">
                            <span class="blog-tag">${b.category}</span>
                            <h2 class="blog-title">${b.title}</h2>
                            <div class="blog-meta">
                                <span><i class="fa-regular fa-calendar-check"></i> <fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy"/></span>
                                <span><i class="fa-regular fa-user"></i> Admin TamCare</span>
                            </div>
                            <p class="blog-excerpt">${b.summary}</p>
                            <a href="blog?id=${b.blogID}" class="btn-readmore">Đọc bài viết <i class="fa-solid fa-arrow-right"></i></a>
                        </div>
                    </article>
                </c:forEach>
            </main>
            <aside>
                <div class="sidebar-widget">
                    <div class="widget-title"><i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm</div>
                    <form action="blog" method="GET" class="search-box">
                        <input type="text" name="search" placeholder="Bác muốn tìm gì ạ?">
                        <button type="submit" style="border:none; background:var(--primary); color:white; border-radius:12px; padding:0 15px; cursor:pointer;"><i class="fa-solid fa-search"></i></button>
                    </form>
                </div>
            </aside>
        </div>
    </div>
    <%@include file="footer.jsp" %>
</body>
</html>