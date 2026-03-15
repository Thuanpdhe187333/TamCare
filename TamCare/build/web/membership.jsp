<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
    User acc = (User) session.getAttribute("account");
    if(acc == null) { response.sendRedirect("login.jsp"); return; }
    
    String rawName = acc.getFullName().toUpperCase();
    String cleanName = rawName.replaceAll("[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂÂÊÔƠƯ]", "A")
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
:root{
    --main-color:#e0effa;
    --main-dark:#3b82f6;
    --main-hover:#2563eb;
    --text-main:#1e293b;
    --shopee-orange: #ee4d2d;
}

body{ font-family:'Lexend',sans-serif; background: #f8fafc; margin:0; padding: 0; color:var(--text-main); }

.membership-container{ max-width:1200px; margin:auto; padding: 110px 20px 60px 20px; }

/* HERO */
.unlock-hero{ background:linear-gradient(135deg,#e0effa,#cfe5f7); border-radius:24px; padding:40px; text-align:center; margin-bottom:30px; }
.unlock-hero h1 span { color: var(--main-dark); }

/* PRICING */
.pricing-grid{ display:grid; grid-template-columns:repeat(auto-fit, minmax(250px, 1fr)); gap:20px; margin-bottom:40px; }
.card{ background:white; border-radius:24px; padding:25px; text-align:center; border:2px solid transparent; transition:0.3s; position:relative; box-shadow:0 10px 25px rgba(0,0,0,0.04); display:flex; flex-direction:column; }
.card:hover{ transform:translateY(-5px); border-color:var(--main-dark); }
.price-box{ background:#f0f7fd; border-radius:12px; padding:10px; margin:15px 0; color:var(--main-dark); font-weight:800; font-size:18px; }

.feature-list{ text-align:left; padding:0; list-style:none; margin:15px 0; flex-grow:1; font-size:12px; color:#475569; }
.feature-list li{ margin-bottom:8px; display:flex; align-items:flex-start; gap:8px; }

.btn-upgrade{ width:100%; padding:12px; border-radius:12px; border:none; color:white; font-weight:700; cursor:pointer; background:var(--main-dark); transition: 0.2s; }
.btn-upgrade:hover{ background:var(--main-hover); }

/* INFO */
.info-grid{ display:grid; grid-template-columns: 1.2fr 0.8fr; gap:20px; margin-bottom:20px; }
.info-card{ background:white; border-radius:24px; padding:30px; box-shadow:0 4px 15px rgba(0,0,0,0.03); border: 1px solid var(--main-color); }
.input-box{ background:#f0f7fd; padding:12px 15px; border-radius:10px; font-weight:700; font-size:15px; margin-top:5px; border: 1px solid #eef2f6; }
.input-box.highlight{ background:var(--main-color); border:1px solid #bcdaf3; }

/* MODAL XÁC NHẬN KIỂU SHOPEE */
.checkout-modal { display:none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); animation: fadeIn 0.3s; }
.modal-content { background: white; width: 500px; margin: 8% auto; border-radius: 4px; overflow: hidden; box-shadow: 0 5px 25px rgba(0,0,0,0.2); }
@keyframes fadeIn { from {opacity: 0;} to {opacity: 1;} }

/* QR & MAP */
.qr-box{ text-align:center; }
.qr-image-container{ background:white; padding:15px; border-radius:20px; border:2px solid #e0effa; margin-bottom:15px; }
.qr-image-container img{ width:220px; display: block; }
.map-box{ padding:20px; background:white; border-radius:24px; border: 1px solid var(--main-color); }
</style>
</head>

<body>

    <%@include file="header.jsp" %>

    <div class="membership-container">

        <div class="unlock-hero">
            <h1>Unlock <span>Premium</span> Member</h1>
            <p>Chọn gói phù hợp để nhận đặc quyền chăm sóc sức khỏe tốt nhất cho người thân</p>
        </div>

        <div class="pricing-grid">
            <div class="card">
                <h4 style="margin:0">BASIC (1 Tháng)</h4>
                <div class="price-box">249.000 pts</div>
                <ul class="feature-list">
                    <li><i class="fa-solid fa-check"></i> Gợi ý ăn uống AI</li>
                    <li><i class="fa-solid fa-check"></i> Nhắc thuốc (Đẩy thông báo)</li>
                </ul>
                <button type="button" class="btn-upgrade" onclick="openPaymentModal('BASIC (1 Tháng)', 249000, 'BASIC_1T')">Nâng cấp ngay</button>
            </div>

            <div class="card" style="border-color: var(--main-dark);">
                <div style="position: absolute; top: -12px; left: 50%; transform: translateX(-50%); background: var(--main-dark); color: white; padding: 2px 12px; border-radius: 20px; font-size: 10px; font-weight: 800;">PHỔ BIẾN</div>
                <h4 style="margin:0">PREMIUM (1 Tháng)</h4>
                <div class="price-box">399.000 pts</div>
                <ul class="feature-list">
                    <li><i class="fa-solid fa-check"></i> Tất cả bản Basic</li>
                    <li><i class="fa-solid fa-check"></i> Check-in sinh tồn 24/7</li>
                </ul>
                <button type="button" class="btn-upgrade" onclick="openPaymentModal('PREMIUM (1 Tháng)', 399000, 'PREMIUM_1T')">Nâng cấp ngay</button>
            </div>

            <div class="card">
                <h4 style="margin:0">BASIC (6 Tháng)</h4>
                <div class="price-box">1.245.000 pts</div>
                <ul class="feature-list">
                    <li><i class="fa-solid fa-check"></i> Tiết kiệm 20% chi phí</li>
                    <li><i class="fa-solid fa-check"></i> Hỗ trợ ưu tiên</li>
                </ul>
                <button type="button" class="btn-upgrade" onclick="openPaymentModal('BASIC (6 Tháng)', 1245000, 'BASIC_6T')">Nâng cấp ngay</button>
            </div>

            <div class="card">
                <h4 style="margin:0">PREMIUM (6 Tháng)</h4>
                <div class="price-box">1.995.000 pts</div>
                <ul class="feature-list">
                    <li><i class="fa-solid fa-check"></i> VIP Combo đầy đủ</li>
                    <li><i class="fa-solid fa-check"></i> Đặc quyền hỗ trợ 24/7</li>
                </ul>
                <button type="button" class="btn-upgrade" onclick="openPaymentModal('PREMIUM (6 Tháng)', 1995000, 'PREMIUM_6T')">Nâng cấp ngay</button>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h4 style="margin-top:0"><i class="fa-solid fa-university"></i> Thông tin tài khoản</h4>
                <div style="margin-bottom:15px">
                    <small style="font-weight: 700; color: var(--text-muted);">CHỦ TÀI KHOẢN</small>
                    <div class="input-box">PHAM DUC THUAN</div>
                </div>
                <div style="margin-bottom:15px">
                    <small style="font-weight: 700; color: var(--text-muted);">SỐ TÀI KHOẢN</small>
                    <div class="input-box">3711003796</div>
                </div>
                <div style="margin-bottom:15px">
                    <small style="font-weight: 700; color: var(--text-muted);">NGÂN HÀNG</small>
                    <div class="input-box">BIDV (Chi nhánh Yên Bái)</div>
                </div>
                <div>
                    <small style="font-weight: 700; color: var(--main-dark);">NỘI DUNG CHUYỂN KHOẢN</small>
                    <div class="input-box highlight"><%= transferContent %></div>
                </div>
            </div>

            <div class="info-card qr-box">
                <h4 style="margin-top:0"><i class="fa-solid fa-qrcode"></i> Quét mã nạp nhanh</h4>
                <div class="qr-image-container">
                    <img src="https://img.vietqr.io/image/BIDV-3711003796-compact2.jpg?amount=0&addInfo=<%= transferContent %>&accountName=PHAM%20DUC%20THUAN" alt="VietQR">
                </div>
                <p style="font-size:11px;color:#64748b">Dùng App Ngân hàng hoặc VietQR để quét</p>
            </div>
        </div>

        <div class="map-box">
            <h4 style="color:var(--main-dark); margin:0;"><i class="fa-solid fa-location-dot"></i> Văn phòng hỗ trợ TamCare</h4>
            <div style="border-radius:15px;overflow:hidden;height:350px;border:1px solid #eee; margin-top: 15px;">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.485532723145!2d105.52449747514128!3d21.013244680628292!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31345b465a4e65fb%3A0xaae603094406203a!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQ!5e0!3m2!1svi!2s!4v1700000000000!5m2!1svi!2s" width="100%" height="100%" style="border:0;" loading="lazy"></iframe>
            </div>
        </div>
    </div>

    <div id="paymentModal" class="checkout-modal">
        <div class="modal-content">
            <div style="padding: 18px 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                <h3 style="margin: 0; color: var(--shopee-orange); font-size: 18px;">Xác nhận thanh toán</h3>
                <span onclick="closeModal()" style="cursor: pointer; font-size: 24px; color: #bbb;">&times;</span>
            </div>
            <div style="padding: 25px;">
                <div style="display: flex; gap: 15px; margin-bottom: 25px;">
                    <div style="width: 65px; height: 65px; background: #f0f7ff; border-radius: 8px; display: flex; align-items: center; justify-content: center; border: 1px solid #dce9f5;">
                        <i class="fa-solid fa-gem" style="color: var(--main-dark); font-size: 28px;"></i>
                    </div>
                    <div style="flex: 1;">
                        <div id="modalPkgName" style="font-weight: 700; font-size: 15px; margin-bottom: 5px; color: #333;"></div>
                        <div style="color: #888; font-size: 12px;">Đặc quyền chăm sóc sức khỏe TamCare</div>
                    </div>
                    <div id="modalPkgPrice" style="font-weight: 700; color: #333;"></div>
                </div>

                <hr style="border: 0; border-top: 1px dashed #eee; margin: 20px 0;">

                <div style="font-size: 14px; line-height: 2;">
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: #888;">Tổng tiền điểm</span>
                        <span id="subtotal" style="font-weight: 600;"></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span style="color: #888;">Phí kích hoạt dịch vụ</span>
                        <span style="font-weight: 600;">0 pts</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; margin-top: 15px; align-items: center;">
                        <span style="font-size: 16px; font-weight: 600;">Tổng thanh toán</span>
                        <span id="finalTotal" style="font-size: 24px; color: var(--shopee-orange); font-weight: 800;"></span>
                    </div>
                </div>
            </div>
            <div style="background: #fffbf8; padding: 25px; border-top: 1px solid #f1f0ed; text-align: right;">
                <p style="font-size: 12px; color: #999; margin-bottom: 20px;">Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo <a href="#" style="color: #0055aa; text-decoration: none;">Điều khoản TamCare</a></p>
                <form action="upgrade-membership" method="post" id="upgradeForm">
                    <input type="hidden" name="packageId" id="hiddenPackageId">
                    <input type="hidden" name="pointCost" id="hiddenPointCost">
                    <button type="submit" style="background: var(--shopee-orange); color: white; border: none; padding: 14px 60px; font-size: 16px; border-radius: 4px; cursor: pointer; font-weight: 700; box-shadow: 0 4px 10px rgba(238, 77, 45, 0.2);">Đặt hàng</button>
                </form>
            </div>
        </div>
    </div>

    <script>
    function openPaymentModal(name, cost, id) {
        document.getElementById('modalPkgName').innerText = name;
        let formatted = new Intl.NumberFormat('vi-VN').format(cost) + " pts";
        document.getElementById('modalPkgPrice').innerText = formatted;
        document.getElementById('subtotal').innerText = formatted;
        document.getElementById('finalTotal').innerText = formatted;
        
        document.getElementById('hiddenPackageId').value = id;
        document.getElementById('hiddenPointCost').value = cost;
        
        document.getElementById('paymentModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('paymentModal').style.display = 'none';
    }

    window.onclick = function(e) {
        if (e.target == document.getElementById('paymentModal')) closeModal();
    }
    </script>

    <%@include file="footer.jsp" %>
</body>
</html>