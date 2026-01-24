package controller;

import dao.ProductDAO;
import dto.ProductDetailDTO;
import dto.ProductListDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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
        
        int page = parseInt(request.getParameter("page"), DEFAULT_PAGE);
        int size = DEFAULT_SIZE;
        int offset = (page - 1) * size;

        ProductDAO dao = new ProductDAO();
        List<ProductListDTO> products = dao.getAllProducts(size, offset);

        request.setAttribute("products", products);
        request.setAttribute("page", page);

        request.getRequestDispatcher("WEB-INF/views/product/product-list.jsp").forward(request, response);
    }

    private void handleGetDetail(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        response.setContentType("application/json;charset=UTF-8");
        
        long productId = parseLong(request.getParameter("id"), -1);
        if (productId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"error\":\"Invalid product ID\"}");
            }
            return;
        }

        ProductDAO dao = new ProductDAO();
        ProductDetailDTO product = dao.getProductById(productId);

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
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"variantId\":").append(v.getVariantId()).append(",");
                json.append("\"variantSku\":\"").append(escapeJson(v.getVariantSku())).append("\",");
                json.append("\"color\":\"").append(escapeJson(v.getColor())).append("\",");
                json.append("\"size\":\"").append(escapeJson(v.getSize())).append("\",");
                json.append("\"barcode\":\"").append(escapeJson(v.getBarcode())).append("\",");
                json.append("\"status\":\"").append(escapeJson(v.getStatus())).append("\"");
                json.append("}");
            }
        }
        
        json.append("]}");
        
        try (PrintWriter out = response.getWriter()) {
            out.write(json.toString());
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
