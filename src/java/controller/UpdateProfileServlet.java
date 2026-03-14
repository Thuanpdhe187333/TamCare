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

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/UpdateProfileServlet"})
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phoneNumber");
        String gender = request.getParameter("gender");
        String birthYearStr = request.getParameter("birthYear");
        Integer birthYear = null;
        try {
            if (birthYearStr != null && !birthYearStr.isEmpty()) {
                birthYear = Integer.parseInt(birthYearStr);
            }
        } catch (NumberFormatException ignored) {}

        UserDAO dao = new UserDAO();
        dao.updateBasicProfile(acc.getUserID(), fullName, phone, gender, birthYear);

        // Cập nhật lại object trong session để UI hiển thị mới
        acc.setFullName(fullName);
        acc.setPhoneNumber(phone);
        acc.setGender(gender);
        acc.setBirthYear(birthYear);
        session.setAttribute("account", acc);

        response.sendRedirect("profile.jsp");
    }
}

