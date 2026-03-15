<%-- footer.jsp - Đã xóa contentType để tránh lỗi HTTP 500 --%>
<%@page pageEncoding="UTF-8"%>
</div> <footer style="
    background: #1a365d;
    color: #e2e8f0;
    padding: 60px 10%;
    width: 100%;
    box-sizing: border-box;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 40px;
    border-top: 1px solid rgba(255,255,255,0.1);
    margin-top: 50px;
">

    <div>
        <h3 style="color:white; font-weight:800; margin-bottom:15px; font-size: 24px;">
            <i class="fa-solid fa-hand-holding-heart"></i> TÂM CARE
        </h3>
        <p style="font-size:14px; line-height:1.8; opacity: 0.8;">
            GCNĐKKD: 0388768674 | PHÒNG ĐĂNG KÝ<br>
            ĐẠI HỌC FPT - CƠ SỞ HOÀ LẠC<br>
            KHU CÔNG NGHỆ CAO HÒA LẠC<br>
            THẠCH THẤT, HÀ NỘI, VIỆT NAM
        </p>
    </div>

    <div>
        <h3 style="color:white; margin-bottom:20px; font-size: 18px; font-weight: 700;">
            LIÊN HỆ
        </h3>
        <p style="font-size:14px; margin-bottom:12px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-location-dot" style="color: #63b3ed;"></i>
            <span>Đại học FPT Hà Nội</span>
        </p>
        <p style="font-size:14px; margin-bottom:12px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-phone" style="color: #63b3ed;"></i>
            <span>Hotline: 0388768674</span>
        </p>
        <p style="font-size:14px; margin-bottom:20px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-solid fa-envelope" style="color: #63b3ed;"></i>
            <span>Email: thuanpdhe187333@fpt.edu.vn</span>
        </p>

        <div style="display:flex; gap:20px; font-size:22px;">
            <a href="#" style="color:white; transition: 0.3s;"><i class="fa-brands fa-facebook"></i></a>
            <a href="#" style="color:white; transition: 0.3s;"><i class="fa-brands fa-youtube"></i></a>
            <a href="#" style="color:white; transition: 0.3s;"><i class="fa-brands fa-tiktok"></i></a>
        </div>
    </div>

    <div>
        <h3 style="color:white; margin-bottom:20px; font-size: 18px; font-weight: 700;">
            HỖ TRỢ 24/7
        </h3>
        <p style="font-size:14px; margin-bottom:10px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-regular fa-clock" style="color: #63b3ed;"></i>
            <span>Thứ 2 - Thứ 6: 08:00 - 17:00</span>
        </p>
        <p style="font-size:14px; display: flex; align-items: center; gap: 10px;">
            <i class="fa-regular fa-clock" style="color: #63b3ed;"></i>
            <span>Thứ 7 - CN: 08:00 - 11:30</span>
        </p>
        <div style="margin-top: 20px; padding: 10px; background: rgba(255,255,255,0.05); border-radius: 10px; font-size: 12px; border-left: 3px solid #63b3ed;">
            Cấp cứu khẩn cấp vui lòng gọi Hotline ngay lập tức.
        </div>
    </div>

</footer>

<div style="
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background: #2c5282;
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    z-index: 2000;
    box-shadow: 0 8px 25px rgba(0,0,0,0.2);
    border: 2px solid white;
    transition: 0.3s;
" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'" onclick="toggleAIChat()">
    <i class="fa-solid fa-robot fa-xl"></i>
</div>

<script>
function toggleAIChat(){
    alert("TamCare AI đang được khởi động để hỗ trợ bác...");
}
</script>

</body>
</html>