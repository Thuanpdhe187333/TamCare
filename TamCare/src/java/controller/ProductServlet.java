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

        // 2. KIỂM TRA MỞ KHÓA (PREMIUM)
        if (!acc.isIsPremium()) {
            response.sendRedirect("membership.jsp?msg=lock");
            return;
        }

        try {
            ProductDAO dao = new ProductDAO();
            List<Product> list = dao.getAllProducts();
            request.setAttribute("productList", list);
        } catch (Exception e) {
            System.err.println("Lỗi tại ProductServlet: " + e.getMessage());
        }

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}