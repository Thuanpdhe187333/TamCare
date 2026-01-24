package controller;

import dao.PermissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Permission;
import util.ViewPath;

@WebServlet(name = "PermissionController", urlPatterns = {"/admin/permission", "/admin/permission/*"})
public class PermissionController extends HttpServlet {

    // private static final int DEFAULT_PAGE = 1;
    // private static final int DEFAULT_SIZE = 20;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                // /admin/permission - list
                forwardList(request, response);
            } else if (pathInfo.equals("/create")) {
                // /admin/permission/create - create form
                forwardCreateForm(request, response);
            } else if (pathInfo.equals("/update")) {
                // /admin/permission/update?id=xxx - update form
                forwardUpdateForm(request, response);
            } else {
                // Unknown path, redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/permission");
            }
        } catch (Exception ex) {
            Logger.getLogger(PermissionController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + ex.getMessage());
            try {
                forwardList(request, response);
            } catch (Exception e) {
                throw new ServletException(e);
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
                response.sendRedirect(request.getContextPath() + "/admin/permission");
            } else if (pathInfo.equals("/create")) {
                // /admin/permission/create - create action
                handleCreate(request, response);
            } else if (pathInfo.equals("/update")) {
                // /admin/permission/update - update action
                handleUpdate(request, response);
            } else if (pathInfo.equals("/delete")) {
                // /admin/permission/delete - delete action
                handleDelete(request, response);
            } else {
                // Unknown path, redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/permission");
            }
        } catch (Exception e) {
            Logger.getLogger(PermissionController.class.getName()).log(Level.SEVERE, null, e);
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
        PermissionDAO dao = new PermissionDAO();
        List<Permission> permissions = dao.getAll();
        long totalCount = dao.count();

        request.setAttribute("permissions", permissions);
        request.setAttribute("totalCount", totalCount);

        request.getRequestDispatcher(ViewPath.PERMISSION_LIST).forward(request, response);
    }

    private void forwardCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        request.getRequestDispatcher(ViewPath.PERMISSION_CREATE).forward(request, response);
    }

    private void forwardUpdateForm(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long permissionId = parseLong(request.getParameter("id"), -1);
        if (permissionId <= 0) {
            forwardList(request, response);
            return;
        }

        PermissionDAO dao = new PermissionDAO();
        Permission permission = dao.getById(permissionId);
        if (permission == null) {
            request.setAttribute("error", "Không tìm thấy permission với ID: " + permissionId);
            forwardList(request, response);
            return;
        }

        request.setAttribute("permission", permission);
        request.getRequestDispatcher(ViewPath.PERMISSION_UPDATE).forward(request, response);
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        String code = request.getParameter("code");
        String name = request.getParameter("name");

        if (code == null || code.isBlank() || name == null || name.isBlank()) {
            request.setAttribute("error", "Code và Name là bắt buộc");
            forwardCreateForm(request, response);
            return;
        }

        PermissionDAO dao = new PermissionDAO();

        // Check duplicate code
        if (dao.codeExists(code, null)) {
            request.setAttribute("error", "Code đã tồn tại");
            forwardCreateForm(request, response);
            return;
        }

        Permission permission = new Permission();
        permission.setCode(code);
        permission.setName(name);

        if (dao.create(permission)) {
            response.sendRedirect(request.getContextPath() + "/admin/permission?success=create");
        } else {
            request.setAttribute("error", "Không thể tạo permission");
            forwardCreateForm(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long permissionId = parseLong(request.getParameter("id"), -1);
        if (permissionId <= 0) {
            forwardList(request, response);
            return;
        }

        String code = request.getParameter("code");
        String name = request.getParameter("name");

        if (code == null || code.isBlank() || name == null || name.isBlank()) {
            request.setAttribute("error", "Code và Name là bắt buộc");
            forwardUpdateForm(request, response);
            return;
        }

        PermissionDAO dao = new PermissionDAO();

        // Check duplicate code (exclude current permission)
        if (dao.codeExists(code, permissionId)) {
            request.setAttribute("error", "Code đã tồn tại");
            forwardUpdateForm(request, response);
            return;
        }

        Permission permission = new Permission();
        permission.setPermissionId(permissionId);
        permission.setCode(code);
        permission.setName(name);

        if (dao.update(permission)) {
            response.sendRedirect(request.getContextPath() + "/admin/permission?success=update");
        } else {
            request.setAttribute("error", "Không thể cập nhật permission");
            forwardUpdateForm(request, response);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        long permissionId = parseLong(request.getParameter("id"), -1);
        if (permissionId <= 0) {
            forwardList(request, response);
            return;
        }

        PermissionDAO dao = new PermissionDAO();
        if (dao.delete(permissionId)) {
            response.sendRedirect(request.getContextPath() + "/admin/permission?success=delete");
        } else {
            request.setAttribute("error", "Không thể xóa permission");
            forwardList(request, response);
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
