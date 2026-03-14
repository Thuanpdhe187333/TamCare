package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO extends DBContext { 

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        // Câu lệnh SQL chuẩn theo bảng của bác
        String sql = "SELECT [Id], [ProductName], [ImageUrl], [ProductCategory], [ProductDescription], [Price] FROM [Products]";
        
        try (Connection con = getConnection(); 
             PreparedStatement st = con.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("Id"));
                // Lấy dữ liệu String từ SQL Server
                p.setProductName(rs.getString("ProductName"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setProductCategory(rs.getString("ProductCategory"));
                p.setProductDescription(rs.getString("ProductDescription"));
                p.setPrice(rs.getDouble("Price"));
                
                list.add(p);
            }
        } catch (SQLException e) {
            // Sử dụng System.err để dòng lỗi hiện màu đỏ trong console cho dễ nhìn
            System.err.println("Lỗi ProductDAO tại getAllProducts: " + e.getMessage());
        }
        return list;
    }
    
    public List<Product> searchByName(String txtSearch) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE ProductName LIKE ?";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, "%" + txtSearch + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                    rs.getInt("Id"),
                    rs.getString("ProductName"),
                    rs.getString("ImageUrl"),
                    rs.getString("ProductCategory"),
                    rs.getString("ProductDescription"),
                    rs.getDouble("Price")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi Search: " + e.getMessage());
        }
        return list;
    }
    public Product getProductByID(int id) {
    String sql = "SELECT [Id], [ProductName], [ImageUrl], [ProductCategory], [ProductDescription], [Price] "
               + "FROM [Products] WHERE [Id] = ?";
    try (Connection con = getConnection(); 
         PreparedStatement st = con.prepareStatement(sql)) {
        st.setInt(1, id);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Product(
                rs.getInt("Id"),
                rs.getString("ProductName"),
                rs.getString("ImageUrl"),
                rs.getString("ProductCategory"),
                rs.getString("ProductDescription"),
                rs.getDouble("Price")
            );
        }
    } catch (SQLException e) {
        System.err.println("Lỗi getProductByID: " + e.getMessage());
    }
    return null;
}
}