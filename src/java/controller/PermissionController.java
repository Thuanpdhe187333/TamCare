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
        request.getRequestDispatcher(ViewPath.PERMISSION_CREATE).forward(request, response);
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
            response.setHeader("HX-Location", request.getContextPath() + "/admin/permission");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật thất bại");
        }
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
                    params.put(URLDecoder.decode(kv[0], StandardCharsets.UTF_8),
                               URLDecoder.decode(kv[1], StandardCharsets.UTF_8));
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
