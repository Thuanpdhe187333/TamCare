package controller;

import dal.PointDAO;
import model.PointHistory;
import model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RewardsServlet", urlPatterns = {"/rewards"})
public class RewardsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User acc = (User) session.getAttribute("account");

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        PointDAO pdao = new PointDAO();
        // 1. Lấy dữ liệu thật từ DB
        int total = pdao.getTotalPoints(acc.getUserID());
        List<PointHistory> history = pdao.getHistoryByUserID(acc.getUserID());

        // 2. Đẩy vào REQUEST cho trang rewards.jsp hiện tại
        request.setAttribute("totalPoints", total);
        request.setAttribute("rewardList", history);
        
        // 3. Đẩy vào SESSION để các trang khác (Profile, Header) hiện đúng
        session.setAttribute("totalPoints", total);

        request.getRequestDispatcher("rewards.jsp").forward(request, response);
    }
}