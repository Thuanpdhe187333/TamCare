package controller;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

// QUAN TRỌNG: urlPatterns phải khớp chính xác với link trong thẻ <a> của JSP
@WebServlet(name="ProductDetailServlet", urlPatterns={"/product_detail"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String id_raw = request.getParameter("id");
        ProductDAO dao = new ProductDAO();
        
        try {
            int id = Integer.parseInt(id_raw);
            Product p = dao.getProductByID(id); // Gọi hàm lấy 1 SP từ DAO
            
            if (p != null) {
                request.setAttribute("detail", p);
                request.getRequestDispatcher("product_detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("products"); // Không thấy SP thì về trang chủ shop
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("products");
        }
    }
}