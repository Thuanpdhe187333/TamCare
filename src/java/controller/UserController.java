package controller;

import dao.RoleDAO;
import dao.UserDAO;
import dao.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import model.User;
import util.PasswordUtil;
import util.ViewPath;

@WebServlet(name = "UserController", urlPatterns = {"/admin/user", "/admin/user/*"})
public class UserController extends HttpServlet {

    private static final Long DEFAULT_PAGE = 1L;
    private static final Long DEFAULT_SIZE = 10L;

    private final UserDAO userDao = new UserDAO();
    private final RoleDAO roleDao = new RoleDAO();
    private final WarehouseDAO warehouseDao = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        var path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            viewList(request, response);
            return;
        }

        switch (path) {
            case "/create" -> viewCreate(request, response);
            case "/update" -> viewUpdate(request, response);
            case "/detail" -> viewDetail(request, response);
            case "/restore" -> restoreUser(request, response);
            default -> viewList(request, response);
        }
    }

    private void viewList(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            var pageRaw = request.getParameter("page");
            var page = pageRaw == null ? DEFAULT_PAGE : Long.valueOf(pageRaw);

            var sizeRaw = request.getParameter("size");
            var size = sizeRaw == null ? DEFAULT_SIZE : Long.valueOf(sizeRaw);

            var sortRaw = request.getParameter("sort");
            var sort = (sortRaw == null || sortRaw.isEmpty()) ? "user_id" : sortRaw;

            var searchRaw = request.getParameter("search");
            var search = searchRaw == null ? "%%" : "%" + searchRaw + "%";

            var roleIdRaw = request.getParameter("roleId");
            var roleId = (roleIdRaw == null || roleIdRaw.isEmpty()) ? null : Long.valueOf(roleIdRaw);

            var statusRaw = request.getParameter("status");
            var status = (statusRaw == null || statusRaw.isEmpty()) ? null : statusRaw;

            var isDeletedRaw = request.getParameter("isDeleted");
            Boolean isDeleted = null;
            if (isDeletedRaw != null && !isDeletedRaw.isEmpty()) {
                isDeleted = "1".equals(isDeletedRaw) || "true".equalsIgnoreCase(isDeletedRaw);
            }

            var total = userDao.getPageCount(search, roleId, status, isDeleted);
            var pages = (total + size - 1) / size;
            var users = userDao.getList(search, sort, page, size, roleId, status, isDeleted);

            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("sort", sortRaw);
            request.setAttribute("search", searchRaw);
            request.setAttribute("roleId", roleId);
            request.setAttribute("status", status);
            request.setAttribute("isDeleted", isDeletedRaw);
            request.setAttribute("pages", pages);
            request.setAttribute("total", total);
            request.setAttribute("users", users);
            request.setAttribute("availableRoles", roleDao.getList("%%", "name", 1L, 100L));

            request.getRequestDispatcher(ViewPath.USER_LIST).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            var user = userDao.getById(id);
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                return;
            }
            request.setAttribute("user", user);
            request.setAttribute("roles", userDao.getRolesDetailByUserId(id));
            request.setAttribute("permissions", userDao.getPermissionsDetailByUserId(id));
            request.getRequestDispatcher(ViewPath.USER_DETAIL).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading detail");
        }
    }

    private void viewCreate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("roles", roleDao.getList("%%", "name", 1L, 1000L));
            request.setAttribute("warehouses", warehouseDao.getAll());
            request.getRequestDispatcher(ViewPath.USER_CREATE).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            viewList(request, response);
        }
    }

    private void viewUpdate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            var user = userDao.getById(id);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/user");
                return;
            }
            request.setAttribute("user", user);
            request.setAttribute("roles", roleDao.getList("%%", "name", 1L, 1000L));
            request.setAttribute("selectedRoleIds", new java.util.HashSet<>(userDao.getRolesByUserId(id)));
            request.setAttribute("warehouses", warehouseDao.getAll());
            request.getRequestDispatcher(ViewPath.USER_UPDATE).forward(request, response);
        } catch (ServletException | IOException | NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/user");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String status = request.getParameter("status");
        String warehouseIdRaw = request.getParameter("warehouseId");
        String[] roleIds = request.getParameterValues("roleIds");

        String passwordHash = PasswordUtil.hashPassword(password);

        User u = new User();
        u.setUsername(username);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setPasswordHash(passwordHash);
        u.setStatus(status != null ? status : "ACTIVE");

        if (warehouseIdRaw != null && !warehouseIdRaw.isBlank()) {
            u.setWarehouseId(Long.valueOf(warehouseIdRaw));
        }

        Long createdBy = (Long) request.getSession().getAttribute("userId");
        u.setCreatedBy(createdBy);

        try {
            if (userDao.create(u)) {
                if (roleIds != null) {
                    java.util.List<Long> rList = java.util.Arrays.stream(roleIds).map(Long::valueOf).toList();
                    userDao.setUserRoles(u.getUserId(), rList);
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/user");
        } catch (SQLException e) {
            e.printStackTrace();
            viewList(request, response);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Map<String, String[]> params = parseFormBodyExtended(request);

            String idRaw = request.getParameter("id");
            if (idRaw == null && params.containsKey("id"))
                idRaw = params.get("id")[0];

            Long id = Long.valueOf(idRaw);
            String fullName = params.get("fullName")[0];
            String email = params.get("email")[0];
            String phone = params.get("phone")[0];
            String status = params.get("status")[0];
            String warehouseIdRaw = params.containsKey("warehouseId") ? params.get("warehouseId")[0] : null;
            String[] roleIds = params.get("roleIds");

            User u = userDao.getById(id);
            if (u != null) {
                u.setFullName(fullName);
                u.setEmail(email);
                u.setPhone(phone);
                u.setStatus(status);
                u.setWarehouseId((warehouseIdRaw == null || warehouseIdRaw.isBlank()) ? null : Long.valueOf(warehouseIdRaw));

                if (userDao.update(u)) {
                    java.util.List<Long> rList = roleIds != null
                    ? java.util.Arrays.stream(roleIds).map(Long::valueOf).toList()
                    : new java.util.ArrayList<>();
                    userDao.setUserRoles(id, rList);
                }
            }

            response.setHeader("HX-Location", request.getContextPath() + "/admin/user");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                Long id = Long.valueOf(idRaw);
                userDao.delete(id);
            }
            response.setHeader("HX-Location", request.getContextPath() + "/admin/user");
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Xóa thất bại");
        }
    }

    private void restoreUser(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                Long id = Long.valueOf(idRaw);
                userDao.restore(id);
            }
            response.setHeader("HX-Redirect", request.getContextPath() + "/admin/user");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Khôi phục thất bại");
        }
    }

    private Map<String, String[]> parseFormBodyExtended(HttpServletRequest request) throws IOException {
        Map<String, java.util.List<String>> params = new HashMap<>();
        byte[] bytes = request.getInputStream().readAllBytes();
        String body = new String(bytes, StandardCharsets.UTF_8);

        if (!body.isEmpty()) {
            String[] pairs = body.split("&");
            for (String pair : pairs) {
                String[] kv = pair.split("=");
                if (kv.length == 2) {
                    String key = URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
                    String value = URLDecoder.decode(kv[1], StandardCharsets.UTF_8);
                    params.computeIfAbsent(key, k -> new java.util.ArrayList<>()).add(value);
                }
            }
        }

        Map<String, String[]> resultMap = new HashMap<>();
        params.forEach((k, v) -> resultMap.put(k, v.toArray(new String[0])));
        return resultMap;
    }
}
