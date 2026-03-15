<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

<style>
    :root {
        /* Màu chủ đạo theo yêu cầu của bác */
        --primary-custom: #2c5282; 
        --primary-light: #e0effa;
        --white: #ffffff;
        --text-muted: #64748b;
        --bg-body: #f8fafc;
        --sidebar-width: 280px; /* Khớp với chiều rộng sidebar của bác */
    }

    body { font-family: 'Lexend', sans-serif; background: var(--bg-body); margin: 0; color: #1e293b; }
    
    /* --- FIX LỖI CHÈN NHAU --- */
    .main-wrapper-about {
        margin-left: var(--sidebar-width); 
        margin-top: 70px; /* Chiều cao Navbar */
        min-height: calc(100vh - 70px);
        box-sizing: border-box;
    }

    .about-hero { 
        background: var(--primary-light); 
        padding: 80px 40px; 
        text-align: center; 
        border-bottom: 1px solid #c3dafe; 
    }
    .about-hero h1 { 
        font-size: 42px; 
        color: var(--primary-custom); 
        margin-bottom: 20px; 
        font-weight: 800;
    }
    .about-hero p { 
        font-size: 18px; 
        color: var(--primary-custom); 
        max-width: 750px; 
        margin: 0 auto; 
        line-height: 1.6;
        opacity: 0.8;
    }

    .content-section { 
        max-width: 1100px; 
        margin: 50px auto; 
        padding: 0 40px; 
        display: grid; 
        grid-template-columns: 1fr 1fr; 
        gap: 30px; 
    }
    .info-card { 
        background: white; 
        padding: 40px; 
        border-radius: 24px; 
        box-shadow: 0 4px 20px rgba(0,0,0,0.02); 
        border: 1px solid var(--primary-light);
        transition: 0.3s ease;
    }
    .info-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
    .info-card i { font-size: 36px; color: var(--primary-custom); margin-bottom: 20px; }
    .info-card h3 { margin-top: 0; font-size: 24px; color: var(--primary-custom); }
    .info-card p { color: var(--text-muted); line-height: 1.6; margin: 0; }

    .team-highlight {
        max-width: 1000px; 
        margin: 0 auto 80px; 
        padding: 0 40px;
    }
    .team-card {
        background: var(--primary-custom); 
        color: white; 
        padding: 60px; 
        border-radius: 35px; 
        text-align: center;
        box-shadow: 0 10px 30px rgba(44, 82, 130, 0.2);
    }

    @media (max-width: 1024px) {
        .main-wrapper-about { margin-left: 0; }
        .content-section { grid-template-columns: 1fr; }
    }
</style>

<div class="main-wrapper-about">
    <section class="about-hero">
        <h1 class="animate-up">Sứ mệnh TamCare</h1>
        <p class="animate-up">Chúng tôi tận dụng công nghệ hiện đại để mang lại sự an tâm cho con cái và sức khỏe tối ưu cho cha mẹ, xóa tan khoảng cách địa lý trong việc chăm sóc gia đình.</p>
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

    <div class="team-highlight">
        <div class="team-card">
            <h2 style="font-size: 32px; margin-bottom: 15px;">Đội ngũ phát triển</h2>
            <p style="opacity: 0.9; font-size: 18px;">TamCare Team - Những kỹ sư trẻ mang khát vọng phụng sự cộng đồng bằng cả trái tim.</p>
            <div style="margin-top: 30px; display: flex; justify-content: center; gap: 20px; font-size: 24px;">
                <i class="fa-solid fa-code"></i>
                <i class="fa-solid fa-user-doctor"></i>
                <i class="fa-solid fa-shield-heart"></i>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>