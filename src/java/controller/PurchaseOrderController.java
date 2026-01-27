package controller;

import dao.PurchaseOrderDAO;
import dao.SupplierDAO;
import dto.POLineCreateDTO;
import dto.ProductVariantDTO;
import dto.PurchaseOrderHeaderDTO;
import dto.PurchaseOrderLineDTO;
import dto.PurchaseOrderListDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.ViewPath;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "PurchaseOrderController", urlPatterns = {"/purchase-orders"})
public class PurchaseOrderController extends HttpServlet {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_SIZE = 5;
    dao.SupplierDAO sDao = new dao.SupplierDAO();
    dao.ProductDAO pDao = new dao.ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "";
            }
            switch (action) {
                case "variants":
                    handleGetVariants(request, response);
                    break;
                case "edit":
                    forwardEditForm(request, response);
                    break;
                default:
                    forwardList(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "list";
        }
        try {
            switch (action) {
                case "detail" ->
                    forwardDetail(request, response);
                case "new" ->
                    forwardCreateForm(request, response);
                case "create" ->
                    handleCreate(request, response);
                case "update" ->
                    handleUpdate(request, response);
                case "delete" ->
                    handleDelete(request, response);
                default ->
                    forwardList(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    //AJAX load Variant
    private void handleGetVariants(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String raw = request.getParameter("productId");
        long productId;
        try {
            productId = Long.parseLong(raw);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        dao.ProductVariantDAO vDao = new dao.ProductVariantDAO();
        //lấy danh sách variant theo productid
        List<ProductVariantDTO> list = vDao.listByProductId(productId);
        //khai báo json
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        StringBuilder sb = new StringBuilder();
        //tạo json thủ công
        sb.append("[");
        for (int i = 0; i < list.size(); i++) {
            dto.ProductVariantDTO v = list.get(i);
            if (i > 0) {
                sb.append(",");
            }
            sb.append("{")
                    .append("\"variantId\":").append(v.getVariantId()).append(",")
                    .append("\"variantSku\":\"").append(esc(v.getVariantSku())).append("\",")
                    .append("\"color\":\"").append(esc(v.getColor())).append("\",")
                    .append("\"size\":\"").append(esc(v.getSize())).append("\"")
                    .append("}");
        }
        sb.append("]");

        response.getWriter().write(sb.toString());
    }

    private void forwardList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int page = parseInt(request.getParameter("page"), DEFAULT_PAGE);
        int size = DEFAULT_SIZE;
        if (page < 1) {
            page = 1;
        }
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String expectedFromStr = request.getParameter("expectedFrom");
        String expectedToStr = request.getParameter("expectedTo");
        if (keyword != null) {
            keyword = keyword.trim();
        }
        //status nếu rỗng thì đổi sang null để DAO hiểu là không filter theo status
        if (status != null && status.isBlank()) {
            status = null;
        }
        Date expectedFrom = parseSqlDate(expectedFromStr);
        Date expectedTo = parseSqlDate(expectedToStr);
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        int totalRecords = dao.countPurchaseOrders(keyword, status, expectedFrom, expectedTo);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        int offset = (page - 1) * size;
        List<PurchaseOrderListDTO> pos
                = dao.searchPurchaseOrders(keyword, status, expectedFrom, expectedTo, size, offset);
        // window pagination
        //luôn hiển thị 2 trang trước 2 trang sau
        int window = 2;
        //dòng 1
        int startPage = Math.max(1, page - window);
        //không vượt quá total page
        int endPage = Math.min(totalPages, page + window);
        if (endPage - startPage < window * 2) {
            if (startPage == 1) {
                endPage = Math.min(totalPages, startPage + window * 2);
            }
            if (endPage == totalPages) {
                startPage = Math.max(1, endPage - window * 2);
            }
        }
        // build baseUrl + queryString (để giữ filter khi bấm page)
        String baseUrl = request.getContextPath() + "/purchase-orders";
        String qs = buildQs(keyword, status, expectedFromStr, expectedToStr); // bắt đầu bằng &
        request.setAttribute("pos", pos);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("baseUrl", baseUrl);
        request.setAttribute("qs", qs);
        // (optional) nếu bạn muốn JSP xài ${keyword} thay vì ${param.keyword}
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("expectedFrom", expectedFromStr);
        request.setAttribute("expectedTo", expectedToStr);

        request.getRequestDispatcher(ViewPath.PO_LIST).forward(request, response);
    }

    private void forwardDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String idStr = request.getParameter("id");
        long poId = (idStr == null || idStr.isBlank()) ? -1L : Long.parseLong(idStr);
        if (poId <= 0) {
            // nếu không có id hợp lệ thì quay về list
            forwardList(request, response);
            return;
        }
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        PurchaseOrderHeaderDTO POheader = dao.getPurchaseOrderHeader(poId);
        List<PurchaseOrderLineDTO> lines = dao.getPurchaseOrderDetailLines(poId);
        request.setAttribute("poId", poId);
        request.setAttribute("POheader", POheader);
        request.setAttribute("lines", lines);
        request.getRequestDispatcher(ViewPath.PO_DETAIL).forward(request, response);
    }

    private void forwardCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setAttribute("suppliers", sDao.getActiveSuppliers());
        request.setAttribute("products", pDao.getProducts());
        request.getRequestDispatcher(ViewPath.PO_FORM_CREATE).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setCharacterEncoding("UTF-8");
        Map<String, String> fieldErrors = new HashMap<>();
        String poNumber = request.getParameter("poNumber");
// SAFE parse supplier
        String supplierStr = request.getParameter("supplierId");
        long supplierId = (supplierStr == null || supplierStr.isBlank()) ? 0L : Long.parseLong(supplierStr);
        String expected = request.getParameter("expectedDeliveryDate");
        Date expectedDate = null;
        if (expected == null || expected.isBlank()) {
            fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date is required");
        } else {
            try {
                expectedDate = Date.valueOf(expected); // yyyy-MM-dd
                // không được hôm nay hoặc quá khứ => phải > today
                //toLocateDate() bỏ giờ lấy ngày
                if (!expectedDate.toLocalDate().isAfter(java.time.LocalDate.now())) {
                    fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date must be after today");
                }
            } catch (Exception e) {
                fieldErrors.put("expectedDeliveryDate", "Invalid date format");
            }
        }
        String note = request.getParameter("note");
        Long userId = (Long) request.getSession().getAttribute("userId");
        if (userId == null) {
            userId = 1L;//admin
        }
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
// PO Number validate
        if (poNumber == null || poNumber.isBlank()) {
            fieldErrors.put("poNumber", "PO Number is required");
        } else if (poNumber.length() > 20) {
            fieldErrors.put("poNumber", "PO Number must be at most 20 characters");
        } else {
            if (dao.existsByPoNumber(poNumber)) {
                fieldErrors.put("poNumber", "PO Number already exists");
            }
        }
// Supplier validate
        if (supplierId <= 0) {
            fieldErrors.put("supplierId", "Supplier is required");
        }
// Lines parse
        List<POLineCreateDTO> lines = new ArrayList<>();
        for (int i = 0; i < 500; i++) {
            String vid = request.getParameter("lines[" + i + "].variantId");
            String qtyStr = request.getParameter("lines[" + i + "].qty");
            if (vid == null || vid.isBlank()) {
                continue;
            }
            if (qtyStr == null || qtyStr.isBlank()) {
                continue;
            }

            try {
                long variantId = Long.parseLong(vid);
                BigDecimal qty = new BigDecimal(qtyStr);
                if (qty.compareTo(BigDecimal.ZERO) <= 0) {
                    fieldErrors.put("lines", "Quantity cannot be negative or equal 0");
                    break;
                }
                String unitStr = request.getParameter("lines[" + i + "].unitPrice");
                BigDecimal unitPrice = (unitStr == null || unitStr.isBlank()) ? null : new BigDecimal(unitStr);
                // unit price không âm
                if (unitPrice != null && unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    fieldErrors.put("lines", "Unit Price cannot be negative or equal 0");
                    break;
                }
                String currency = request.getParameter("lines[" + i + "].currency");
                lines.add(new POLineCreateDTO(variantId, qty, unitPrice, currency));
            } catch (Exception ex) {
                fieldErrors.put("lines", "Lines contains invalid numbers");
                break;
            }
        }

        if (lines.isEmpty()) {
            fieldErrors.putIfAbsent("lines", "At least one line is required");
        }
        List<Map<String, String>> oldLines = new ArrayList<>();
        for (int i = 0; i < 500; i++) {
            String productId = request.getParameter("lines[" + i + "].productId");
            String variantId = request.getParameter("lines[" + i + "].variantId");
            String qty = request.getParameter("lines[" + i + "].qty");
            String unitPrice = request.getParameter("lines[" + i + "].unitPrice");
            String currency = request.getParameter("lines[" + i + "].currency");

            // nếu row hoàn toàn trống -> bỏ qua
            boolean allBlank
                    = (productId == null || productId.isBlank())
                    && (variantId == null || variantId.isBlank())
                    && (qty == null || qty.isBlank())
                    && (unitPrice == null || unitPrice.isBlank())
                    && (currency == null || currency.isBlank());

            if (allBlank) {
                continue;
            }

            Map<String, String> row = new HashMap<>();
            row.put("productId", productId == null ? "" : productId);
            row.put("variantId", variantId == null ? "" : variantId);
            row.put("qty", qty == null ? "" : qty);
            row.put("unitPrice", unitPrice == null ? "" : unitPrice);
            row.put("currency", (currency == null || currency.isBlank()) ? "VND" : currency);

            oldLines.add(row);
        }

        request.setAttribute("oldLines", oldLines);

// If errors -> forward (and remember to set suppliers again!)
        if (!fieldErrors.isEmpty()) {
            request.setAttribute("fieldErrors", fieldErrors);
            request.setAttribute("oldPoNumber", poNumber);
            request.setAttribute("oldSupplierId", supplierId);
            request.setAttribute("oldExpected", expected);
            request.setAttribute("oldNote", note);
            request.setAttribute("oldLines", oldLines);
            request.setAttribute("suppliers", sDao.getActiveSuppliers());
            request.setAttribute("products", pDao.getProducts());
            // IMPORTANT: reload suppliers before forward if JSP needs it
            // request.setAttribute("suppliers", supplierDao.getAllSuppliers());
            request.getRequestDispatcher(ViewPath.PO_FORM_CREATE).forward(request, response);
            return;
        }

        dao.createManualPO(poNumber, supplierId, expectedDate, note, userId, lines);
        response.sendRedirect(request.getContextPath() + "/purchase-orders");

    }

    private void forwardEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        long poId = parseLong(request.getParameter("id"), -1L);
        if (poId <= 0) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
            return;
        }
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        PurchaseOrderHeaderDTO po = dao.getPurchaseOrderHeader(poId);
        if (po == null) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders?msg=notfound");
            return;
        }

        List<PurchaseOrderLineDTO> lines = dao.getPurchaseOrderDetailLines(poId);

        request.setAttribute("po", po);                 // JSP edit dùng "po"
        request.setAttribute("lines", lines);           // JSP edit dùng "lines"
        request.setAttribute("suppliers", sDao.getActiveSuppliers());
        request.setAttribute("products", pDao.getProducts());

        // Nếu bạn chưa muốn load variants sẵn (vì đã có AJAX /purchase-orders?action=variants)
        // thì không cần set "variants"
        request.getRequestDispatcher(ViewPath.PO_FORM_EDIT).forward(request, response);
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        request.setCharacterEncoding("UTF-8");
        Map<String, String> fieldErrors = new HashMap<>();

        long poId = parseLong(request.getParameter("poId"), -1L);
        if (poId <= 0) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
            return;
        }

        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        PurchaseOrderHeaderDTO current = dao.getPurchaseOrderHeader(poId);
        if (current == null) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders?msg=notfound");
            return;
        }

        String poNumber = request.getParameter("poNumber");
        String supplierStr = request.getParameter("supplierId");
        long supplierId = (supplierStr == null || supplierStr.isBlank()) ? 0L : Long.parseLong(supplierStr);

        String expected = request.getParameter("expectedDeliveryDate");
        Date expectedDate = null;
        if (expected == null || expected.isBlank()) {
            fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date is required");
        } else {
            try {
                expectedDate = Date.valueOf(expected); // yyyy-MM-dd
                // không được hôm nay hoặc quá khứ => phải > today
                //toLocateDate() bỏ giờ lấy ngày
                if (!expectedDate.toLocalDate().isAfter(java.time.LocalDate.now())) {
                    fieldErrors.put("expectedDeliveryDate", "Expected Delivery Date must be after today");
                }
            } catch (Exception e) {
                fieldErrors.put("expectedDeliveryDate", "Invalid date format");
            }
        }

        String note = request.getParameter("note");

        // --- Validate header ---
        if (poNumber == null || poNumber.isBlank()) {
            fieldErrors.put("poNumber", "PO Number is required");
        } else if (poNumber.length() > 20) {
            fieldErrors.put("poNumber", "PO Number must be at most 20 characters");
        } else {
            // chỉ check trùng khi user đổi poNumber
            if (!poNumber.equalsIgnoreCase(current.getPoNumber())) {
                if (dao.existsByPoNumber(poNumber)) {
                    fieldErrors.put("poNumber", "PO Number already exists");
                }
            }
        }

        if (supplierId <= 0) {
            fieldErrors.put("supplierId", "Supplier is required");
        }

        // --- Parse lines ---
        List<PurchaseOrderLineDTO> lines = new ArrayList<>();

        for (int i = 0; i < 500; i++) {
            String vid = request.getParameter("lines[" + i + "].variantId");
            String qtyStr = request.getParameter("lines[" + i + "].qty");         // giống create
            String unitStr = request.getParameter("lines[" + i + "].unitPrice");

            // row trống -> bỏ
            if ((vid == null || vid.isBlank())
                    && (qtyStr == null || qtyStr.isBlank())
                    && (unitStr == null || unitStr.isBlank())) {
                continue;
            }

            // thiếu bắt buộc
            if (vid == null || vid.isBlank()) {
                fieldErrors.put("lines", "Variant is required");
                break;
            }
            if (qtyStr == null || qtyStr.isBlank()) {
                fieldErrors.put("lines", "Quantity is required");
                break;
            }

            try {
                long variantId = Long.parseLong(vid);
                BigDecimal qty = new BigDecimal(qtyStr);
                if (qty.compareTo(BigDecimal.ZERO) <= 0) {
                    fieldErrors.put("lines", "Quantity must be > 0");
                    break;
                }

                BigDecimal unitPrice = (unitStr == null || unitStr.isBlank()) ? null : new BigDecimal(unitStr);
                if (unitPrice != null && unitPrice.compareTo(BigDecimal.ZERO) <= 0) {
                    fieldErrors.put("lines", "Unit Price must be > 0");
                    break;
                }

                PurchaseOrderLineDTO l = new PurchaseOrderLineDTO();
                l.setVariantId(variantId);
                l.setOrderedQty(qty);       // DTO của bạn là orderedQty
                l.setUnitPrice(unitPrice);
                lines.add(l);

            } catch (Exception ex) {
                fieldErrors.put("lines", "Lines contains invalid numbers");
                break;
            }
        }

        if (lines.isEmpty()) {
            fieldErrors.putIfAbsent("lines", "At least one line is required");
        }

        // --- Build oldLines để giữ form khi lỗi ---
        List<Map<String, String>> oldLines = new ArrayList<>();
        for (int i = 0; i < 500; i++) {
            String productId = request.getParameter("lines[" + i + "].productId");
            String variantId = request.getParameter("lines[" + i + "].variantId");
            String qty = request.getParameter("lines[" + i + "].qty");
            String unitPrice = request.getParameter("lines[" + i + "].unitPrice");

            boolean allBlank
                    = (productId == null || productId.isBlank())
                    && (variantId == null || variantId.isBlank())
                    && (qty == null || qty.isBlank())
                    && (unitPrice == null || unitPrice.isBlank());

            if (allBlank) {
                continue;
            }

            Map<String, String> row = new HashMap<>();
            row.put("productId", productId == null ? "" : productId);
            row.put("variantId", variantId == null ? "" : variantId);
            row.put("qty", qty == null ? "" : qty);
            row.put("unitPrice", unitPrice == null ? "" : unitPrice);
            oldLines.add(row);
        }

        // --- If errors -> forward edit form ---
        if (!fieldErrors.isEmpty()) {
            PurchaseOrderHeaderDTO po = new PurchaseOrderHeaderDTO();
            po.setPoId(poId);
            po.setPoNumber(poNumber);
            po.setSupplierId(supplierId);
            po.setExpectedDeliveryDate(expectedDate);
            po.setNote(note);

            request.setAttribute("fieldErrors", fieldErrors);
            request.setAttribute("po", po);
            request.setAttribute("lines", dao.getPurchaseOrderDetailLines(poId)); // hoặc bỏ nếu JSP dùng oldLines
            request.setAttribute("oldLines", oldLines);
            request.setAttribute("suppliers", sDao.getActiveSuppliers());
            request.setAttribute("products", pDao.getProducts());

            request.getRequestDispatcher(ViewPath.PO_FORM_EDIT).forward(request, response);
            return;
        }

        // --- Call DAO update ---
        PurchaseOrderHeaderDTO header = new PurchaseOrderHeaderDTO();
        header.setPoId(poId);
        header.setPoNumber(poNumber);
        header.setSupplierId(supplierId);
        header.setExpectedDeliveryDate(expectedDate);
        header.setNote(note);

        dao.updatePurchaseOrder(header, lines);

        response.sendRedirect(request.getContextPath() + "/purchase-orders?action=detail&id=" + poId);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        long poId = Long.parseLong(request.getParameter("id"));
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        boolean ok = dao.deletePurchaseOrder(poId);
        String msg = ok ? "deleted" : "notfound";
        String page = request.getParameter("page");
        String redirectUrl = request.getContextPath() + "/purchase-orders";
        if (page != null && !page.isBlank()) {
            redirectUrl += "?page=" + page + "&msg=" + msg;
        } else {
            redirectUrl += "?msg=" + msg;
        }
        response.sendRedirect(redirectUrl);
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

    private Date parseSqlDate(String s) {
        try {
            if (s == null || s.isBlank()) {
                return null;
            }
            return Date.valueOf(s); // yyyy-MM-dd
        } catch (Exception e) {
            return null;
        }
    }

    private String buildQs(String keyword, String status, String expectedFrom, String expectedTo)
            throws UnsupportedEncodingException {
        StringBuilder sb = new StringBuilder();
        if (keyword != null && !keyword.isBlank()) {
            sb.append("&keyword=").append(java.net.URLEncoder.encode(keyword, "UTF-8"));
        }
        if (status != null && !status.isBlank()) {
            sb.append("&status=").append(java.net.URLEncoder.encode(status, "UTF-8"));
        }
        if (expectedFrom != null && !expectedFrom.isBlank()) {
            sb.append("&expectedFrom=").append(java.net.URLEncoder.encode(expectedFrom, "UTF-8"));
        }
        if (expectedTo != null && !expectedTo.isBlank()) {
            sb.append("&expectedTo=").append(java.net.URLEncoder.encode(expectedTo, "UTF-8"));
        }
        return sb.toString();
    }

    private String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
