package controller;

import dal.DailyCheckinDAO;
import dal.CheckinNotificationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "dailycheckin", urlPatterns = {"/daily-checkin"})
public class DailyCheckinServlet extends HttpServlet {

    private final DailyCheckinDAO dao = new DailyCheckinDAO();
    private final CheckinNotificationDAO notiDao = new CheckinNotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int elderlyUserId = acc.getUserID();

        boolean alreadyCheckedIn = dao.hasCheckedInToday(elderlyUserId);

        String message;
        if (alreadyCheckedIn) {
            message = "Bác đã điểm danh hôm nay rồi, cảm ơn bác ạ!";
        } else {
            dao.insertCheckin(elderlyUserId);
            notiDao.createForDailyCheckin(elderlyUserId);
            message = "Bác đã điểm danh thành công hôm nay. Con cháu và người chăm sóc sẽ thấy tình trạng bác là \"đã điểm danh\".";
        }

        request.setAttribute("checkinMessage", message);
        request.setAttribute("checkinAlready", alreadyCheckedIn);

        request.getRequestDispatcher("home_elderly.jsp").forward(request, response);
    }
}

