package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/*"}) 
public class MembershipFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        User acc = (User) session.getAttribute("account");
        String url = req.getServletPath();

        // Danh sách các trang KHÔNG BỊ KHÓA (để user nạp tiền hoặc đăng nhập)
        if (url.contains("/assets") || url.endsWith("login.jsp") || url.endsWith("register.jsp") 
            || url.endsWith("membership.jsp") || url.equals("/login") || url.equals("/register") 
            || url.equals("/logout") || url.equals("/upgrade-membership")) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu đã đăng nhập mà CHƯA MỞ KHÓA (IsPremium = false)
        if (acc != null && !acc.isIsPremium()) {
            res.sendRedirect("membership.jsp"); // Buộc quay lại trang nạp tiền
            return;
        }

        chain.doFilter(request, response);
    }
}