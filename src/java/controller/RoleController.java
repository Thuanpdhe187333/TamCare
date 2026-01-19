package controller;

import dao.PermissionDAO;
import dao.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Permission;
import model.Role;
import util.ViewPath;

@WebServlet(name = "RoleController", urlPatterns = {"/admin/role", "/admin/role/*"})
public class RoleController extends HttpServlet {

    private static final int DEFAULT_PAGE = 1;
    private static final int DEFAULT_SIZE = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // /admin/role - list
                forwardList(request, response);
            } else if (pathInfo.equals("/create")) {
                // /admin/role/create - create form
                forwardCreateForm(request, response);
            } else if (pathInfo.equals("/update")) {
                // /admin/role/update?id=xxx - update form
                forwardUpdateForm(request, response);
            } else {
                // Unknown path, redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/role");
            }
        } catch (Exception ex) {
            Logger.getLogger(RoleController.class.getName()).log(Level.SEVERE, null, ex);
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
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // Should not happen for POST, redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/role");
            } else if (pathInfo.equals("/create")) {
                // /admin/role/create - create action
                handleCreate(request, response);
            } else if (pathInfo.equals("/update")) {
                // /admin/role/update - update action
                handleUpdate(request, response);
            } else if (pathInfo.equals("/delete")) {
                // /admin/role/delete - delete action
                handleDelete(request, response);
            } else {
                // Unknown path, redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/role");
            }
        } catch (Exception e) {
            Logger.getLogger(RoleController.class.getName()).log(Level.SEVERE, null, e);
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

        RoleDAO dao = new RoleDAO();
        List<Role> roles = dao.getAll(size, offset);
        long totalCount = dao.count();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        request.setAttribute("roles", roles);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("hasNext", page < totalPages);
        request.setAttribute("hasPrev", page > 1);

        request.getRequestDispatcher(ViewPath.ROLE_LIST).forward(request, response);
    }

    private void forwardCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        PermissionDAO permissionDAO = new PermissionDAO();
        List<Permission> permissions = permissionDAO.getAll();

        request.setAttribute("permissions", permissions);
        request.getRequestDispatcher(ViewPath.ROLE_CREATE).forward(request, response);
    }

    private void forwardUpdateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long roleId = parseLong(request.getParameter("id"), -1);
        if (roleId <= 0) {
            forwardList(request, response);
            return;
        }

        RoleDAO roleDAO = new RoleDAO();
        PermissionDAO permissionDAO = new PermissionDAO();

        Role role = roleDAO.getById(roleId);
        if (role == null) {
            request.setAttribute("error", "Không tìm thấy role với ID: " + roleId);
            forwardList(request, response);
            return;
        }

        List<Permission> allPermissions = permissionDAO.getAll();
        List<Long> selectedPermissionIds = roleDAO.getPermissionsByRoleId(roleId);

        request.setAttribute("role", role);
        request.setAttribute("permissions", allPermissions);
        request.setAttribute("selectedPermissionIds", selectedPermissionIds);

        request.getRequestDispatcher(ViewPath.ROLE_UPDATE).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] permissionIds = request.getParameterValues("permissionIds");

        if (name == null || name.isBlank()) {
            request.setAttribute("error", "Tên role là bắt buộc");
            forwardCreateForm(request, response);
            return;
        }

        RoleDAO roleDAO = new RoleDAO();

        // Check duplicate name
        if (roleDAO.nameExists(name, null)) {
            request.setAttribute("error", "Tên role đã tồn tại");
            forwardCreateForm(request, response);
            return;
        }

        Role role = new Role();
        role.setName(name);
        role.setDescription(description);

        if (roleDAO.create(role)) {
            // Set permissions
            if (permissionIds != null && permissionIds.length > 0) {
                List<Long> permissionIdList = new ArrayList<>();
                for (String pid : permissionIds) {
                    try {
                        permissionIdList.add(Long.parseLong(pid));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
                roleDAO.setRolePermissions(role.getRoleId(), permissionIdList);
            }

            response.sendRedirect(request.getContextPath() + "/admin/role?success=create");
        } else {
            request.setAttribute("error", "Không thể tạo role");
            forwardCreateForm(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long roleId = parseLong(request.getParameter("id"), -1);
        if (roleId <= 0) {
            forwardList(request, response);
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String[] permissionIds = request.getParameterValues("permissionIds");

        if (name == null || name.isBlank()) {
            request.setAttribute("error", "Tên role là bắt buộc");
            forwardUpdateForm(request, response);
            return;
        }

        RoleDAO roleDAO = new RoleDAO();

        // Check duplicate name (exclude current role)
        if (roleDAO.nameExists(name, roleId)) {
            request.setAttribute("error", "Tên role đã tồn tại");
            forwardUpdateForm(request, response);
            return;
        }

        Role role = new Role();
        role.setRoleId(roleId);
        role.setName(name);
        role.setDescription(description);

        if (roleDAO.update(role)) {
            // Update permissions
            List<Long> permissionIdList = new ArrayList<>();
            if (permissionIds != null && permissionIds.length > 0) {
                for (String pid : permissionIds) {
                    try {
                        permissionIdList.add(Long.parseLong(pid));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
            }
            roleDAO.setRolePermissions(roleId, permissionIdList);

            response.sendRedirect(request.getContextPath() + "/admin/role?success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật role");
            forwardUpdateForm(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long roleId = parseLong(request.getParameter("id"), -1);
        if (roleId <= 0) {
            forwardList(request, response);
            return;
        }

        RoleDAO roleDAO = new RoleDAO();
        if (roleDAO.delete(roleId)) {
            response.sendRedirect(request.getContextPath() + "/admin/role?success=delete");
        } else {
            request.setAttribute("error", "Không thể xóa role");
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
