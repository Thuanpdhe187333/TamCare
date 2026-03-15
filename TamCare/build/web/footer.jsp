<%-- footer.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
</div>

<footer style="
    background:#000;
    color:#d1d5db;
    padding:60px 80px;
    width:100%;
    box-sizing:border-box;
    display:grid;
    grid-template-columns:2fr 1.5fr 1fr;
    gap:60px;
    border-top:1px solid rgba(255,255,255,0.08);
">

    <!-- CỘT 1 -->
    <div>
        <h3 style="color:white; font-weight:600; margin-bottom:15px;">

        </h3>

        <p style="color:white; font-weight:600; margin-bottom:10px;">
            TÂM CARE
        </p>

        <p style="font-size:14px; line-height:1.6;">
            GCNĐKKD: 0388768674 | PHÒNG ĐĂNG KÝ<br>
            ĐẠI HỌC FPT <br>

            KHU CÔNG NGHỆ CAO HÒA LẠC<br>

            THỊ XÃ SƠN TÂY, THÀNH PHỐ HÀ NỘI, VIỆT NAM
        </p>
    </div>

    <!-- CỘT 2 -->
    <div>
        <h3 style="color:white; margin-bottom:20px;">
            LIÊN HỆ
        </h3>

        <p style="font-size:14px; margin-bottom:8px;">
            <i class="fa-solid fa-location-dot" style="margin-right:8px;"></i>
            Địa chỉ: TRƯỜNG ĐẠI HỌC FPT
        </p>

        <p style="font-size:14px; margin-bottom:8px;">
            <i class="fa-solid fa-phone" style="margin-right:8px;"></i>
            Hotline: 0388768674
        </p>

        <p style="font-size:14px; margin-bottom:20px;">
            <i class="fa-solid fa-envelope" style="margin-right:8px;"></i>
            Email: thuanpdhe187333@fpt.edu.vn
        </p>

        <!-- Social -->
        <div style="display:flex; gap:15px; font-size:22px;">
            <a href="#" style="color:white;"><i class="fa-brands fa-tiktok"></i></a>
            <a href="#" style="color:#1877f2;"><i class="fa-brands fa-facebook"></i></a>
            <a href="#" style="color:white;"><i class="fa-brands fa-threads"></i></a>
            <a href="#" style="color:red;"><i class="fa-brands fa-youtube"></i></a>
        </div>
    </div>

    <!-- CỘT 3 -->
    <div>
        <h3 style="color:white; margin-bottom:20px;">
            THỜI GIAN LÀM VIỆC
        </h3>

        <p style="font-size:14px; margin-bottom:10px;">
            <i class="fa-regular fa-clock" style="margin-right:8px;"></i>
            Thứ 2 - Thứ 6: 8AM đến 5PM
        </p>

        <p style="font-size:14px;">
            <i class="fa-regular fa-clock" style="margin-right:8px;"></i>
            Thứ 7 - CN: 8AM đến 11AM
        </p>
    </div>

</footer>

<!-- NÚT AI -->
<div style="
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background: #2563eb;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 2000;
    box-shadow: 0 8px 25px rgba(0,0,0,0.3);
" onclick="toggleAIChat()">
    <i class="fa-solid fa-robot fa-xl"></i>
</div>

<script>
function toggleAIChat(){
    alert("TamCare AI đang khởi động...");
}
</script>

</body>
</html>