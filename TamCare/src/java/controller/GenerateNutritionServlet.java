package controller;

import dal.AINutritionDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "GenerateNutrition", urlPatterns = {"/GenerateNutritionServlet"})
public class GenerateNutritionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String pid = request.getParameter("profileId");
        int profileId = 0;
        if (pid != null && !pid.isEmpty()) {
            try {
                profileId = Integer.parseInt(pid);
            } catch (NumberFormatException e) { }
        }
        if (profileId <= 0) {
            response.sendRedirect("home_elderly.jsp");
            return;
        }
        AINutritionDAO dao = new AINutritionDAO();
        dao.buildAndSaveRecommendation(profileId);
        response.sendRedirect("home_elderly.jsp");
    }
}
