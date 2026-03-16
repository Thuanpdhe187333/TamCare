package controller;

import dal.PointDAO;
import dal.UserDAO;
import dal.NotificationDAO;
import model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "UpgradeServlet", urlPatterns = {"/upgrade-membership"})
public class UpgradeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        // 1. Kiểm tra đăng nhập
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy thông tin thanh toán
        long cost = 0;
        try {
            cost = Long.parseLong(request.getParameter("pointCost"));
        } catch (NumberFormatException e) {
            response.sendRedirect("membership.jsp?error=invalid_data");
            return;
        }

        String packageId = request.getParameter("packageId"); // Ví dụ: BASIC_1T, PREMIUM_6T

        PointDAO pdao = new PointDAO();
        UserDAO udao = new UserDAO();

        // 3. Kiểm tra số dư điểm hiện tại
        long currentPoints = pdao.getTotalPoints(acc.getUserID());

        if (currentPoints >= cost) {

            // A. Thực hiện trừ điểm trong Database
            boolean isSuccess = pdao.updatePointTransaction(
                    acc.getUserID(),
                    cost,
                    "Thanh toán",
                    "Nâng cấp gói: " + packageId
            );

            if (isSuccess) {
                // ==========================================
                // 1. Xác định số tháng và Level thành viên
                // ==========================================
                int monthsToAdd = 0;
                int newLevel = 0;

                if (packageId.contains("BASIC")) {
                    newLevel = 1; // Cấp độ Basic
                    monthsToAdd = packageId.contains("1T") ? 1 : 6;
                } else if (packageId.contains("PREMIUM")) {
                    newLevel = 2; // Cấp độ Premium
                    monthsToAdd = packageId.contains("1T") ? 1 : 6;
                }

                // ==========================================
                // 2. Tính toán ngày hết hạn (Cộng dồn nếu còn hạn)
                // ==========================================
                Calendar cal = Calendar.getInstance();
                
                // Nếu User cũ vẫn còn hạn Premium/Basic, lấy mốc đó làm mốc cộng thêm
                if (acc.getPremiumExpiry() != null && acc.getPremiumExpiry().after(new Date())) {
                    cal.setTime(acc.getPremiumExpiry());
                } else {
                    cal.setTime(new Date()); // Nếu hết hạn hoặc lần đầu mua, tính từ bây giờ
                }

                cal.add(Calendar.MONTH, monthsToAdd);
                Timestamp expiryDate = new Timestamp(cal.getTimeInMillis());

                // ==========================================
                // 3. Cập nhật vào Database (Cả Status, Level và Expiry)
                // ==========================================
                // Bác nhớ thêm cột MemberLevel vào hàm update trong UserDAO nhé
                udao.updatePremiumStatus(acc.getUserID(), true, expiryDate);
                
                // Cập nhật level mới vào DB
                udao.updateMemberLevel(acc.getUserID(), newLevel);

                // ==========================================
                // 4. Gửi thông báo hệ thống (Notification)
                // ==========================================
                NotificationDAO nDao = new NotificationDAO();
                String msg = "Chúc mừng! Bạn đã nâng cấp thành công gói " + packageId 
                           + ". Thời hạn sử dụng đến: " 
                           + new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(expiryDate);
                
                nDao.addNotification(acc.getUserID(), "Nâng cấp thành công", msg);

                // ==========================================
                // 5. Đồng bộ Session (Để giao diện thay đổi ngay lập tức)
                // ==========================================
                acc.setIsPremium(true);
                acc.setPremiumExpiry(expiryDate);
                acc.setMemberLevel(newLevel); // Cập nhật level vào session

                session.setAttribute("account", acc);

                // Cập nhật lại số điểm hiển thị trên Header
                long newPoints = currentPoints - cost;
                session.setAttribute("totalPoints", newPoints);

                // ==========================================
                // 6. Điều hướng về trang chủ tương ứng
                // ==========================================
                String redirectPage = "index.jsp";
                if ("Caregiver".equalsIgnoreCase(acc.getRole())) {
                    redirectPage = "home_caregiver.jsp";
                } else if ("Elderly".equalsIgnoreCase(acc.getRole())) {
                    redirectPage = "home_elderly.jsp";
                }
                
                response.sendRedirect(redirectPage + "?upgrade_success=true");

            } else {
                response.sendRedirect("membership.jsp?error=transaction_failed");
            }
        } else {
            response.sendRedirect("membership.jsp?error=not_enough_points");
        }
    }
}