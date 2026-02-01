package controller;

import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.ZoneDAO;
import dto.ProductDetailDTO;
import dto.ProductInventoryListDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("detail".equals(action)) {
                handleGetDetail(request, response);
            } else {
                handleList(request, response);
            }
        } catch (Exception ex) {
            Logger.getLogger(ProductController.class.getName()).log(Level.SEVERE, null, ex);
            throw new ServletException(ex);
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        // Get warehouse ID from session or use first warehouse
        Long warehouseId = getWarehouseId(request);
        if (warehouseId == null) {
            request.setAttribute("error", "No warehouse found. Please contact administrator.");
            request.getRequestDispatcher("WEB-INF/views/product/product-list.jsp").forward(request, response);
            return;
        }
        
        int page = parseInt(request.getParameter("page"), DEFAULT_PAGE);
        int size = DEFAULT_SIZE;
        int offset = (page - 1) * size;
        
        // Get filter parameters
        String filterSku = request.getParameter("filterSku");
        String filterName = request.getParameter("filterName");
        String filterBarcode = request.getParameter("filterBarcode");
        String filterZoneCode = request.getParameter("filterZoneCode");
        String filterCondition = request.getParameter("filterCondition");
        
        // Get sort parameters
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        if (sortBy == null || sortBy.isBlank()) {
            sortBy = "product_id";
        }
        if (sortOrder == null || sortOrder.isBlank() || (!sortOrder.equalsIgnoreCase("ASC") && !sortOrder.equalsIgnoreCase("DESC"))) {
            sortOrder = "DESC";
        }

        ProductDAO dao = new ProductDAO();
        
        // Load zones for filter dropdown
        ZoneDAO zoneDAO = new ZoneDAO();
        List<model.Zone> zones = zoneDAO.getZonesByWarehouseId(warehouseId);
        request.setAttribute("zones", zones);
        
        // Count total records for pagination
        int totalRecords = dao.countProductsInInventory(warehouseId, filterSku, filterName, filterBarcode, filterZoneCode, filterCondition);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
        
        // Calculate pagination window
        int window = 5;
        int startPage = Math.max(1, page - window);
        int endPage = Math.min(totalPages, page + window);
        if (endPage - startPage < window * 2) {
            if (startPage == 1) {
                endPage = Math.min(totalPages, startPage + window * 2);
            } else if (endPage == totalPages) {
                startPage = Math.max(1, endPage - window * 2);
            }
        }
        
        // Get products that exist in warehouse inventory with detailed inventory information
        List<ProductInventoryListDTO> products = dao.getProductsInInventory(warehouseId, size, offset, filterSku, filterName, filterBarcode, filterZoneCode, filterCondition, sortBy, sortOrder);

        // Build query string for pagination
        StringBuilder qs = new StringBuilder();
        if (filterSku != null && !filterSku.isBlank()) {
            qs.append("&filterSku=").append(java.net.URLEncoder.encode(filterSku, "UTF-8"));
        }
        if (filterName != null && !filterName.isBlank()) {
            qs.append("&filterName=").append(java.net.URLEncoder.encode(filterName, "UTF-8"));
        }
        if (filterBarcode != null && !filterBarcode.isBlank()) {
            qs.append("&filterBarcode=").append(java.net.URLEncoder.encode(filterBarcode, "UTF-8"));
        }
        if (filterZoneCode != null && !filterZoneCode.isBlank()) {
            qs.append("&filterZoneCode=").append(java.net.URLEncoder.encode(filterZoneCode, "UTF-8"));
        }
        if (filterCondition != null && !filterCondition.isBlank()) {
            qs.append("&filterCondition=").append(java.net.URLEncoder.encode(filterCondition, "UTF-8"));
        }
        if (sortBy != null && !sortBy.isBlank()) {
            qs.append("&sortBy=").append(sortBy);
        }
        if (sortOrder != null && !sortOrder.isBlank()) {
            qs.append("&sortOrder=").append(sortOrder);
        }
        
        String baseUrl = request.getContextPath() + "/products";

        request.setAttribute("products", products);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("baseUrl", baseUrl);
        request.setAttribute("qs", qs.toString());

        request.getRequestDispatcher("WEB-INF/views/product/product-list.jsp").forward(request, response);
    }
    
    /**
     * Get warehouse ID from session user or first active warehouse
     */
    private Long getWarehouseId(HttpServletRequest request) throws SQLException {
        // Try to get from session user
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object userObj = session.getAttribute("USER");
            if (userObj instanceof User) {
                User user = (User) userObj;
                if (user.getWarehouseId() != null) {
                    return user.getWarehouseId();
                }
            }
        }
        
        // Fallback: get first active warehouse
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        List<model.Warehouse> warehouses = warehouseDAO.getAll();
        if (warehouses != null && !warehouses.isEmpty()) {
            return warehouses.get(0).getWarehouseId();
        }
        
        return null;
    }

    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try {
            long productId = parseLong(request.getParameter("id"), -1);
            if (productId <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                try (PrintWriter out = response.getWriter()) {
                    out.write("{\"error\":\"Invalid product ID\"}");
                }
                return;
            }

            ProductDAO dao = new ProductDAO();
            ProductDetailDTO product = null;
            
            // Try to get product with warehouseId for quantity info
            Long warehouseId = null;
            try {
                warehouseId = getWarehouseId(request);
            } catch (Exception e) {
                // If can't get warehouse, continue without warehouseId
                Logger.getLogger(ProductController.class.getName()).log(Level.WARNING, "Could not get warehouse ID: " + e.getMessage());
            }
            
            if (warehouseId != null) {
                try {
                    product = dao.getProductById(productId, warehouseId);
                } catch (Exception e) {
                    Logger.getLogger(ProductController.class.getName()).log(Level.WARNING, "Error getting product with warehouse: " + e.getMessage(), e);
                }
            }
            
            // Fallback: get product without warehouseId if not found
            if (product == null) {
                try {
                    product = dao.getProductById(productId);
                } catch (Exception e) {
                    Logger.getLogger(ProductController.class.getName()).log(Level.SEVERE, "Error getting product: " + e.getMessage(), e);
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    try (PrintWriter out = response.getWriter()) {
                        out.write("{\"error\":\"Error loading product details\"}");
                    }
                    return;
                }
            }

            if (product == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                try (PrintWriter out = response.getWriter()) {
                    out.write("{\"error\":\"Product not found\"}");
                }
                return;
            }

            // Tạo JSON thủ công
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"productId\":").append(product.getProductId()).append(",");
            json.append("\"sku\":\"").append(escapeJson(product.getSku())).append("\",");
            json.append("\"name\":\"").append(escapeJson(product.getName())).append("\",");
            json.append("\"categoryId\":").append(product.getCategoryId() != null ? product.getCategoryId() : "null").append(",");
            json.append("\"categoryName\":\"").append(escapeJson(product.getCategoryName())).append("\",");
            json.append("\"baseUomId\":").append(product.getBaseUomId() != null ? product.getBaseUomId() : "null").append(",");
            json.append("\"uomName\":\"").append(escapeJson(product.getUomName())).append("\",");
            json.append("\"barcode\":\"").append(escapeJson(product.getBarcode())).append("\",");
            json.append("\"weight\":").append(product.getWeight() != null ? product.getWeight().toString() : "null").append(",");
            json.append("\"length\":").append(product.getLength() != null ? product.getLength().toString() : "null").append(",");
            json.append("\"width\":").append(product.getWidth() != null ? product.getWidth().toString() : "null").append(",");
            json.append("\"height\":").append(product.getHeight() != null ? product.getHeight().toString() : "null").append(",");
            json.append("\"createdAt\":\"").append(product.getCreatedAt() != null ? product.getCreatedAt().toString() : "").append("\",");
            json.append("\"variants\":[");
            
            List<dto.ProductVariantDetailDTO> variants = product.getVariants();
            if (variants != null) {
                for (int i = 0; i < variants.size(); i++) {
                    dto.ProductVariantDetailDTO v = variants.get(i);
                    if (v == null) continue; // Skip null variants
                    if (i > 0) json.append(",");
                    json.append("{");
                    json.append("\"variantId\":").append(v.getVariantId()).append(",");
                    json.append("\"variantSku\":\"").append(escapeJson(v.getVariantSku())).append("\",");
                    json.append("\"color\":\"").append(escapeJson(v.getColor())).append("\",");
                    json.append("\"size\":\"").append(escapeJson(v.getSize())).append("\",");
                    json.append("\"barcode\":\"").append(escapeJson(v.getBarcode())).append("\",");
                    json.append("\"status\":\"").append(escapeJson(v.getStatus())).append("\",");
                    // Quantity fields - set to 0 if null (when warehouseId is null)
                    try {
                        BigDecimal qtyOnHand = v.getTotalQtyOnHand();
                        BigDecimal qtyAvailable = v.getTotalQtyAvailable();
                        json.append("\"totalQtyOnHand\":").append(qtyOnHand != null ? qtyOnHand.toString() : "0").append(",");
                        json.append("\"totalQtyAvailable\":").append(qtyAvailable != null ? qtyAvailable.toString() : "0");
                    } catch (Exception e) {
                        // If error getting quantity, set to 0
                        json.append("\"totalQtyOnHand\":0,");
                        json.append("\"totalQtyAvailable\":0");
                    }
                    json.append("}");
                }
            }
            
            json.append("]}");
            
            try (PrintWriter out = response.getWriter()) {
                out.write(json.toString());
            }
        } catch (Exception e) {
            Logger.getLogger(ProductController.class.getName()).log(Level.SEVERE, "Error in handleGetDetail: " + e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\":\"Error loading product details: " + escapeJson(e.getMessage()) + "\"}");
            }
        }
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

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
  
    @Override
    public String getServletInfo() {
        return "Product Controller";
    }
}
