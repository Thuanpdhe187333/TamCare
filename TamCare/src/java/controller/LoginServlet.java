package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Servlet xử lý đăng nhập và phân quyền người dùng.
 * Tương thích với Tomcat 10 (Jakarta Servlet).
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Xử lý yêu cầu GET: Chuyển hướng người dùng đến trang đăng nhập (login.jsp).
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * Xử lý yêu cầu POST: Kiểm tra thông tin đăng nhập và điều hướng theo vai trò (Role).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thiết lập mã hóa để tránh lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");

        // 1. Lấy dữ liệu từ form đăng nhập
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Kiểm tra tài khoản trong cơ sở dữ liệu qua UserDAO
        UserDAO udb = new UserDAO();
        User user = udb.login(email, pass);

        if (user != null) {
            // 3. Đăng nhập thành công: Tạo Session để lưu thông tin người dùng
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            // 4. Lấy vai trò (Role) của người dùng để điều hướng
            String role = user.getRole();

            // Phân luồng điều hướng dựa trên Role trong database
            if ("Admin".equalsIgnoreCase(role)) {
                // Nếu là Quản trị viên -> Chuyển sang trang quản lý hệ thống
                response.sendRedirect("admin");
            } 
            else if ("Elderly".equalsIgnoreCase(role)) {
                // Nếu là Người cao tuổi -> Chuyển sang giao diện đơn giản (home_elderly.jsp)
                response.sendRedirect("home_elderly.jsp");
            } 
            else if ("Caregiver".equalsIgnoreCase(role)) {
                // Nếu là Người chăm sóc -> Chuyển sang giao diện quản lý hồ sơ (home_caregiver.jsp)
                response.sendRedirect("home_caregiver.jsp");
            } 
            else {
                // Vai trò không xác định -> Quay về trang chủ chung
                response.sendRedirect("index.jsp");
            }
        } else {
            // 5. Đăng nhập thất bại: Gửi thông báo lỗi và quay lại trang đăng nhập
            request.setAttribute("error", "Email hoặc Mật khẩu không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    /**
     * Trả về thông tin ngắn gọn về Servlet.
     */
    @Override
    public String getServletInfo() {
        return "LoginServlet handle authentication and role-based redirection";
    }
}