package controller;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import util.ViewPath;

@WebServlet(name = "AuthenticationController", urlPatterns = {"/authen"})
public class AuthenticationController extends HttpServlet {

    
    private static final String SESSION_USER_KEY = "USER";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // đọc action từ query param
        String action = trimOrEmpty(request.getParameter("action"));

        // logout
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + ViewPath.VIEW_LOGIN);
            return;
        }

        // show forgot page
        if ("forgot".equalsIgnoreCase(action)) {
            request.getRequestDispatcher(ViewPath.VIEW_FORGOT).forward(request, response);
            return;
        }

        // show reset page 
        if ("reset".equalsIgnoreCase(action)) {
            request.getRequestDispatcher(ViewPath.VIEW_RESET).forward(request, response);
            return;
        }

        // default show login
        request.getRequestDispatcher(ViewPath.VIEW_LOGIN).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // đọc action từ form
        String action = trimOrEmpty(request.getParameter("action"));

        // ===== Forgot Password =====
//        if ("forgot".equalsIgnoreCase(action)) {
//            handleForgot(request, response);
//            return;
//        }
//
//        // ===== Reset Password =====
//        if ("reset".equalsIgnoreCase(action)) {
//            handleReset(request, response);
//            return;
//        }

        // ===== Login (mặc định) =====
        handleLogin(request, response);
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // lấy input
        String identity = trimOrEmpty(request.getParameter("username")); // username hoặc email
        String password = trimOrEmpty(request.getParameter("password"));

        // validate basic
        if (identity.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ username/email và password");
            request.getRequestDispatcher(ViewPath.VIEW_LOGIN).forward(request, response);
            return;
        }

        // login
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(identity, password);

        // success
        if (user != null) {
            user.setPasswordHash(null); // bảo mật

            HttpSession session = request.getSession(true);
            session.setAttribute(SESSION_USER_KEY, user);

            // Optional: update last login
            //userDAO.updateLastLogin(user.getUserId(), request.getRemoteAddr());

            response.sendRedirect(request.getContextPath() + "/purchase-orders");
            return;
        }

        // fail
        request.setAttribute("error", "Sai username/email hoặc password");
        request.getRequestDispatcher(ViewPath.VIEW_LOGIN).forward(request, response);
    }

//    private void handleForgot(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // lấy email
//        String email = trimOrEmpty(request.getParameter("email"));
//
//       
//        String msg = "Nếu email tồn tại trong hệ thống, link đặt lại mật khẩu sẽ được gửi.";
//
//        UserDAO userDAO = new UserDAO();
//        User user = userDAO.findByEmail(email);
//
//        // Step 3: nếu có user -> tạo token + tạo link (DEV show)
//        if (user != null) {
//            String rawToken = userDAO.createPasswordResetToken(user.getUserId());
//            if (rawToken != null) {
//                String resetLink = request.getContextPath() + "/authen?action=reset&token=" + rawToken;
//
//                // DEV ONLY
//                request.setAttribute("resetLink", resetLink);
//                System.out.println("RESET LINK: " + resetLink);
//            }
//        }
//
//        // Step 4: forward lại forgot page
//        request.setAttribute("msg", msg);
//        request.getRequestDispatcher(VIEW_FORGOT).forward(request, response);
//    }
//
//    private void handleReset(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Step 1: lấy token + password mới
//        String token = trimOrEmpty(request.getParameter("token"));
//        String newPassword = trimOrEmpty(request.getParameter("newPassword"));
//        String confirm = trimOrEmpty(request.getParameter("confirmPassword"));
//
//        // Step 2: validate
//        if (token.isEmpty()) {
//            request.setAttribute("error", "Token không hợp lệ.");
//            request.getRequestDispatcher(VIEW_RESET).forward(request, response);
//            return;
//        }
//
//        if (newPassword.length() < 6) {
//            request.setAttribute("error", "Mật khẩu tối thiểu 6 ký tự.");
//            request.getRequestDispatcher(VIEW_RESET).forward(request, response);
//            return;
//        }
//
//        if (!newPassword.equals(confirm)) {
//            request.setAttribute("error", "Mật khẩu nhập lại không khớp.");
//            request.getRequestDispatcher(VIEW_RESET).forward(request, response);
//            return;
//        }
//
//        // Step 3: verify token -> lấy userId
//        UserDAO userDAO = new UserDAO();
//        Long userId = userDAO.verifyResetTokenAndGetUserId(token);
//
//        if (userId == null) {
//            request.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
//            request.getRequestDispatcher(VIEW_RESET).forward(request, response);
//            return;
//        }
//
//        // Step 4: hash password mới (BCrypt)
//        String newHash = PasswordUtil.hashPassword(newPassword);
//
//        // Step 5: update password + mark token used
//        boolean updated = userDAO.updatePasswordHash(userId, newHash);
//        boolean marked = userDAO.markResetTokenUsed(token);
//
//        if (!updated || !marked) {
//            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu. Vui lòng thử lại.");
//            request.getRequestDispatcher(VIEW_RESET).forward(request, response);
//            return;
//        }
//
//        // Step 6: về login
//        request.setAttribute("msg", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");
//        request.getRequestDispatcher(VIEW_LOGIN).forward(request, response);
//    }

    // ======================
    // Utils
    // ======================
    private String trimOrEmpty(String s) {
        return s == null ? "" : s.trim();
    }
}