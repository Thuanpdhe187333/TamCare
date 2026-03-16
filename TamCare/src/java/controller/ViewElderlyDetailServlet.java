package controller;

import dal.ProfileDAO;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ElderlyProfile;
import model.User;

@WebServlet(name = "ViewElderlyDetailServlet", urlPatterns = {"/view-elderly-detail"})
public class ViewElderlyDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        if (acc == null || !"Caregiver".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idRaw = request.getParameter("id");
        int elderlyId;
        try {
            elderlyId = Integer.parseInt(idRaw);
        } catch (Exception e) {
            response.sendRedirect("my-relatives");
            return;
        }

        UserDAO udao = new UserDAO();

        // Chặn xem trộm: chỉ xem được nếu đã liên kết
        if (!udao.isCaregiverLinkedToElderly(acc.getUserID(), elderlyId)) {
            session.setAttribute("link_error", "Bạn chưa được cấp quyền xem hồ sơ người này!");
            response.sendRedirect("my-relatives");
            return;
        }

        User elderlyInfo = udao.getUserById(elderlyId);
        ProfileDAO pdao = new ProfileDAO();
        ElderlyProfile profile = pdao.getLatestProfileByUserID(elderlyId);

        request.setAttribute("info", elderlyInfo);
        request.setAttribute("profile", profile);

        request.getRequestDispatcher("caregiver_elderly_detail.jsp").forward(request, response);
    }
}
