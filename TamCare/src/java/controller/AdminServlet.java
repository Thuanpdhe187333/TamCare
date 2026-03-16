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

@WebServlet(name="AdminServlet", urlPatterns={"/admin", "/delete-user"})
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        // BẢO MẬT: Chỉ Admin mới được vào
        if (acc == null || !"Admin".equals(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getServletPath();

        if (action.equals("/delete-user")) {
            // Xử lý xóa user
            int id = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            dao.deleteUser(id);
            response.sendRedirect("admin"); // Load lại trang admin
        } else {
            // Mặc định: Load danh sách user
            UserDAO dao = new UserDAO();
            List<User> list = dao.getAllUsers();
            request.setAttribute("listUsers", list);
            request.getRequestDispatcher("home_admin.jsp").forward(request, response);
        }
    } 
}