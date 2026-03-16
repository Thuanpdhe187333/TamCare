package controller;

import dal.CareTaskDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CareTaskInstance;
import model.User;

@WebServlet(name = "ElderlyCalendarServlet", urlPatterns = {"/elderly-calendar"})
public class ElderlyCalendarServlet extends HttpServlet {

    private final CareTaskDAO taskDao = new CareTaskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        if (acc == null || !"Elderly".equalsIgnoreCase(acc.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        LocalDate today = LocalDate.now();

        int year;
        int month;
        try {
            year = Integer.parseInt(request.getParameter("year"));
            month = Integer.parseInt(request.getParameter("month"));
        } catch (Exception e) {
            year = today.getYear();
            month = today.getMonthValue();
        }

        if (month < 1) {
            month = 12;
            year--;
        } else if (month > 12) {
            month = 1;
            year++;
        }

        LocalDate firstDay = LocalDate.of(year, month, 1);
        int daysInMonth = firstDay.lengthOfMonth();
        int firstDayOfWeek = firstDay.getDayOfWeek().getValue(); // 1=Mon..7=Sun

        String selectedDateStr = request.getParameter("selectedDate");
        LocalDate selectedDate;
        if (selectedDateStr != null && !selectedDateStr.isEmpty()) {
            selectedDate = LocalDate.parse(selectedDateStr);
        } else {
            selectedDate = today.withDayOfMonth(Math.min(today.getDayOfMonth(), daysInMonth));
        }

        List<CareTaskInstance> monthTasks
                = taskDao.getTaskInstancesForMonth(acc.getUserID(), year, month);

        Map<String, Integer> dayTaskCounts = new HashMap<>();
        Map<String, Boolean> dayHasCompleted = new HashMap<>();
        for (CareTaskInstance inst : monthTasks) {
            String key = inst.getTaskDate().toString();
            dayTaskCounts.put(key, dayTaskCounts.getOrDefault(key, 0) + 1);
            if (inst.isCompleted()) {
                dayHasCompleted.put(key, true);
            }
        }

        List<CareTaskInstance> dayTasks
                = taskDao.getTaskInstancesForDate(acc.getUserID(), selectedDate);

        request.setAttribute("year", year);
        request.setAttribute("month", month);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("firstDayOfWeek", firstDayOfWeek);
        request.setAttribute("today", today);
        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("dayTaskCounts", dayTaskCounts);
        request.setAttribute("dayHasCompleted", dayHasCompleted);
        request.setAttribute("dayTasks", dayTasks);

        request.getRequestDispatcher("elderly_calendar.jsp")
                .forward(request, response);
    }
}

