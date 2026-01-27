package controller;

import dto.PageResponseDTO;
import dto.RoleDTO;
import dto.RoleRequest;
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

@WebServlet(name = "RoleController", urlPatterns = {"/admin/role", "/admin/role/*"})
public class RoleController extends HttpServlet {

    private static final Long DEFAULT_PAGE = 1L;
    private static final Long DEFAULT_SIZE = 10L;

    private final RoleService roleService = new RoleService();
    private final PermissionService permissionService = new PermissionService();

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
            var sort = (sortRaw == null || sortRaw.isEmpty()) ? "role_id" : sortRaw;

            var searchRaw = request.getParameter("search");
            var search = searchRaw == null ? "%%" : "%" + searchRaw + "%";

            PageResponseDTO<RoleDTO> pageResponse = roleService.getPagedList(search, sort, page, size);

            request.setAttribute("page", page);
            request.setAttribute("size", size);
            request.setAttribute("sort", sortRaw);
            request.setAttribute("search", searchRaw);
            request.setAttribute("pages", pageResponse.getTotalPages());
            request.setAttribute("total", pageResponse.getTotalItems());
            request.setAttribute("roles", pageResponse.getItems());

            request.getRequestDispatcher(ViewPath.ROLE_LIST).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            RoleDTO role = roleService.getById(id);
            if (role == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Role not found");
                return;
            }
            request.setAttribute("role", role);
            request.setAttribute("permissions", roleService.getPermissionsDetailByRoleId(id));
            request.getRequestDispatcher(ViewPath.ROLE_DETAIL).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading detail");
        }
    }

    private void viewCreate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            request.setAttribute("permissions", permissionService.getAll("%%", "code"));
            request.getRequestDispatcher(ViewPath.ROLE_CREATE).forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            viewList(request, response);
        }
    }

    private void viewUpdate(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            Long id = Long.valueOf(request.getParameter("id"));
            RoleDTO role = roleService.getById(id);
            if (role == null) {
                response.sendRedirect(request.getContextPath() + "/admin/role");
                return;
            }
            request.setAttribute("role", role);
            request.setAttribute("permissions", permissionService.getAll("%%", "code"));
            request.setAttribute("selectedPermissionIds", roleService.getPermissionsByRoleId(id));
            request.getRequestDispatcher(ViewPath.ROLE_UPDATE).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/role");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        RoleRequest rReq = new RoleRequest();
        rReq.setName(request.getParameter("name"));
        rReq.setDescription(request.getParameter("description"));
        
        String[] pIds = request.getParameterValues("permissionIds");
        if (pIds != null) {
            rReq.setPermissionIds(java.util.Arrays.stream(pIds).map(Long::valueOf).toList());
        }

        try {
            roleService.create(rReq);
            response.sendRedirect(request.getContextPath() + "/admin/role");
        } catch (util.ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("role", rReq);
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
            Map<String, String[]> params = parseFormBodyExtended(request);
            
            String idRaw = request.getParameter("id");
            if (idRaw == null && params.containsKey("id")) idRaw = params.get("id")[0];
            Long id = Long.valueOf(idRaw);

            RoleRequest rReq = new RoleRequest();
            rReq.setName(params.get("name")[0]);
            rReq.setDescription(params.get("description")[0]);
            
            String[] permissionIds = params.get("permissionIds");
            if (permissionIds != null) {
                rReq.setPermissionIds(java.util.Arrays.stream(permissionIds).map(Long::valueOf).toList());
            }

            try {
                roleService.update(id, rReq);
                response.setHeader("HX-Location", request.getContextPath() + "/admin/role");
            } catch (util.ValidationException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(e.getMessage());
            }
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
                roleService.delete(id);
            }
            response.setHeader("HX-Location", request.getContextPath() + "/admin/role");
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Xóa thất bại");
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
