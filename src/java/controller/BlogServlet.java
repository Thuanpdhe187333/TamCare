package controller;

import dal.BlogDAO;
import model.Blog;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "BlogServlet", urlPatterns = {"/blog"})
public class BlogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Thiết lập mã hóa tiếng Việt cho request
        request.setCharacterEncoding("UTF-8");
        
        String idParam = request.getParameter("id");
        BlogDAO dao = new BlogDAO();

        try {
            if (idParam == null || idParam.trim().isEmpty()) {
                // TRƯỜNG HỢP 1: XEM DANH SÁCH BLOG
                List<Blog> list = dao.getAllBlogs();
                
                // Gán đúng tên biến "blogList" để JSP nhận diện được
                request.setAttribute("blogList", list);
                
                // Đẩy sang trang danh sách
                request.getRequestDispatcher("blog.jsp").forward(request, response);
                
            } else {
                // TRƯỜNG HỢP 2: XEM CHI TIẾT 1 BÀI BLOG
                int id = Integer.parseInt(idParam);
                Blog b = dao.getBlogByID(id);
                
                if (b != null) {
                    // Gán vào biến blogDetail
                    request.setAttribute("blogDetail", b);
                    // Đẩy sang trang chi tiết (bác nhớ tạo file blog_detail.jsp nhé)
                    request.getRequestDispatcher("blog_detail.jsp").forward(request, response);
                } else {
                    // Nếu không tìm thấy bài viết, quay về danh sách
                    response.sendRedirect("blog");
                }
            }
        } catch (NumberFormatException e) {
            // Nếu tham số ID bậy bạ, quay về danh sách
            response.sendRedirect("blog");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("blog");
        }
    }
}