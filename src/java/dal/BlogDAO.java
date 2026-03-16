package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

public class BlogDAO extends DBContext {

    // Lấy danh sách Blog đang hoạt động (Status = 1)
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blogs WHERE Status = 1 ORDER BY CreatedAt DESC";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog b = new Blog();
                b.setBlogID(rs.getInt("BlogID"));
                b.setTitle(rs.getString("Title"));
                b.setSummary(rs.getString("Summary"));
                b.setContent(rs.getString("Content"));
                b.setImage(rs.getString("Image"));
                b.setCategory(rs.getString("Category"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy 1 bài blog chi tiết theo ID
    public Blog getBlogByID(int id) {
        String sql = "SELECT * FROM Blogs WHERE BlogID = ?";
        try (Connection con = getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Blog b = new Blog();
                b.setBlogID(rs.getInt("BlogID"));
                b.setTitle(rs.getString("Title"));
                b.setSummary(rs.getString("Summary"));
                b.setContent(rs.getString("Content"));
                b.setImage(rs.getString("Image"));
                b.setCategory(rs.getString("Category"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
}