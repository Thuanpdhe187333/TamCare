package controller;

import dal.UserDAO;
import java.io.IOException;
// TOMCAT 10 BẮT BUỘC DÙNG JAKARTA
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

// URL Mapping: Phải có dấu "/"
@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Chuyển hướng về trang JSP nếu người dùng gõ URL trực tiếp
        request.getRequestDispatcher("register.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Xử lý tiếng Việt
        request.setCharacterEncoding("UTF-8");
        
        // 1. Lấy dữ liệu từ form register.jsp
        String fullName = request.getParameter("fullname");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        UserDAO udb = new UserDAO();

        // 2. Kiểm tra Email trùng
        if (udb.checkEmailExist(email)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } else {
            // 3. Tạo User và Insert vào DB
            User u = new User(email, pass, fullName, phone, role);
            udb.register(u);
            
            // 4. Thành công -> Chuyển sang login
            response.sendRedirect("login.jsp");
        }
    }
}