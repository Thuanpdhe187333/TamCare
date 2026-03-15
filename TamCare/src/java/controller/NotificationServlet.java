package controller;

import dal.NotificationDAO;
import model.Notification;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        NotificationDAO nDb = new NotificationDAO();
        // Đánh dấu đã đọc khi xem toàn bộ
        nDb.markAllAsRead(acc.getUserID());

        // Xử lý phân trang
        int page = 1;
        int pageSize = 10; // Hiện 10 cái mỗi trang
        String pageParam = request.getParameter("page");
        if (pageParam != null) page = Integer.parseInt(pageParam);

        List<Notification> list = nDb.getNotificationsByPage(acc.getUserID(), page, pageSize);
        int totalNotis = nDb.getTotalCount(acc.getUserID());
        int totalPages = (int) Math.ceil((double) totalNotis / pageSize);

        request.setAttribute("notiList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}