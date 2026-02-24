package controller;

import dao.ShipmentDAO;
import dao.CarrierDAO;
import dao.SaleOrderDAO;
import dto.ShipmentDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ShipmentController", urlPatterns = { "/shipment" })
public class ShipmentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        try {
            switch (action) {
                case "create" -> handleCreateForm(request, response);
                case "getSoInfo" -> handleGetSoInfo(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/shipment?action=create");
            }
        } catch (Exception e) {
            Logger.getLogger(ShipmentController.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException(e);
        }
    }

    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        CarrierDAO carrierDao = new CarrierDAO();
        request.setAttribute("carriers", carrierDao.getAll());
        request.getRequestDispatcher("WEB-INF/views/outbound/shipment-create.jsp")
               .forward(request, response);
    }

    private void handleGetSoInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ShipmentDAO shipmentDao = new ShipmentDAO();
        String soNumber = request.getParameter("soNumber");
        
        if (soNumber == null || soNumber.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        ShipmentDTO info = shipmentDao.getShipmentInfoBySONumber(soNumber);
        if (info == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"soNumber\":\"").append(escapeJson(info.getSoNumber())).append("\",");
        sb.append("\"customerId\":").append(info.getCustomerId() != null ? info.getCustomerId() : "null").append(",");
        sb.append("\"customerName\":\"").append(escapeJson(info.getCustomerName())).append("\",");
        sb.append("\"shipToAddress\":\"").append(escapeJson(info.getShipToAddress())).append("\",");
        sb.append("\"requestedShipDate\":\"").append(info.getRequestedShipDate() != null ? info.getRequestedShipDate().toString() : "").append("\",");
        sb.append("\"gdnId\":").append(info.getGdnId() != null ? info.getGdnId() : "null").append(",");
        sb.append("\"gdnNumber\":\"").append(escapeJson(info.getGdnNumber())).append("\"");
        sb.append("}");

        response.getWriter().write(sb.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "create" -> handleCreate(request, response);
                case "updateStatus" -> handleUpdateStatus(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/shipment?action=create");
            }
        } catch (Exception e) {
            Logger.getLogger(ShipmentController.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException(e);
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ShipmentDAO shipmentDao = new ShipmentDAO();
        
        String soNumber = request.getParameter("soNumber");
        Long gdnId = parseLong(request.getParameter("gdnId"), -1);
        Long carrierId = parseLong(request.getParameter("carrierId"), -1);
        String shipmentType = request.getParameter("shipmentType");
        
        if (gdnId <= 0 || carrierId <= 0) {
            request.setAttribute("error", "Invalid GDN ID or Carrier ID");
            handleCreateForm(request, response);
            return;
        }

        User user = (User) request.getSession().getAttribute("USER");
        Long createdBy = user != null ? user.getUserId() : null;

        Long shipmentId = shipmentDao.createShipmentFromSO(soNumber, gdnId, carrierId, shipmentType, createdBy);
        
        response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ShipmentDAO shipmentDao = new ShipmentDAO();
        Long shipmentId = parseLong(request.getParameter("shipmentId"), -1);
        String status = request.getParameter("status");
        
        if (shipmentId <= 0 || status == null || status.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        shipmentDao.updateShipmentStatus(shipmentId, status);
        
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":true}");
    }

    private long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw);
        } catch (Exception e) {
            return def;
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
