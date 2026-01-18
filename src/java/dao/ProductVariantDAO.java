package dao;

import context.DBContext;
import dto.ProductVariantDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAO extends DBContext {

    public List<ProductVariantDTO> getActiveVariants() throws Exception {
        List<ProductVariantDTO> list = new ArrayList<>();

        String sql = """
            SELECT 
                pv.variant_id,
                pv.variant_sku,
                p.sku AS product_sku,
                p.name AS product_name
            FROM product_variant pv
            JOIN product p ON p.product_id = pv.product_id
            WHERE pv.status = 'ACTIVE'
            ORDER BY pv.variant_id
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductVariantDTO v = new ProductVariantDTO();
                v.setVariantId(rs.getLong("variant_id"));
                v.setVariantSku(rs.getString("variant_sku"));
                v.setProductSku(rs.getString("product_sku"));
                v.setProductName(rs.getString("product_name"));
                list.add(v);
            }
        }

        return list;
    }
}
