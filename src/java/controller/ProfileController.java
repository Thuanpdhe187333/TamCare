package controller;

import dao.RoleDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import util.ViewPath;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    private final UserDAO userDao = new UserDAO();
    private final RoleDAO roleDao = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect(request.getContextPath() + ViewPath.VIEW_LOGIN);
            return;
        }

        User sessionUser = (User) session.getAttribute("USER");
        Long userId = sessionUser.getUserId();

        try {
            User user = userDao.getById(userId);
            if (user == null) {
                // Determine behavior if user in session but not in DB (deleted?)
                session.invalidate();
                response.sendRedirect(request.getContextPath() + ViewPath.VIEW_LOGIN);
                return;
            }

            // Get roles for the user
            var roles = userDao.getRolesDetailByUserId(userId);
            
            // Create a map of roles to their permissions
            var rolePermissionsMap = new java.util.LinkedHashMap<model.Role, java.util.List<model.Permission>>();
            for (var role : roles) {
                var permissions = roleDao.getPermissionsDetailByRoleId(role.getRoleId());
                rolePermissionsMap.put(role, permissions);
            }

            request.setAttribute("user", user);
            request.setAttribute("rolePermissionsMap", rolePermissionsMap);
            request.getRequestDispatcher(ViewPath.PROFILE_INDEX).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading profile");
        }
    }
}
