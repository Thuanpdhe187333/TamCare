package controller;

import dao.PickWaveDAO;
import dao.PickTaskDAO;
import dao.GoodsDeliveryNoteDAO;
import dto.PickWaveDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PickWaveController", urlPatterns = { "/pick-wave" })
public class PickWaveController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list" -> handleList(request, response);
                case "detail" -> handleDetail(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/pick-wave?action=list");
            }
        } catch (Exception e) {
            Logger.getLogger(PickWaveController.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException(e);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String status = request.getParameter("status");
        PickWaveDAO waveDao = new PickWaveDAO();
        List<PickWaveDTO> waves = waveDao.getWavesByStatus(status);
        request.setAttribute("waves", waves);
        request.setAttribute("status", status);
        request.getRequestDispatcher("/WEB-INF/views/outbound/pick-wave-list.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long waveId = parseLong(request.getParameter("id"), -1);
        if (waveId <= 0) {
            response.sendRedirect(request.getContextPath() + "/pick-wave?action=list");
            return;
        }
        PickWaveDAO waveDao = new PickWaveDAO();
        PickWaveDTO wave = waveDao.getWaveById(waveId);
        if (wave == null) {
            response.sendRedirect(request.getContextPath() + "/pick-wave?action=list");
            return;
        }
        PickTaskDAO taskDao = new PickTaskDAO();
        request.setAttribute("wave", wave);
        request.setAttribute("tasks", taskDao.getTasksByWaveId(waveId));
        request.getRequestDispatcher("/WEB-INF/views/outbound/pick-wave-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            try {
                handleCreate(request, response);
            } catch (Exception e) {
                Logger.getLogger(PickWaveController.class.getName()).log(Level.SEVERE, null, e);
                throw new ServletException(e);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/pick-wave?action=list");
        }
    }

    /**
     * Create wave from GDN: insert pick_wave, create tasks from wave (by zone/slot), update GDN ONGOING, redirect to assign.
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long gdnId = parseLong(request.getParameter("gdnId"), -1);
        if (gdnId <= 0) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
            return;
        }

        GoodsDeliveryNoteDAO gdnDao = new GoodsDeliveryNoteDAO();
        dto.GDNDetailDTO gdn = gdnDao.getGDNDetailById(gdnId);
        if (gdn == null) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
            return;
        }

        // Validate kỹ dữ liệu GDN trước khi tạo wave
        if (!"PENDING".equalsIgnoreCase(gdn.getStatus())) {
            request.setAttribute("gdn", gdn);
            request.setAttribute("error", "Pick wave can only be created for GDN in PENDING status.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }
        if (gdn.getWarehouseId() == null) {
            request.setAttribute("gdn", gdn);
            request.setAttribute("error", "GDN has no warehouse assigned. Please check the configuration.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }
        if (gdn.getLines() == null || gdn.getLines().isEmpty()) {
            request.setAttribute("gdn", gdn);
            request.setAttribute("error", "GDN has no lines to create a pick wave.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }
        boolean insufficientTotalStock = gdn.getLines().stream().anyMatch(
                l -> l.getQtyRequired() != null && l.getQtyRequired().compareTo(java.math.BigDecimal.ZERO) > 0
                        && (l.getQtyAvailable() == null || l.getQtyAvailable().compareTo(l.getQtyRequired()) < 0)
        );
        if (insufficientTotalStock) {
            request.setAttribute("gdn", gdn);
            request.setAttribute("error", "Total inventory is not enough for some GDN lines. Please check requested quantity and inventory.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }

        PickWaveDAO waveDao = new PickWaveDAO();
        if (waveDao.getWaveByGdnId(gdnId) != null) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=detail&id=" + gdnId);
            return;
        }

        User user = (User) request.getSession().getAttribute("USER");
        Long createdBy = user != null ? user.getUserId() : null;

        Long waveId = waveDao.createWaveFromGDN(gdnId, createdBy);
        if (waveId == null) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=detail&id=" + gdnId);
            return;
        }

        PickTaskDAO taskDao = new PickTaskDAO();
        boolean created;
        try {
            created = taskDao.createTasksFromWave(waveId);
        } catch (Exception ex) {
            // Bất kỳ lỗi nào trong quá trình tạo task cũng không được giữ wave lại
            waveDao.deleteWaveById(waveId);
            dto.GDNDetailDTO refreshedGdn = gdnDao.getGDNDetailById(gdnId);
            request.setAttribute("gdn", refreshedGdn);
            request.setAttribute("error", "Cannot create pick wave due to related data error (GDN/Inventory). Please check and try again.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }
        if (!created) {
            // Không đủ tồn kho theo từng slot để tạo đầy đủ pick task -> xóa wave và báo lỗi
            waveDao.deleteWaveById(waveId);
            dto.GDNDetailDTO refreshedGdn = gdnDao.getGDNDetailById(gdnId);
            request.setAttribute("gdn", refreshedGdn);
            request.setAttribute("error", "Insufficient inventory at locations to create pick wave. Please check inventory or adjust quantity.");
            request.getRequestDispatcher("WEB-INF/views/outbound/goods-delivery-note-detail.jsp")
                   .forward(request, response);
            return;
        }

        waveDao.updateWaveStatus(waveId, "CREATED");
        gdnDao.updateGDNStatus(gdnId, "ONGOING");

        response.sendRedirect(request.getContextPath() + "/pick-task?action=assign&waveId=" + waveId);
    }

    private long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw.trim());
        } catch (Exception e) {
            return def;
        }
    }
}
