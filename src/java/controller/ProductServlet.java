package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Product;

@WebServlet(name="ProductServlet", urlPatterns={"/products"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User acc = (session != null) ? (User) session.getAttribute("account") : null;

        // 1. Kiểm tra đăng nhập
        if (acc == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Kiểm tra quyền Premium
        if (!acc.isIsPremium()) {
            response.sendRedirect("membership.jsp?msg=lock");
            return;
        }

        String idParam = request.getParameter("id");
        ProductDAO dao = new ProductDAO();

        try {
            if (idParam == null || idParam.isEmpty()) {
                // TRƯỜNG HỢP 1: HIỂN THỊ CỬA HÀNG
                List<Product> list = dao.getAllProducts();
                request.setAttribute("productList", list);
                // Đẩy sang file shop.jsp
                request.getRequestDispatcher("products.jsp").forward(request, response);
            } else {
                // TRƯỜNG HỢP 2: HIỂN THỊ CHI TIẾT SẢN PHẨM
                int id = Integer.parseInt(idParam);
                Product p = dao.getProductByID(id); // Bác đảm bảo hàm này trong DAO chạy đúng nhé
                if (p != null) {
                    request.setAttribute("p", p);
                    request.getRequestDispatcher("product_detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("products");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("products");
        }
    }
}