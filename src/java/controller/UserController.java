package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.RoleDAO;
import dao.UserDAO;
import dao.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Role;
import model.User;
import model.Warehouse;
import util.PasswordUtil;
import util.ViewPath;

@WebServlet(name = "UserController", urlPatterns = {"/admin/user", "/admin/user/*"})
public class UserController extends HttpServlet {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_SIZE = 20;

    private static final RoleDAO roleDAO = new RoleDAO();
    private static final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private static final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String contextPath = request.getContextPath();

            String pathInfo = request.getPathInfo();
            if (pathInfo == null) pathInfo = "/";

            switch (pathInfo) {
                case "/" -> forwardList(request, response);
                case "/create" -> forwardCreateForm(request, response);
                case "/update" -> forwardUpdateForm(request, response);
                default -> response.sendRedirect(contextPath + "/admin/user");
            }
        } catch (Exception ex) {
            Logger.getLogger(UserController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + ex.getMessage());
            try {
                forwardList(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null) pathInfo = "/";

            String contextPath = request.getContextPath();

            switch (pathInfo) {
                case "/create" -> handleCreate(request, response);
                case "/update" -> handleUpdate(request, response);
                case "/delete" -> handleDelete(request, response);
                default -> response.sendRedirect(contextPath + "/admin/user");
            }
        } catch (Exception e) {
            Logger.getLogger(UserController.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            try {
                forwardList(request, response);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }

    private void forwardList(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        int page = parseInt(request.getParameter("page"), DEFAULT_PAGE);
        int size = DEFAULT_SIZE;
        int offset = (page - 1) * size;

        List<User> users = userDAO.getAll(size, offset);
        long totalCount = userDAO.count();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("hasNext", page < totalPages);
        request.setAttribute("hasPrev", page > 1);

        request.getRequestDispatcher(ViewPath.USER_LIST).forward(request, response);
    }

    private void forwardCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        List<Role> roles = roleDAO.getAll(1000, 0);  // Get all roles
        request.setAttribute("roles", roles);

        List<Warehouse> warehouses = warehouseDAO.getAll();
        request.setAttribute("warehouses", warehouses);

        request.getRequestDispatcher(ViewPath.USER_CREATE).forward(request, response);
    }

    private void forwardUpdateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long userId = parseLong(request.getParameter("id"), -1);
        if (userId <= 0) {
            forwardList(request, response);
            return;
        }

        User user = userDAO.getById(userId);
        if (user == null) {
            request.setAttribute("error", "Không tìm thấy user với ID: " + userId);
            forwardList(request, response);
            return;
        }

        List<Role> allRoles = roleDAO.getAll(1000, 0);
        List<Long> selectedRoleIds = userDAO.getRolesByUserId(userId);
        List<Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("user", user);
        request.setAttribute("roles", allRoles);
        request.setAttribute("selectedRoleIds", selectedRoleIds);
        request.setAttribute("warehouses", warehouses);

        request.getRequestDispatcher(ViewPath.USER_UPDATE).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String status = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        String[] roleIds = request.getParameterValues("roleIds");

        if (username == null || username.isBlank() || fullName == null || fullName.isBlank()
            || email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Username, Full Name, Email và Password là bắt buộc");
            forwardCreateForm(request, response);
            return;
        }


        // Check duplicate username
        if (userDAO.usernameExists(username, null)) {
            request.setAttribute("error", "Username đã tồn tại");
            forwardCreateForm(request, response);
            return;
        }

        // Check duplicate email
        if (userDAO.emailExists(email, null)) {
            request.setAttribute("error", "Email đã tồn tại");
            forwardCreateForm(request, response);
            return;
        }

        // Hash password
        String passwordHash = PasswordUtil.hashPassword(password);

        User user = new User();
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(passwordHash);
        user.setStatus(status != null ? status : "ACTIVE");

        if (warehouseIdStr != null && !warehouseIdStr.isBlank()) {
            try {
                user.setWarehouseId(Long.parseLong(warehouseIdStr));
            } catch (NumberFormatException e) {
                // Invalid warehouse ID, ignore
            }
        }

        // Get created_by from session if available
        Long createdBy = (Long) request.getSession().getAttribute("userId");
        user.setCreatedBy(createdBy);

        if (userDAO.create(user)) {
            // Set roles
            if (roleIds != null && roleIds.length > 0) {
                List<Long> roleIdList = new ArrayList<>();
                for (String rid : roleIds) {
                    try {
                        roleIdList.add(Long.parseLong(rid));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
                userDAO.setUserRoles(user.getUserId(), roleIdList);
            }

            response.sendRedirect(request.getContextPath() + "/admin/user?success=create");
        } else {
            request.setAttribute("error", "Không thể tạo user");
            forwardCreateForm(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long userId = parseLong(request.getParameter("id"), -1);
        if (userId <= 0) {
            forwardList(request, response);
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        String[] roleIds = request.getParameterValues("roleIds");

        if (fullName == null || fullName.isBlank() || email == null || email.isBlank()) {
            request.setAttribute("error", "Full Name và Email là bắt buộc");
            forwardUpdateForm(request, response);
            return;
        }


        User existingUser = userDAO.getById(userId);
        if (existingUser == null) {
            request.setAttribute("error", "Không tìm thấy user");
            forwardList(request, response);
            return;
        }

        // Check duplicate email (exclude current user)
        if (userDAO.emailExists(email, userId)) {
            request.setAttribute("error", "Email đã tồn tại");
            forwardUpdateForm(request, response);
            return;
        }

        User user = new User();
        user.setUserId(userId);
        user.setUsername(existingUser.getUsername());  // Keep username unchanged
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setStatus(status);
        user.setPasswordHash(existingUser.getPasswordHash());  // Keep password unchanged

        if (warehouseIdStr != null && !warehouseIdStr.isBlank()) {
            try {
                user.setWarehouseId(Long.parseLong(warehouseIdStr));
            } catch (NumberFormatException e) {
                // Invalid warehouse ID, set to null
                user.setWarehouseId(null);
            }
        } else {
            user.setWarehouseId(null);
        }

        if (userDAO.update(user)) {
            // Update roles
            List<Long> roleIdList = new ArrayList<>();
            if (roleIds != null && roleIds.length > 0) {
                for (String rid : roleIds) {
                    try {
                        roleIdList.add(Long.parseLong(rid));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
            }
            userDAO.setUserRoles(userId, roleIdList);

            response.sendRedirect(request.getContextPath() + "/admin/user?success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật user");
            forwardUpdateForm(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long userId = parseLong(request.getParameter("id"), -1);
        if (userId <= 0) {
            forwardList(request, response);
            return;
        }

        if (userDAO.delete(userId)) {
            response.sendRedirect(request.getContextPath() + "/admin/user?success=delete");
        } else {
            request.setAttribute("error", "Không thể xóa user");
            forwardList(request, response);
        }
    }

    private int parseInt(String raw, int def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Integer.parseInt(raw);
        } catch (Exception e) {
            return def;
        }
    }

    private long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw);
        } catch (Exception e) {
            return def;
        }
    }
}
