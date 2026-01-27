package controller;

import dao.GoodsReceiptDAO;
import dao.PurchaseOrderDAO;
import dao.SupplierDAO;
import dto.GoodsReceiptListDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GoodsReceipt;
import model.User;
import util.ViewPath;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "GoodsReceiptController", urlPatterns = { "/goods-receipt" })
public class GoodsReceiptController extends HttpServlet {
    // We instantiate DAOs per request to avoid "connection closed" issues
    // while respecting the "don't edit other files" constraint.

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list" ->
                    handleList(request, response);
                case "create" ->
                    handleCreateForm(request, response);
                case "detail" ->
                    handleDetail(request, response);
                default ->
                    response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        SupplierDAO supplierDao = new SupplierDAO();
        String grnNumber = request.getParameter("grnNumber");
        String supplierIdStr = request.getParameter("supplierId");
        Long supplierId = (supplierIdStr != null && !supplierIdStr.isBlank()) ? Long.parseLong(supplierIdStr) : null;
        String status = request.getParameter("status");
        String sortField = request.getParameter("sortBy");
        String sortOrder = request.getParameter("order");

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isBlank()) {
            page = Integer.parseInt(pageStr);
        }
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        List<GoodsReceiptListDTO> grns = grnDao.getFilteredGRNs(grnNumber, supplierId, status, sortField, sortOrder,
                pageSize, offset);
        int total = grnDao.countFilteredGRNs(grnNumber, supplierId, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("grns", grns);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("suppliers", supplierDao.getActiveSuppliers());

        request.getRequestDispatcher(ViewPath.GRN_LIST).forward(request, response);
    }

    private void handleCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        SupplierDAO supplierDao = new SupplierDAO();
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        request.setAttribute("suppliers", supplierDao.getActiveSuppliers());
        request.setAttribute("variants", grnDao.getActiveVariants());
        request.getRequestDispatcher(ViewPath.GRN_CREATE).forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        Long id = Long.parseLong(request.getParameter("id"));
        GoodsReceipt grn = grnDao.getById(id);
        if (grn == null) {
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
            return;
        }
        request.setAttribute("grn", grn);
        request.setAttribute("lines", grnDao.getLinesByGrnId(id));
        request.getRequestDispatcher(ViewPath.GRN_DETAIL).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("save".equals(action)) {
                handleSave(request, response);
            } else if ("approve".equals(action)) {
                handleApprove(request, response, "APPROVED");
            } else if ("reject".equals(action)) {
                handleApprove(request, response, "REJECTED");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen");
            return;
        }

        GoodsReceipt grn = new GoodsReceipt();
        grn.setGrnNumber(request.getParameter("grnNumber"));
        grn.setPoId(Long.parseLong(request.getParameter("poId")));

        // Default Warehouse ID to 1 since it's removed from UI
        String whId = request.getParameter("warehouseId");
        grn.setWarehouseId((whId != null && !whId.isBlank()) ? Long.parseLong(whId) : 1L);

        grn.setCreatedBy(user.getUserId());
        grn.setDeliveredBy(request.getParameter("deliveredBy"));
        grn.setNote(request.getParameter("note"));

        java.util.List<model.GoodsReceiptLine> lines = new java.util.ArrayList<>();
        for (int i = 0; i < 100; i++) { // Max 100 lines for demo
            String vid = request.getParameter("lines[" + i + "].variantId");
            if (vid == null || vid.isBlank()) {
                continue;
            }

            model.GoodsReceiptLine line = new model.GoodsReceiptLine();
            line.setVariantId(Long.parseLong(vid));
            line.setQtyExpected(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyExpected")));
            line.setQtyReceived(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyGood"))); // received
            // = good
            // for now
            line.setQtyGood(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyGood")));
            line.setQtyDamaged(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyDamaged")));
            line.setQtyMissing(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyMissing")));
            line.setQtyExtra(new java.math.BigDecimal(request.getParameter("lines[" + i + "].qtyExtra")));
            line.setNote(request.getParameter("lines[" + i + "].note"));
            lines.add(line);
        }

        grnDao.createGRN(grn, lines);
        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response, String status)
            throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        Long id = Long.parseLong(request.getParameter("id"));
        User user = (User) request.getSession().getAttribute("USER");
        if (user != null) {
            grnDao.updateStatus(id, status, user.getUserId());
        }
        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=detail&id=" + id);
    }
}
