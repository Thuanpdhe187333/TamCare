package controller;

import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "MyRelativesServlet", urlPatterns = {"/my-relatives"})
public class MyRelativesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        // 1. Kiểm tra đăng nhập và vai trò
        if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. KIỂM TRA MỞ KHÓA (PREMIUM)
        if (!acc.isIsPremium()) {
            response.sendRedirect("membership.jsp?msg=lock");
            return;
        }

        // 3. Nếu đã là Premium thì mới lấy dữ liệu
        UserDAO dao = new UserDAO();
        List<User> elderlyList = dao.getLinkedElderlyList_ByRelationship(acc.getUserID());

        request.setAttribute("elderlyList", elderlyList);
        request.getRequestDispatcher("my_relatives.jsp").forward(request, response);
    }
}