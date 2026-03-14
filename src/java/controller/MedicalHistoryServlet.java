package controller;

import dal.MedicalHistoryDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.MedicalHistory;

@WebServlet(name="medicalhistory", urlPatterns={"/MedicalHistoryServlet"})
public class MedicalHistoryServlet extends HttpServlet {

    MedicalHistoryDAO dao = new MedicalHistoryDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // lấy profileId từ URL
        String pid = req.getParameter("profileId");

        int profileId = 0;

        if (pid != null && !pid.isEmpty()) {
            profileId = Integer.parseInt(pid);
        }

        // lấy danh sách bệnh án
        List<MedicalHistory> list = dao.getByProfileId(profileId);

        req.setAttribute("histories", list);
        req.setAttribute("profileId", profileId);

        // chuyển sang JSP
        req.getRequestDispatcher("medical-history.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    try {

        int profileId = Integer.parseInt(req.getParameter("profileId"));

        String diseaseCode = req.getParameter("diseaseCode");
        String conditionName = req.getParameter("conditionName");
        String historyType = req.getParameter("historyType");
        String currentStatus = req.getParameter("currentStatus");

        MedicalHistory m = new MedicalHistory();

        m.setProfileId(profileId);
        m.setDiseaseCode(diseaseCode);
        m.setConditionName(conditionName);
        m.setHistoryType(historyType);
        m.setCurrentStatus(currentStatus);

        dao.insert(m);

        resp.sendRedirect("MedicalHistoryServlet?profileId=" + profileId);

    } catch (Exception e) {
        e.printStackTrace();
    }
}
}