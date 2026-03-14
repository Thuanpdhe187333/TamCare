<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%
    User acc = (User) session.getAttribute("account");
    if(acc == null) { response.sendRedirect("login.jsp"); return; }
    
    // Tạo nội dung chuyển khoản chuẩn: NAP + Tên không dấu + TAM
    String rawName = acc.getFullName().toUpperCase();
    String cleanName = rawName.replaceAll("[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂÂÊÔƠƯ]", "A") // Đơn giản hóa để làm ví dụ
                              .replaceAll("\\s+", ""); 
    String transferContent = "NAP" + cleanName + "TAM";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Unlock Premium - TamCare</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #007bff; --primary-green: #14b8a6; --primary-purple: #d946ef;
            --primary-orange: #f59e0b; --bg-body: #f4f7fe; --text-main: #1e293b;
        }
        body { font-family: 'Lexend', sans-serif; background-color: var(--bg-body); margin: 0; padding: 20px; color: var(--text-main); }
        .container { max-width: 1200px; margin: 0 auto; }

        .unlock-hero { background: #0f172a; border-radius: 24px; padding: 40px; text-align: center; color: white; margin-bottom: 30px; }
        
        /* PRICING GRID */
        .pricing-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .card { background: white; border-radius: 24px; padding: 25px; text-align: center; border: 2px solid transparent; transition: 0.3s; position: relative; box-shadow: 0 10px 30px rgba(0,0,0,0.05); display: flex; flex-direction: column; }
        .card:hover { transform: translateY(-5px); border-color: var(--primary-blue); }
        .price-box { background: #f8fafc; border: 1px solid #f1f5f9; border-radius: 12px; padding: 10px; margin: 15px 0; color: var(--primary-blue); font-weight: 800; font-size: 18px; }
        .feature-list { text-align: left; padding: 0; list-style: none; margin: 15px 0; flex-grow: 1; font-size: 12px; color: #64748b; }
        .feature-list li { margin-bottom: 8px; display: flex; align-items: flex-start; gap: 8px; }
        .btn-upgrade { width: 100%; padding: 12px; border-radius: 12px; border: none; color: white; font-weight: 700; cursor: pointer; background: var(--primary-blue); }

        /* INFO GRID */
        .info-grid { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 20px; margin-bottom: 20px; }
        .info-card { background: white; border-radius: 24px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .input-box { background: #f1f5f9; padding: 12px 15px; border-radius: 10px; font-weight: 700; font-size: 15px; margin-top: 5px; color: #1e293b; }
        .input-box.highlight { background: #fffbeb; border: 1px solid #fef08a; color: #854d0e; }
        
        /* QR BOX FIX */
        .qr-box { text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .qr-image-container { 
            background: white; padding: 15px; border-radius: 20px; 
            border: 2px solid #e2e8f0; box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            margin-bottom: 15px;
        }
        .qr-image-container img { width: 220px; height: auto; display: block; }
    </style>
</head>
<body>

<div class="container">
    <div class="unlock-hero">
        <h1>Unlock <span>Premium</span></h1>
        <p>Chọn gói phù hợp để nhận đặc quyền chăm sóc sức khỏe tốt nhất</p>
    </div>

    <div class="pricing-grid">
        <div class="card"><h4 style="margin:0">BASIC (1T)</h4><div class="price-box">249.000đ</div><ul class="feature-list"><li>Gợi ý ăn uống AI</li><li>Nhắc thuốc (Đẩy)</li></ul><button class="btn-upgrade">Nâng cấp</button></div>
        <div class="card" style="border-color: #14b8a6;"><h4 style="margin:0">PREMIUM (1T)</h4><div class="price-box" style="color:#14b8a6">399.000đ</div><ul class="feature-list"><li>Tất cả bản Basic</li><li>Check-in sinh tồn</li></ul><button class="btn-upgrade" style="background:#14b8a6">Nâng cấp</button></div>
        <div class="card"><h4 style="margin:0">BASIC (6T)</h4><div class="price-box">1.245.000đ</div><ul class="feature-list"><li>Tiết kiệm 20%</li><li>Hỗ trợ ưu tiên</li></ul><button class="btn-upgrade">Nâng cấp</button></div>
        <div class="card"><h4 style="margin:0">PREMIUM (6T)</h4><div class="price-box">1.995.000đ</div><ul class="feature-list"><li>VIP Combo</li><li>Đặc quyền 24/7</li></ul><button class="btn-upgrade">Nâng cấp</button></div>
    </div>

    <div class="info-grid">
        <div class="info-card">
            <h4 style="margin-top:0"><i class="fa-solid fa-university"></i> Thông tin tài khoản</h4>
            <div style="margin-bottom:15px"><small>CHỦ TÀI KHOẢN</small><div class="input-box">PHAM DUC THUAN</div></div>
            <div style="margin-bottom:15px"><small>SỐ TÀI KHOẢN</small><div class="input-box">3711003796</div></div>
            <div style="margin-bottom:15px"><small>NGÂN HÀNG</small><div class="input-box">BIDV (Chi nhánh Yên Bái)</div></div>
            <div><small>NỘI DUNG CHUYỂN KHOẢN</small><div class="input-box highlight"><%= transferContent %></div></div>
        </div>
        
        <div class="info-card qr-box">
            <h4 style="margin-top:0"><i class="fa-solid fa-qrcode"></i> Quét mã nạp nhanh</h4>
            <div class="qr-image-container">
                <%-- SỬA LỖI: Dùng API VietQR để tạo mã đúng STK và Tên của bác --%>
                <img src="https://img.vietqr.io/image/BIDV-3711003796-compact2.jpg?amount=0&addInfo=<%= transferContent %>&accountName=PHAM%20DUC%20THUAN" 
                     alt="Mã QR Thanh Toán BIDV">
            </div>
            <p style="font-size:11px; color:#94a3b8;">Dùng App Ngân hàng hoặc VietQR để quét</p>
        </div>
    </div>

    <div style="padding: 20px; background: white; border-radius: 24px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <h4 style="color: var(--primary-blue); margin-top:0"><i class="fa-solid fa-location-dot"></i> Văn phòng hỗ trợ</h4>
        <div style="border-radius: 15px; overflow: hidden; height: 300px; border: 1px solid #eee;">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.4855345754984!2d105.52487567503083!3d21.01324998063177!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345b465a4e65fb%3A0xaae6040cf0519ef5!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQ!5e0!3m2!1svi!2s!4v1710400000000!5m2!1svi!2s" 
                    width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
        </div>
    </div>
</div>

</body>
</html>