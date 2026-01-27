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
                case "edit" ->
                    handleEditForm(request, response);
                case "delete" ->
                    handleDelete(request, response);
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
        request.setAttribute("purchaseOrders", grnDao.getPurchaseOrdersForSelection());
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

    private void handleEditForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        SupplierDAO supplierDao = new SupplierDAO();
        Long id = Long.parseLong(request.getParameter("id"));
        GoodsReceipt grn = grnDao.getById(id);

        if (grn == null || !"PENDING".equals(grn.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=detail&id=" + id);
            return;
        }

        List<model.GoodsReceiptLine> lines = grnDao.getLinesByGrnId(id);

        request.setAttribute("suppliers", supplierDao.getActiveSuppliers());
        request.setAttribute("variants", grnDao.getActiveVariants());
        request.setAttribute("purchaseOrders", grnDao.getPurchaseOrdersForSelection());

        // Pre-fill fields for the CREATE form to reuse it
        request.setAttribute("grnId", grn.getGrnId());
        request.setAttribute("oldGrnNumber", grn.getGrnNumber());
        request.setAttribute("oldPoId", grn.getPoId());
        request.setAttribute("oldSupplierId", null); // We don't save supplier directly on GRN
        request.setAttribute("oldNote", grn.getNote());

        List<java.util.Map<String, String>> lineMaps = lines.stream().map(l -> {
            java.util.Map<String, String> m = new java.util.HashMap<>();
            m.put("variantId", String.valueOf(l.getVariantId()));
            m.put("qtyGood", String.valueOf(l.getQtyGood()));
            m.put("qtyDamaged", String.valueOf(l.getQtyDamaged()));
            m.put("qtyMissing", String.valueOf(l.getQtyMissing()));
            m.put("note", l.getNote());
            return m;
        }).collect(Collectors.toList());
        request.setAttribute("oldLines", lineMaps);

        request.getRequestDispatcher(ViewPath.GRN_CREATE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null) {
            action = action.trim().toLowerCase();
        }

        try {
            if ("save".equals(action)) {
                handleSave(request, response);
            } else if ("approve".equals(action)) {
                handleApprove(request, response, "APPROVED");
            } else if ("reject".equals(action)) {
                handleApprove(request, response, "REJECTED");
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleSave(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            // Tạm thời gán User mặc định để test khi AuthFilter bị tắt
            user = new User();
            user.setUserId(1L);
        }

        String grnIdStr = request.getParameter("grnId");
        Long existingId = (grnIdStr != null && !grnIdStr.isBlank()) ? Long.parseLong(grnIdStr) : null;

        String grnNumber = request.getParameter("grnNumber");
        String poIdStr = request.getParameter("poId");
        String supplierIdStr = request.getParameter("supplierId");
        String note = request.getParameter("note");

        java.util.Map<String, String> fieldErrors = new java.util.HashMap<>();
        if (grnNumber == null || grnNumber.isBlank()) {
            fieldErrors.put("grnNumber", "GRN Number is required");
        } else {
            try {
                if (grnDao.isGrnNumberExists(grnNumber, existingId)) {
                    fieldErrors.put("grnNumber", "Mã phiếu này (" + grnNumber + ") đã tồn tại trong hệ thống!");
                }
            } catch (SQLException e) {
                // Ignore error for check
            }
        }
        Long poId = null;
        try {
            if (poIdStr == null || poIdStr.isBlank()) {
                fieldErrors.put("poId", "Reference PO ID is required");
            } else {
                poId = Long.parseLong(poIdStr);
            }
        } catch (NumberFormatException e) {
            fieldErrors.put("poId", "Invalid PO ID format");
        }

        java.util.List<model.GoodsReceiptLine> validLines = new java.util.ArrayList<>();
        java.util.List<java.util.Map<String, String>> allSubmittedLines = new java.util.ArrayList<>();

        boolean hasIncompleteRow = false;
        for (int i = 0; i < 100; i++) {
            String vid = request.getParameter("lines[" + i + "].variantId");
            String qGood = request.getParameter("lines[" + i + "].qtyGood");

            // If we have no data for this index, assume no more lines follow
            if (vid == null && qGood == null)
                break;

            java.util.Map<String, String> rowData = new java.util.HashMap<>();
            rowData.put("variantId", vid != null ? vid : "");
            rowData.put("qtyGood", qGood != null ? qGood : "0");
            rowData.put("qtyDamaged", request.getParameter("lines[" + i + "].qtyDamaged"));
            rowData.put("qtyMissing", request.getParameter("lines[" + i + "].qtyMissing"));
            rowData.put("note", request.getParameter("lines[" + i + "].note"));
            allSubmittedLines.add(rowData);

            if (vid == null || vid.isBlank()) {
                hasIncompleteRow = true;
                continue;
            }

            try {
                model.GoodsReceiptLine line = new model.GoodsReceiptLine();
                line.setVariantId(Long.parseLong(vid));

                String qExp = request.getParameter("lines[" + i + "].qtyExpected");
                line.setQtyExpected(
                        qExp != null && !qExp.isBlank() ? new java.math.BigDecimal(qExp) : java.math.BigDecimal.ZERO);

                line.setQtyGood(new java.math.BigDecimal(rowData.get("qtyGood")));
                line.setQtyReceived(line.getQtyGood());

                String qDam = rowData.get("qtyDamaged");
                line.setQtyDamaged(
                        qDam != null && !qDam.isBlank() ? new java.math.BigDecimal(qDam) : java.math.BigDecimal.ZERO);

                String qMiss = rowData.get("qtyMissing");
                line.setQtyMissing(qMiss != null && !qMiss.isBlank() ? new java.math.BigDecimal(qMiss)
                        : java.math.BigDecimal.ZERO);

                String qExt = request.getParameter("lines[" + i + "].qtyExtra");
                line.setQtyExtra(
                        qExt != null && !qExt.isBlank() ? new java.math.BigDecimal(qExt) : java.math.BigDecimal.ZERO);

                line.setNote(rowData.get("note"));
                validLines.add(line);
            } catch (Exception e) {
                fieldErrors.put("lines", "Dữ liệu dòng hàng không hợp lệ: " + e.getMessage());
            }
        }

        if (allSubmittedLines.isEmpty()) {
            fieldErrors.put("lines", "Vui lòng bấm 'Add Line' để nhập hàng.");
        } else if (validLines.isEmpty() || hasIncompleteRow) {
            if (validLines.isEmpty()) {
                fieldErrors.put("lines", "Bạn chưa chọn Sản phẩm cho (các) dòng hàng.");
            } else {
                fieldErrors.put("lines", "Vui lòng chọn Sản phẩm cho tất cả các dòng hàng đã thêm.");
            }
        }

        if (!fieldErrors.isEmpty()) {
            request.setAttribute("fieldErrors", fieldErrors);
            request.setAttribute("grnId", existingId);
            request.setAttribute("oldGrnNumber", grnNumber);
            request.setAttribute("oldPoId", poIdStr);
            request.setAttribute("oldSupplierId", supplierIdStr);
            request.setAttribute("oldNote", note);
            request.setAttribute("oldLines", allSubmittedLines);
            handleCreateForm(request, response);
            return;
        }

        GoodsReceipt grn = new GoodsReceipt();
        if (existingId != null) {
            // Check status again before update
            GoodsReceipt old = grnDao.getById(existingId);
            if (old == null || !"PENDING".equals(old.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
                return;
            }
            grn.setGrnId(existingId);
        }
        grn.setGrnNumber(grnNumber);
        grn.setPoId(poId);

        // Default Warehouse ID to 1 since it's removed from UI
        String whIdStr = request.getParameter("warehouseId");
        grn.setWarehouseId((whIdStr != null && !whIdStr.isBlank()) ? Long.parseLong(whIdStr) : 1L);

        grn.setCreatedBy(user.getUserId());
        grn.setNote(note);

        if (existingId != null) {
            grnDao.updateGRN(grn, validLines);
        } else {
            grnDao.createGRN(grn, validLines);
        }
        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        String idStr = request.getParameter("id");
        if (idStr != null) {
            Long id = Long.parseLong(idStr);
            GoodsReceipt grn = grnDao.getById(id);
            if (grn != null && "PENDING".equals(grn.getStatus())) {
                grnDao.deleteGRN(id);
            }
        }
        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response, String status)
            throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isBlank()) {
            Long id = Long.parseLong(idStr);
            User user = (User) request.getSession().getAttribute("USER");
            if (user == null) {
                // Tạm thời gán User mặc định để test khi AuthFilter bị tắt/chưa login
                user = new User();
                user.setUserId(1L);
            }
            grnDao.updateStatus(id, status, user.getUserId());
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=detail&id=" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
        }
    }
}
