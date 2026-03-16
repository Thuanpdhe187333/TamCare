package controller;

import dal.CareTaskDAO;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ToggleTaskCompletionServlet", urlPatterns = {"/toggle-task-completion"})
public class ToggleTaskCompletionServlet extends HttpServlet {

    private final CareTaskDAO taskDao = new CareTaskDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        if (acc == null || !"Elderly".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        String dateStr = request.getParameter("taskDate");
        String yearStr = request.getParameter("year");
        String monthStr = request.getParameter("month");

        if (taskIdStr != null && dateStr != null) {
            try {
                int taskId = Integer.parseInt(taskIdStr);
                LocalDate date = LocalDate.parse(dateStr);
                taskDao.toggleCompletion(acc.getUserID(), taskId, date);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String redirectUrl = "elderly-calendar";
        if (yearStr != null && monthStr != null && dateStr != null) {
            redirectUrl += "?year=" + yearStr + "&month=" + monthStr
                    + "&selectedDate=" + dateStr;
        }
        response.sendRedirect(redirectUrl);
    }
}

