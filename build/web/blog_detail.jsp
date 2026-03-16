<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${blogDetail.title} - TamCare</title>
    <%-- Thẻ Meta này cực kỳ quan trọng: Nó yêu cầu trình duyệt không gửi thông tin nguồn gốc, giúp vượt rào chặn ảnh từ các báo lớn --%>
    <meta name="referrer" content="no-referrer">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #2c5282; --primary-light: #e0effa; --white: #ffffff; --text-main: #1e293b; --text-muted: #64748b; --bg-body: #f8fafc; }
        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; color: var(--text-main); line-height: 1.8; }
        
        .main-wrapper { margin-top: 100px; padding-bottom: 60px; }
        .container { max-width: 950px; margin: 0 auto; padding: 0 20px; }
        
        .back-btn { 
            display: inline-flex; align-items: center; gap: 10px; 
            color: var(--primary); text-decoration: none; font-weight: 700; 
            margin-bottom: 30px; transition: 0.3s;
        }
        .back-btn:hover { transform: translateX(-5px); color: #1a365d; }

        .blog-article { 
            background: var(--white); border-radius: 30px; overflow: hidden; 
            box-shadow: 0 15px 40px rgba(0,0,0,0.04); border: 1px solid var(--primary-light); 
        }

        .article-header { padding: 45px 50px 25px; border-bottom: 1px solid #f1f5f9; }
        .article-tag { 
            background: var(--primary-light); color: var(--primary); 
            padding: 6px 20px; border-radius: 20px; font-size: 14px; font-weight: 700; 
            text-transform: uppercase;
        }
        .article-title { font-size: 40px; margin: 20px 0; color: var(--primary); font-weight: 800; line-height: 1.3; }
        .article-meta { display: flex; gap: 25px; color: var(--text-muted); font-size: 15px; }

        .article-banner { 
            width: 100%; max-height: 550px; object-fit: cover; display: block;
            background-color: #f1f5f9; /* Màu nền dự phòng nếu ảnh chưa kịp load */
        }

        .article-content { padding: 40px 50px; font-size: 19px; color: #334155; text-align: justify; }
        .article-content h2, .article-content h3 { color: var(--primary); margin-top: 35px; font-weight: 700; }
        
        .article-content img { 
            max-width: 100%; 
            height: auto !important; 
            border-radius: 20px; 
            margin: 30px auto; 
            display: block; 
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            border: 5px solid white;
            background-color: #f1f5f9;
        }
        .article-content p { margin-bottom: 25px; }
        
        .article-content table { width: 100%; border-collapse: collapse; margin: 25px 0; }
        .article-content table td, .article-content table th { border: 1px solid #e2e8f0; padding: 12px; }

        .share-box {
            margin-top: 40px; padding: 30px; background: linear-gradient(135deg, var(--primary-light), #ffffff);
            border-radius: 25px; text-align: center; border: 1px solid #c3dafe;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="main-wrapper">
        <div class="container">
            <a href="blog" class="back-btn"><i class="fa-solid fa-arrow-left-long"></i> Quay lại danh sách tin tức</a>
            
            <c:choose>
                <c:when test="${not empty blogDetail}">
                    <article class="blog-article">
                        <div class="article-header">
                            <span class="article-tag">${blogDetail.category}</span>
                            <h1 class="article-title">${blogDetail.title}</h1>
                            <div class="article-meta">
                                <span><i class="fa-regular fa-calendar-check"></i> <fmt:formatDate value="${blogDetail.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                <span><i class="fa-regular fa-user"></i> Ban biên tập TamCare</span>
                            </div>
                        </div>

                        <%-- Ảnh bìa bài viết --%>
                        <c:if test="${not empty blogDetail.image}">
                            <img src="${blogDetail.image}" 
                                 class="article-banner" 
                                 alt="${blogDetail.title}" 
                                 referrerpolicy="no-referrer">
                        </c:if>

                        <%-- Nội dung chi tiết --%>
                        <div class="article-content" id="articleBody">
                            ${blogDetail.content}
                        </div>
                    </article>

                    <div class="share-box">
                        <h3 style="color: var(--primary); margin: 0 0 10px; font-weight: 800;">Bác thấy kiến thức này bổ ích chứ?</h3>
                        <p style="color: var(--text-muted); font-size: 16px;">Hãy lưu lại hoặc chia sẻ cho người thân cùng biết nhé!</p>
                        <div style="display: flex; gap: 15px; justify-content: center; margin-top: 20px;">
                            <button onclick="window.print()" style="padding: 12px 25px; border-radius: 12px; border: 1px solid var(--primary); background: white; color: var(--primary); cursor: pointer; font-weight: 700;">
                                <i class="fa-solid fa-print"></i> In bài viết
                            </button>
                            <button style="padding: 12px 25px; border-radius: 12px; border: none; background: #1877f2; color: white; cursor: pointer; font-weight: 700;">
                                <i class="fa-brands fa-facebook"></i> Chia sẻ ngay
                            </button>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 120px 0;">
                        <i class="fa-solid fa-circle-exclamation" style="font-size: 60px; color: #ef4444; margin-bottom: 20px;"></i>
                        <h2 style="color: var(--text-muted);">Không tìm thấy bài viết.</h2>
                        <a href="blog" style="color: var(--primary); font-weight: 800;">Quay về trang Blog</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@include file="footer.jsp" %>

    <script>
        // Xử lý nạp lại ảnh và sửa lỗi ảnh từ Database
        document.addEventListener('DOMContentLoaded', () => {
            const articleBody = document.getElementById('articleBody');
            const allImages = document.querySelectorAll('img');

            allImages.forEach(img => {
                // Đảm bảo chính sách bảo mật cho từng ảnh
                img.setAttribute('referrerpolicy', 'no-referrer');
                
                img.addEventListener('error', function handleImageError() {
                    const retryCount = parseInt(this.getAttribute('data-retry-count') || '0');
                    
                    if (retryCount < 2) {
                        this.setAttribute('data-retry-count', retryCount + 1);
                        // Thêm timestamp để ép trình duyệt tải lại từ server, không dùng cache cũ
                        const separator = this.src.includes('?') ? '&' : '?';
                        this.src = this.src + separator + 'refresh=' + new Date().getTime();
                    } else {
                        // Nếu thử lại vẫn lỗi, dùng ảnh dự phòng chuyên nghiệp
                        this.src = 'https://icons.veryicon.com/png/o/education-technology/property-management-system-in-vanke/news-47.png';
                        this.style.opacity = '0.5';
                    }
                });
            });
        });
    </script>
</body>
</html>