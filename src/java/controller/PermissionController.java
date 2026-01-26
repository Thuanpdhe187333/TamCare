package controller;

import dto.PageResponseDTO;
import dto.PermissionDTO;
import dto.PermissionRequest;
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
import service.PermissionService;
import service.RoleService;
import util.ViewPath;

@WebServlet(name = "PermissionController", urlPatterns = {"/admin/permission", "/admin/permission/*"})
public class PermissionController extends HttpServlet {

    private static final Long DEFAULT_PAGE = (long) 1;
    private static final Long DEFAULT_SIZE = (long) 10;

    private final PermissionService permissionService = new PermissionService();
    private final RoleService roleService = new RoleService();

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

            PageResponseDTO<PermissionDTO> pageResponse = permissionService.getPagedList(search, sort, page, size);

            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("sort", sortRaw);
            request.setAttribute("search", searchRaw);
            request.setAttribute("pages", pageResponse.getTotalPages());
            request.setAttribute("total", pageResponse.getTotalItems());
            request.setAttribute("permissions", pageResponse.getItems());

            request.getRequestDispatcher(ViewPath.PERMISSION_LIST).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void viewCreate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("roles", roleService.getAll());
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
            PermissionDTO permission = permissionService.getDetail(id);
            if (permission == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Permission not found");
                return;
            }
            request.setAttribute("permission", permission);
            request.setAttribute("roles", permissionService.getRolesByPermissionId(id));
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
            PermissionDTO permission = permissionService.getDetail(id);
            if (permission == null) {
                response.sendRedirect(request.getContextPath() + "/admin/permission");
                return;
            }
            request.setAttribute("permission", permission);
            request.setAttribute("roles", roleService.getAll());
            request.setAttribute("currentRoleIds", permissionService.getRolesByPermissionId(id).stream().map(model.Role::getRoleId).toList());
            request.getRequestDispatcher(ViewPath.PERMISSION_UPDATE).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/permission");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        PermissionRequest pReq = new PermissionRequest();
        pReq.setCode(request.getParameter("code"));
        pReq.setName(request.getParameter("name"));
        
        String[] roleIdsRaw = request.getParameterValues("roleIds");
        if (roleIdsRaw != null) {
            pReq.setRoleIds(java.util.Arrays.stream(roleIdsRaw).map(Long::valueOf).toList());
        }

        try {
            permissionService.create(pReq);
            response.sendRedirect(request.getContextPath() + "/admin/permission");
        } catch (util.ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("permission", pReq);
            viewCreate(request, response);
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
            if (idRaw == null) idRaw = request.getParameter("id");
            Long id = Long.valueOf(idRaw);

            PermissionRequest pReq = new PermissionRequest();
            pReq.setCode(params.get("code"));
            pReq.setName(params.get("name"));
            pReq.setRoleIds(getRoleIdsFromParams(params, "roleIds"));
            
            try {
                permissionService.update(id, pReq);
                response.setHeader("HX-Location", request.getContextPath() + "/admin/permission");
            } catch (util.ValidationException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
        }
    }

    private java.util.List<Long> getRoleIdsFromParams(Map<String, String> params, String key) {
        java.util.List<Long> list = new java.util.ArrayList<>();
        if (params.containsKey(key)) {
             String val = params.get(key);
             for(String s : val.split(",")) {
                 if(!s.isBlank()) list.add(Long.valueOf(s.trim()));
             }
        }
        return list;
    }

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
                permissionService.delete(id);
            }
            response.setHeader("HX-Location", request.getContextPath() + "/admin/permission");
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Xóa thất bại");
        }
    }
}
