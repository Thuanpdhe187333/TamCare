package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name="ProductServlet", urlPatterns={"/products"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // 1. Cấu hình tiếng Việt cho Request và Response
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 2. Gọi DAO lấy dữ liệu
            ProductDAO dao = new ProductDAO();
            List<Product> list = dao.getAllProducts();

            // 3. Đưa dữ liệu sang JSP
            request.setAttribute("productList", list);
        } catch (Exception e) {
            // Log lỗi ra console để bác debug
            System.err.println("Lỗi tại ProductServlet: " + e.getMessage());
        }

        // 4. Chuyển hướng sang trang hiển thị
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}