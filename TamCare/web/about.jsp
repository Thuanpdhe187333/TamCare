<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Về chúng tôi - TamCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #008080; /* Màu xanh đồng bộ Header */
            --primary-light: #e6f2f2;
            --white: #ffffff;
            --text-muted: #64748b;
            --bg-body: #f8fafc;
        }
        body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; padding-top: 70px; color: #1e293b; }
        
        /* Navbar đồng bộ màu xanh */
        .navbar { 
            height: 70px; background: var(--primary); display: flex; 
            justify-content: space-between; align-items: center; padding: 0 40px; 
            position: fixed; top: 0; width: 100%; z-index: 1001; 
            box-sizing: border-box; color: white; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .logo { font-size: 24px; font-weight: 800; color: white; text-decoration: none; display: flex; align-items: center; gap: 10px; }

        .about-hero { background: var(--white); padding: 80px 20px; text-align: center; border-bottom: 1px solid #e2e8f0; }
        .about-hero h1 { font-size: 42px; color: var(--primary); margin-bottom: 20px; }
        .about-hero p { font-size: 18px; color: var(--text-muted); max-width: 700px; margin: 0 auto; }

        .content-section { max-width: 1000px; margin: 50px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 40px; }
        .info-card { background: white; padding: 40px; border-radius: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
        .info-card i { font-size: 32px; color: var(--primary); margin-bottom: 20px; }
        .info-card h3 { margin-top: 0; font-size: 24px; }

        .footer { background: #1e293b; color: #94a3b8; padding: 40px; text-align: center; margin-top: 60px; }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="home_caregiver.jsp" class="logo">
            <i class="fa-solid fa-hand-holding-heart"></i> TamCare
        </a>
        <div style="font-weight: 500;">Kết nối & Chăm sóc</div>
    </header>

    <section class="about-hero">
        <h1>Sứ mệnh TamCare</h1>
        <p>Chúng tôi tận dụng công nghệ hiện đại để mang lại sự an tâm cho con cái và sức khỏe tối ưu cho cha mẹ, xóa tan khoảng cách địa lý trong việc chăm sóc gia đình.</p>
    </section>

    <div class="content-section">
        <div class="info-card">
            <i class="fa-solid fa-eye"></i>
            <h3>Tầm nhìn</h3>
            <p>Trở thành nền tảng chăm sóc sức khỏe người cao tuổi hàng đầu tại Việt Nam, nơi công nghệ phục vụ lòng hiếu thảo.</p>
        </div>
        <div class="info-card">
            <i class="fa-solid fa-heart-pulse"></i>
            <h3>Giá trị cốt lõi</h3>
            <p>Sự tận tâm, tính chính xác và kết nối yêu thương là kim chỉ nam cho mọi tính năng mà chúng tôi phát triển.</p>
        </div>
    </div>

    <div style="max-width: 1000px; margin: 0 auto 60px; padding: 0 20px;">
        <div style="background: var(--primary); color: white; padding: 50px; border-radius: 30px; text-align: center;">
            <h2>Đội ngũ phát triển</h2>
            <p style="opacity: 0.9;">TamCare Team - Những kỹ sư trẻ mang khát vọng phụng sự cộng đồng.</p>
        </div>
    </div>

    <footer class="footer">
        <p>© 2026 TamCare Project. Được xây dựng với tình yêu thương.</p>
    </section>
</body>
</html>