package controller;

import dao.PurchaseOrderDAO;
import dto.PurchaseOrderDetailDTO;
import dto.PurchaseOrderListDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.ViewPath;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/purchase-orders"})
public class PurchaseOrderController extends HttpServlet {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // GET vẫn cho phép gõ URL /purchase-orders => list
            forwardList(request, response);
        } catch (Exception ex) {
            Logger.getLogger(PurchaseOrderController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) action = "list";

        try {
            switch (action) {
                case "detail" -> forwardDetail(request, response);
                case "list" -> forwardList(request, response);
                default -> forwardList(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void forwardList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int page = parseInt(request.getParameter("page"), DEFAULT_PAGE);
        int size = DEFAULT_SIZE;
        int offset = (page - 1) * size;

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        List<PurchaseOrderListDTO> pos = dao.getPurchaseOrderList(size, offset);

        request.setAttribute("pos", pos);
        request.setAttribute("page", page);

        request.getRequestDispatcher(ViewPath.PO_LIST).forward(request, response);
    }

    private void forwardDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        long poId = parseLong(request.getParameter("id"), -1);
        if (poId <= 0) {
            // nếu không có id hợp lệ thì quay về list
            forwardList(request, response);
            return;
        }

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        List<PurchaseOrderDetailDTO> lines = dao.getPurchaseOrderDetailLines(poId);

        request.setAttribute("poId", poId);
        request.setAttribute("lines", lines);

        request.getRequestDispatcher(ViewPath.PO_DETAIL).forward(request, response);
    }

    private int parseInt(String raw, int def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Integer.parseInt(raw);
        } catch (Exception e) {
            return def;
        }
    }

    private long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw);
        } catch (Exception e) {
            return def;
        }
    }
}
