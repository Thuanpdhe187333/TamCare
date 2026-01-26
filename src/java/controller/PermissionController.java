package controller;

import dao.PermissionDAO;
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
import util.ViewPath;

@WebServlet(name = "PermissionController", urlPatterns = {"/admin/permission", "/admin/permission/*"})
public class PermissionController extends HttpServlet {

    private static final Long DEFAULT_PAGE = (long) 1;
    private static final Long DEFAULT_SIZE = (long) 10;

    private final PermissionDAO permissionDao = new PermissionDAO();
    private final dao.RoleDAO roleDao = new dao.RoleDAO();

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
            var sort = (sortRaw == null || sortRaw.isEmpty()) ? "permission_id" : sortRaw;

            var searchRaw = request.getParameter("search");
            var search = searchRaw == null ? "%%" : "%" + searchRaw + "%";

            var total = permissionDao.getPageCount(search);
            var pages = (total + size - 1) / size;
            var permissions = permissionDao.getList(search, sort, page, size);

            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("sort", sortRaw);
            request.setAttribute("search", searchRaw);
            request.setAttribute("pages", pages);
            request.setAttribute("total", total);
            request.setAttribute("permissions", permissions);

            request.getRequestDispatcher(ViewPath.PERMISSION_LIST).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void viewCreate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("roles", roleDao.getAll());
            request.getRequestDispatcher(ViewPath.PERMISSION_CREATE).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading roles");
        }
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            var permission = permissionDao.getDetail(id);
            if (permission == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Permission not found");
                return;
            }
            request.setAttribute("permission", permission);
            request.setAttribute("roles", permissionDao.getRolesByPermissionId(id));
            request.getRequestDispatcher(ViewPath.PERMISSION_DETAIL).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading detail");
        }
    }
    private void viewUpdate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            var permission = permissionDao.getDetail(id);
            if (permission == null) {
                response.sendRedirect(request.getContextPath() + "/admin/permission");
                return;
            }
            request.setAttribute("permission", permission);
            request.setAttribute("roles", roleDao.getAll());
            request.setAttribute("currentRoleIds", permissionDao.getRolesByPermissionId(id).stream().map(model.Role::getRoleId).toList());
            request.getRequestDispatcher(ViewPath.PERMISSION_UPDATE).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/permission");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String code = request.getParameter("code");
        String name = request.getParameter("name");

        model.Permission p = new model.Permission();
        p.setCode(code);
        p.setName(name);

        try {
            permissionDao.create(p);
            
            String[] roleIdsRaw = request.getParameterValues("roleIds");
            if (roleIdsRaw != null) {
                java.util.List<Long> roleIds = new java.util.ArrayList<>();
                for (String id : roleIdsRaw) {
                    roleIds.add(Long.valueOf(id));
                }
                permissionDao.setPermissionRoles(p.getPermissionId(), roleIds);
            }

            response.sendRedirect(request.getContextPath() + "/admin/permission");
        } catch (SQLException e) {
            e.printStackTrace();
            viewList(request, response);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Map<String, String> params = parseFormBody(request);
            
            String idRaw = params.get("id");
            if (idRaw == null) idRaw = request.getParameter("id"); // Try query param

            Long id = Long.valueOf(idRaw);
            String code = params.get("code");
            String name = params.get("name");

            model.Permission p = new model.Permission();
            p.setPermissionId(id);
            p.setCode(code);
            p.setName(name);

            permissionDao.update(p);

            String roleIdsStr = params.get("roleIds");
            if (roleIdsStr != null && !roleIdsStr.isEmpty()) {
                // Since this is parsed from body manually in parseFormBody, and multiple values with same key might be lost or handled differently.
                // Wait, parseFormBody uses a Map<String, String>, which overwrites keys. It doesn't support multiple values for same key (like checkboxes).
                // I need to fix parseFormBody or handle it differently.
                // Actually, standard HTML form submission puts multiple 'roleIds' params.
                // My parseFormBody splits by '&', loops. It puts into map. It will overwrite.
                // I should fix parseFormBody or just use request.getParameterValues if it's not a PUT/DELETE where container doesn't parse body?
                // Tomcat *does* parse body for POST. For PUT, standard Servlet API might not populate getParameterXXX.
                // The custom parseFormBody is used for PUT. I need to update it to support lists or comma separated.
                
                // Let's assume for now I will fix parseFormBody to return Map<String, List<String>> or just handle checking for duplicates?
                // Or I can send it as a comma separated string from frontend? standard form submit sends multiple entries.
                // Let's modify parseFormBody to combine values with comma?
            }
            
            // Re-implementation of the PUT logic block below to correct handling
            
            // We need to re-read the roles from the raw body correctly or change parseFormBody.
            // Let's change parseFormBody to return Map<String, List<String>>? Or just List.
            // But Map<String, String> is the signature.
            // Let's Quick fix: append values with comma in parseFormBody?
            
            // Actually, I can just re-parse the body inside doPut or change parseFormBody signature. 
            // Changing signature affects doDelete too.
            // For now, I will assume I can fix parseFormBody in this same tool call to handle multiple values (e.g. join with comma).
            
            permissionDao.setPermissionRoles(id, getRoleIdsFromParams(params, "roleIds"));
            response.setHeader("HX-Location", request.getContextPath() + "/admin/permission");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
        }
    }



    private java.util.List<Long> getRoleIdsFromParams(Map<String, String> params, String key) {
        java.util.List<Long> list = new java.util.ArrayList<>();
        if (params.containsKey(key)) {
             // In parseFormBody, if I change it to append with comma, then split here
             String val = params.get(key);
             for(String s : val.split(",")) {
                 if(!s.isBlank()) list.add(Long.valueOf(s.trim()));
             }
        }
        return list;
    }

    // Updating parseFormBody to handle multiple values by comma separation
    private Map<String, String> parseFormBody(HttpServletRequest request) throws IOException {
        Map<String, String> params = new HashMap<>();
        byte[] bytes = request.getInputStream().readAllBytes();
        String body = new String(bytes, StandardCharsets.UTF_8);

        if (!body.isEmpty()) {
            String[] pairs = body.split("&");
            for (String pair : pairs) {
                String[] kv = pair.split("=");
                if (kv.length == 2) {
                    String key = URLDecoder.decode(kv[0], StandardCharsets.UTF_8);
                    String value = URLDecoder.decode(kv[1], StandardCharsets.UTF_8);
                    if (params.containsKey(key)) {
                        params.put(key, params.get(key) + "," + value);
                    } else {
                        params.put(key, value);
                    }
                }
            }
        }
        return params;
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                Long id = Long.valueOf(idRaw);
                permissionDao.delete(id);
            }

            response.setHeader("HX-Location", request.getContextPath() + "/admin/permission");
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Xóa thất bại");
        }
    }
}
