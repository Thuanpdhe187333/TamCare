package controller;

import dao.GoodsReceiptDAO;
import dao.PurchaseOrderDAO;
import dao.SupplierDAO;
import dto.GoodsReceiptListDTO;
import dto.PurchaseOrderHeaderDTO;
import dto.PurchaseOrderLineDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.GoodsReceipt;
import model.User;
import util.ViewPath;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import model.GoodsReceiptLine;
import dao.ZoneDAO;
import dao.SlotDAO;
import dao.InventoryBalanceDAO;
import dao.WarehouseDAO;
import model.Zone;
import model.Slot;
import model.Warehouse;
import java.math.BigDecimal;

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
                case "getPoDetails" ->
                    handleGetPoDetails(request, response);
                case "putaway" ->
                    handlePutaway(request, response);
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

        // Get warehouse name
        WarehouseDAO warehouseDao = new WarehouseDAO();
        Warehouse warehouse = warehouseDao.getWarehouseById(grn.getWarehouseId());
        request.setAttribute("warehouseName", warehouse != null ? warehouse.getName() : "N/A");

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

        List<GoodsReceiptLine> lines = grnDao.getLinesByGrnId(id);

        request.setAttribute("suppliers", supplierDao.getActiveSuppliers());
        request.setAttribute("variants", grnDao.getActiveVariants());
        request.setAttribute("purchaseOrders", grnDao.getPurchaseOrdersForSelection());

        // Pre-fill fields for the CREATE form to reuse it
        request.setAttribute("grnId", grn.getGrnId());
        request.setAttribute("oldGrnNumber", grn.getGrnNumber());
        request.setAttribute("oldPoId", grn.getPoId());
        request.setAttribute("oldSupplierId", null); // We don't save supplier directly on GRN
        request.setAttribute("oldNote", grn.getNote());

        List<Map<String, String>> lineMaps = lines.stream().map(l -> {
            Map<String, String> m = new java.util.HashMap<>();
            m.put("poLineId", String.valueOf(l.getPoLineId()));
            m.put("variantId", String.valueOf(l.getVariantId()));
            m.put("unitPrice", String.valueOf(l.getUnitPrice()));
            m.put("qtyExpected", String.valueOf(l.getQtyExpected()));
            m.put("qtyGood", String.valueOf(l.getQtyGood()));
            m.put("qtyDamaged", String.valueOf(l.getQtyDamaged()));
            m.put("qtyMissing", String.valueOf(l.getQtyMissing()));
            m.put("note", l.getNote());
            return m;
        }).collect(Collectors.toList());
        request.setAttribute("oldLines", lineMaps);

        request.getRequestDispatcher(ViewPath.GRN_CREATE).forward(request, response);
    }

    private void handleGetPoDetails(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        PurchaseOrderDAO poDao = new PurchaseOrderDAO();
        String poIdStr = request.getParameter("poId");
        if (poIdStr == null || poIdStr.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        Long poId = Long.parseLong(poIdStr);

        PurchaseOrderHeaderDTO header = poDao.getPurchaseOrderHeader(poId);
        List<PurchaseOrderLineDTO> lines = poDao.getPurchaseOrderDetailLines(poId);
        String nextGrnNumber = grnDao.getNextGrnNumber();

        if (header == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"supplierId\":").append(header.getSupplierId()).append(",");
        sb.append("\"grnNumber\":\"").append(nextGrnNumber).append("\",");
        sb.append("\"lines\":[");
        for (int i = 0; i < lines.size(); i++) {
            PurchaseOrderLineDTO l = lines.get(i);
            if (i > 0) {
                sb.append(",");
            }
            sb.append("{");
            sb.append("\"poLineId\":").append(l.getPoLineId()).append(",");
            sb.append("\"variantId\":").append(l.getVariantId()).append(",");
            sb.append("\"sku\":\"").append(l.getVariantSku() != null ? l.getVariantSku() : "").append("\",");
            sb.append("\"productName\":\"")
                    .append(l.getProductName() != null ? l.getProductName().replace("\"", "\\\"") : "").append("\",");
            sb.append("\"orderedQty\":").append(l.getOrderedQty()).append(",");
            sb.append("\"unitPrice\":").append(l.getUnitPrice() != null ? l.getUnitPrice() : 0);
            sb.append("}");
        }
        sb.append("]");
        sb.append("}");

        response.getWriter().write(sb.toString());
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
            } else if ("confirmputaway".equals(action)) {
                handleConfirmPutaway(request, response);
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
            user.setRoleNames("ADMIN");
        }

        String grnIdStr = request.getParameter("grnId");
        Long existingId = (grnIdStr != null && !grnIdStr.isBlank()) ? Long.parseLong(grnIdStr) : null;

        String grnNumber = request.getParameter("grnNumber");
        String poIdStr = request.getParameter("poId");
        String supplierIdStr = request.getParameter("supplierId");
        String note = request.getParameter("note");

        Map<String, String> fieldErrors = new HashMap<>();
        if (grnNumber == null || grnNumber.isBlank()) {
            grnNumber = grnDao.getNextGrnNumber();
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

        List<GoodsReceiptLine> validLines = new ArrayList<>();
        List<Map<String, String>> allSubmittedLines = new ArrayList<>();

        boolean hasIncompleteRow = false;
        for (int i = 0; i < 100; i++) {
            String vid = request.getParameter("lines[" + i + "].variantId");
            String qGood = request.getParameter("lines[" + i + "].qtyGood");

            // If we have no data for this index, assume no more lines follow
            if (vid == null && qGood == null)
                break;

            java.util.Map<String, String> rowData = new java.util.HashMap<>();
            rowData.put("variantId", vid != null ? vid : "");
            rowData.put("poLineId", request.getParameter("lines[" + i + "].poLineId"));
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
                String poLineIdStr = rowData.get("poLineId");
                if (poLineIdStr != null && !poLineIdStr.isBlank()) {
                    line.setPoLineId(Long.parseLong(poLineIdStr));
                }

                String qExp = request.getParameter("lines[" + i + "].qtyExpected");
                line.setQtyExpected(
                        qExp != null && !qExp.isBlank() ? new java.math.BigDecimal(qExp) : java.math.BigDecimal.ZERO);

                String qDam = rowData.get("qtyDamaged");
                String qMiss = rowData.get("qtyMissing");

                java.math.BigDecimal g = new java.math.BigDecimal(rowData.get("qtyGood"));
                java.math.BigDecimal d = (qDam != null && !qDam.isBlank()) ? new java.math.BigDecimal(qDam)
                        : java.math.BigDecimal.ZERO;
                java.math.BigDecimal m = (qMiss != null && !qMiss.isBlank()) ? new java.math.BigDecimal(qMiss)
                        : java.math.BigDecimal.ZERO;

                if (g.add(d).add(m).compareTo(java.math.BigDecimal.ZERO) <= 0) {
                    fieldErrors.put("lines",
                            "Mỗi dòng hàng phải có ít nhất một giá trị Số lượng (Good/Damaged/Missing) lớn hơn 0.");
                }

                line.setQtyGood(g);
                line.setQtyReceived(g);
                line.setQtyDamaged(d);
                line.setQtyMissing(m);

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

        Long resultGrnId = null;
        if (existingId != null) {
            grnDao.updateGRN(grn, validLines);
            resultGrnId = existingId;
        } else {
            resultGrnId = grnDao.createGRN(grn, validLines);
        }

        // Cập nhật trạng thái PO sang CLOSED để ẩn đi
        if (poId != null) {
            try {
                PurchaseOrderDAO poDao = new PurchaseOrderDAO();
                poDao.updateStatus(poId, "CLOSED");
            } catch (Exception e) {
                // Log error but don't fail the whole GRN creation
                System.err.println("Error updating PO status: " + e.getMessage());
            }
        }

        // Sau khi lưu thành công, chuyển đến màn hình Putaway
        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=putaway&id=" + resultGrnId);
    }

    private void handlePutaway(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        ZoneDAO zoneDao = new ZoneDAO();
        SlotDAO slotDao = new SlotDAO();

        Long id = Long.parseLong(request.getParameter("id"));
        GoodsReceipt grn = grnDao.getById(id);
        if (grn == null) {
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
            return;
        }

        request.setAttribute("grn", grn);
        request.setAttribute("lines", grnDao.getLinesByGrnId(id));

        // Get warehouse name without modifying model
        WarehouseDAO warehouseDao = new WarehouseDAO();
        Warehouse warehouse = warehouseDao.getWarehouseById(grn.getWarehouseId());
        request.setAttribute("warehouseName", warehouse != null ? warehouse.getName() : "ID: " + grn.getWarehouseId());

        // Tìm các Zone Z-STO và Z-DAM để lấy Slot gợi ý
        List<Zone> zones = zoneDao.getZonesByWarehouseId(grn.getWarehouseId());
        Zone stoZone = zones.stream().filter(z -> "Z-STO".equals(z.getCode())).findFirst().orElse(null);
        Zone damZone = zones.stream().filter(z -> "Z-DAM".equals(z.getCode())).findFirst().orElse(null);

        if (stoZone != null) {
            request.setAttribute("storageSlots", slotDao.getSlotsByZoneId(stoZone.getZoneId()));
        }
        if (damZone != null) {
            request.setAttribute("damageSlots", slotDao.getSlotsByZoneId(damZone.getZoneId()));
        }

        request.getRequestDispatcher(ViewPath.GRN_PUTAWAY).forward(request, response);
    }

    private void handleConfirmPutaway(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsReceiptDAO grnDao = new GoodsReceiptDAO();
        Long grnId = Long.parseLong(request.getParameter("grnId"));

        Object sessionUser = request.getSession().getAttribute("USER");
        Long userId = 1L; // Fallback for testing
        if (sessionUser instanceof model.User) {
            userId = ((model.User) sessionUser).getUserId();
        }

        String[] lineIndices = request.getParameterValues("lineIndices");
        List<model.PutAwayLine> putawayLines = new ArrayList<>();

        if (lineIndices != null) {
            for (String idx : lineIndices) {
                Long grnLineId = Long.parseLong(request.getParameter("grnLineId_" + idx));

                // Process Good items
                String goodQtyStr = request.getParameter("goodQty_" + idx);
                String goodSlotIdStr = request.getParameter("goodSlotId_" + idx);
                if (goodQtyStr != null && !goodQtyStr.isEmpty() && goodSlotIdStr != null && !goodSlotIdStr.isEmpty()) {
                    BigDecimal qty = new BigDecimal(goodQtyStr);
                    if (qty.compareTo(BigDecimal.ZERO) > 0) {
                        model.PutAwayLine pl = new model.PutAwayLine();
                        pl.setGrnLineId(grnLineId);
                        pl.setToSlotId(Long.parseLong(goodSlotIdStr));
                        pl.setQtyPutaway(qty);
                        putawayLines.add(pl);
                    }
                }

                // Process Damaged items
                String damagedQtyStr = request.getParameter("damagedQty_" + idx);
                String damagedSlotIdStr = request.getParameter("damagedSlotId_" + idx);
                if (damagedQtyStr != null && !damagedQtyStr.isEmpty() && damagedSlotIdStr != null
                        && !damagedSlotIdStr.isEmpty()) {
                    BigDecimal qty = new BigDecimal(damagedQtyStr);
                    if (qty.compareTo(BigDecimal.ZERO) > 0) {
                        model.PutAwayLine pl = new model.PutAwayLine();
                        pl.setGrnLineId(grnLineId);
                        pl.setToSlotId(Long.parseLong(damagedSlotIdStr));
                        pl.setQtyPutaway(qty);
                        putawayLines.add(pl);
                    }
                }
            }
        }

        if (!putawayLines.isEmpty()) {
            grnDao.savePutawayInfo(grnId, userId, putawayLines);
        }

        response.sendRedirect(
                request.getContextPath() + "/goods-receipt?action=detail&id=" + grnId + "&putaway=success");
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
        dao.InventoryBalanceDAO invDao = new dao.InventoryBalanceDAO();
        SlotDAO slotDao = new SlotDAO();
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isBlank()) {
            Long id = Long.parseLong(idStr);
            Object sessionUser = request.getSession().getAttribute("USER");
            Long approverId = 1L;
            String userRoles = "ADMIN";

            if (sessionUser instanceof model.User) {
                model.User user = (model.User) sessionUser;
                approverId = user.getUserId();
                userRoles = user.getRoleNames();
            }

            if (userRoles != null && (userRoles.contains("ADMIN") || userRoles.contains("WAREHOUSE_MANAGER"))) {
                GoodsReceipt grn = grnDao.getById(id);
                if (grn != null && ("PENDING".equals(grn.getStatus()) || "DRAFT".equals(grn.getStatus()))) {
                    boolean success = grnDao.updateStatus(id, status, approverId);

                    if (success && "APPROVED".equals(status)) {
                        // EXECUTING ACTUAL INVENTORY UPDATE
                        List<model.PutAwayLine> ptlines = grnDao.getPutawayLinesByGrnId(id);
                        for (model.PutAwayLine pl : ptlines) {
                            Long variantId = grnDao.getVariantIdByGrnLineId(pl.getGrnLineId());
                            if (variantId != null) {
                                String zoneType = slotDao.getZoneTypeBySlotId(pl.getToSlotId());
                                String condition = "GOOD"; // Default
                                if ("DAMAGE".equals(zoneType)) {
                                    condition = "DAMAGED";
                                }
                                invDao.assignProductToSlot(grn.getWarehouseId(), pl.getToSlotId(), variantId, condition,
                                        pl.getQtyPutaway());
                            }
                        }
                    }

                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/goods-receipt?action=detail&id=" + id);
                    } else {
                        response.sendRedirect(
                                request.getContextPath() + "/goods-receipt?action=list&error=update_failed");
                    }
                } else {
                    response.sendRedirect(
                            request.getContextPath() + "/goods-receipt?action=list&error=invalid_status_or_not_found");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/goods-receipt?action=detail&id=" + id
                        + "&error=permission_denied");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/goods-receipt?action=list");
        }
    }
}
