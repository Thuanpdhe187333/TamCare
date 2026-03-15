package controller;

import dal.PointDAO;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Thiết lập tiếng Việt
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Gọi DAO (Lúc này udb.login đã lấy được IsPremium từ DB)
        UserDAO udb = new UserDAO();
        User user = udb.login(email, pass);

        if (user != null) {
            HttpSession session = request.getSession();
            
            // 3. Đưa đối tượng User (đã có trạng thái Premium) vào Session
            session.setAttribute("account", user);

            // 4. Đồng bộ Point kiểu long để Header hiển thị đúng số dư hàng tỷ
            PointDAO pdao = new PointDAO();
            long currentPoints = pdao.getTotalPoints(user.getUserID());
            session.setAttribute("totalPoints", currentPoints);

            // 5. Điều hướng theo vai trò
            String role = user.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect("admin");
            } else if ("Elderly".equalsIgnoreCase(role)) {
                response.sendRedirect("home_elderly.jsp");
            } else if ("Caregiver".equalsIgnoreCase(role)) {
                response.sendRedirect("home_caregiver.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // 6. Đăng nhập thất bại
            request.setAttribute("error", "Email hoặc Mật khẩu không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}