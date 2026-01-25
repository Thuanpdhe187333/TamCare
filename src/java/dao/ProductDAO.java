/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import dto.ProductDTO;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author HungTran
 */
public class ProductDAO extends DBContext {

    public List<ProductDTO> getProducts() throws Exception {

        String sql = """
            SELECT product_id, sku, name
            FROM product
            ORDER BY name
        """;
        List<ProductDTO> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductDTO p = new ProductDTO();
                p.setProductId(rs.getLong("product_id"));
                p.setSku(rs.getString("sku"));
                p.setName(rs.getString("name"));
                list.add(p);
            }
        }
        return list;
    }
}
