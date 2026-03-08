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

@WebServlet(name = "LinkElderlyServlet", urlPatterns = {"/link-elderly"})
public class LinkElderlyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String linkKey = request.getParameter("linkKey");

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDAO dao = new UserDAO();
        Integer elderlyId = dao.getElderlyIdByLinkKey(linkKey);

        if (elderlyId == null) {
            session.setAttribute("link_error", "Mã kết nối không đúng hoặc không thuộc tài khoản Elderly!");
            response.sendRedirect("my-relatives");
            return;
        }

        dao.linkCaregiverToElderly_Relationship(acc.getUserID(), elderlyId);
        session.setAttribute("link_success", "Liên kết thành công!");
        response.sendRedirect("my-relatives");
    }
}