// package controller;

// import jakarta.servlet.*;
// import jakarta.servlet.annotation.WebFilter;
// import jakarta.servlet.http.*;
// import java.io.IOException;


// @WebFilter("/*")
// public class AuthFilter implements Filter {
//     private static final String SESSION_USER_KEY = "USER";

//     @Override
//     public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//             throws IOException, ServletException {

//         HttpServletRequest req = (HttpServletRequest) request;
//         HttpServletResponse res = (HttpServletResponse) response;

//         String uri = req.getRequestURI();
//         String ctx = req.getContextPath();

//         boolean isAuth = uri.startsWith(ctx + "/authen");
//         boolean isStatic =
//                 uri.startsWith(ctx + "/assets/") ||
//                 uri.endsWith(".css") || uri.endsWith(".js") ||
//                 uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".jpeg") ||
//                 uri.endsWith(".svg") || uri.endsWith(".woff") || uri.endsWith(".woff2");

//         if (isAuth || isStatic) {
//             chain.doFilter(request, response);
//             return;
//         }

//         HttpSession session = req.getSession(false);
//         Object user = (session == null) ? null : session.getAttribute(SESSION_USER_KEY);

//         if (user == null) {
//             res.sendRedirect(ctx + "/authen");
//             return;
//         }

//         chain.doFilter(request, response);
//     }
// }

