package dao;

import context.DBContext;
import dto.ProductDetailDTO;
import dto.ProductListDTO;
import dto.ProductVariantDetailDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    public List<ProductListDTO> getAllProducts(int limit, int offset) throws Exception {
        return getAllProducts(limit, offset, null, null, null, "product_id", "DESC");
    }
    
    public List<ProductListDTO> getAllProducts(int limit, int offset, String filterSku, 
                                                String filterName, String filterBarcode,
                                                String sortBy, String sortOrder) throws Exception {
        List<ProductListDTO> list = new ArrayList<>();
        
        // Validate sortBy to prevent SQL injection
        String[] allowedSortColumns = {"product_id", "sku", "name", "barcode", "created_at"};
        String validSortBy = "product_id";
        for (String col : allowedSortColumns) {
            if (col.equalsIgnoreCase(sortBy)) {
                validSortBy = col;
                break;
            }
        }
        
        // Validate sortOrder
        String validSortOrder = "DESC";
        if ("ASC".equalsIgnoreCase(sortOrder)) {
            validSortOrder = "ASC";
        }
        
        // Build WHERE clause for filters
        StringBuilder whereClause = new StringBuilder();
        java.util.List<String> conditions = new ArrayList<>();
        
        if (filterSku != null && !filterSku.isBlank()) {
            conditions.add("p.sku LIKE ?");
        }
        if (filterName != null && !filterName.isBlank()) {
            conditions.add("p.name LIKE ?");
        }
        if (filterBarcode != null && !filterBarcode.isBlank()) {
            conditions.add("p.barcode LIKE ?");
        }
        
        if (!conditions.isEmpty()) {
            whereClause.append("WHERE ").append(String.join(" AND ", conditions));
        }
        
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT ");
        sqlBuilder.append("    p.product_id, ");
        sqlBuilder.append("    p.sku, ");
        sqlBuilder.append("    p.name, ");
        sqlBuilder.append("    p.barcode, ");
        sqlBuilder.append("    p.created_at ");
        sqlBuilder.append("FROM product p ");
        sqlBuilder.append(whereClause.toString());
        sqlBuilder.append(" ORDER BY p.").append(validSortBy).append(" ").append(validSortOrder);
        sqlBuilder.append(" LIMIT ? OFFSET ?");
        
        String sql = sqlBuilder.toString();

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            int paramIndex = 1;
            
            // Set filter parameters
            if (filterSku != null && !filterSku.isBlank()) {
                ps.setString(paramIndex++, "%" + filterSku + "%");
            }
            if (filterName != null && !filterName.isBlank()) {
                ps.setString(paramIndex++, "%" + filterName + "%");
            }
            if (filterBarcode != null && !filterBarcode.isBlank()) {
                ps.setString(paramIndex++, "%" + filterBarcode + "%");
            }
            
            // Set limit and offset
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductListDTO dto = new ProductListDTO();
                    dto.setProductId(rs.getLong("product_id"));
                    dto.setSku(rs.getString("sku"));
                    dto.setName(rs.getString("name"));
                    dto.setBarcode(rs.getString("barcode"));
                    
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        dto.setCreatedAt(ts.toLocalDateTime());
                    }
                    
                    list.add(dto);
                }
            }
        }
        
        return list;
    }

    public ProductDetailDTO getProductById(Long productId) throws Exception {
        String sql = """
            SELECT 
                p.product_id,
                p.sku,
                p.name,
                p.category_id,
                c.name AS category_name,
                p.base_uom_id,
                u.name AS uom_name,
                p.barcode,
                p.weight,
                p.length,
                p.width,
                p.height,
                p.created_at
            FROM product p
            LEFT JOIN category c ON c.category_id = p.category_id
            LEFT JOIN uom u ON u.uom_id = p.base_uom_id
            WHERE p.product_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductDetailDTO dto = new ProductDetailDTO();
                    dto.setProductId(rs.getLong("product_id"));
                    dto.setSku(rs.getString("sku"));
                    dto.setName(rs.getString("name"));
                    
                    Long catId = rs.getObject("category_id") != null ? rs.getLong("category_id") : null;
                    dto.setCategoryId(catId);
                    dto.setCategoryName(rs.getString("category_name"));
                    
                    Long uomId = rs.getObject("base_uom_id") != null ? rs.getLong("base_uom_id") : null;
                    dto.setBaseUomId(uomId);
                    dto.setUomName(rs.getString("uom_name"));
                    
                    dto.setBarcode(rs.getString("barcode"));
                    dto.setWeight(rs.getBigDecimal("weight"));
                    dto.setLength(rs.getBigDecimal("length"));
                    dto.setWidth(rs.getBigDecimal("width"));
                    dto.setHeight(rs.getBigDecimal("height"));
                    
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        dto.setCreatedAt(ts.toLocalDateTime());
                    }
                    
                    // Lấy danh sách variants
                    List<ProductVariantDetailDTO> variants = getVariantsByProductId(productId);
                    dto.setVariants(variants);
                    
                    return dto;
                }
            }
        }
        
        return null;
    }

    private List<ProductVariantDetailDTO> getVariantsByProductId(Long productId) throws Exception {
        List<ProductVariantDetailDTO> list = new ArrayList<>();
        
        String sql = """
            SELECT 
                variant_id,
                variant_sku,
                color,
                size,
                barcode,
                status
            FROM product_variant
            WHERE product_id = ?
            ORDER BY variant_id
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductVariantDetailDTO dto = new ProductVariantDetailDTO();
                    dto.setVariantId(rs.getLong("variant_id"));
                    dto.setVariantSku(rs.getString("variant_sku"));
                    dto.setColor(rs.getString("color"));
                    dto.setSize(rs.getString("size"));
                    dto.setBarcode(rs.getString("barcode"));
                    dto.setStatus(rs.getString("status"));
                    
                    list.add(dto);
                }
            }
        }
        
        return list;
    }
}
