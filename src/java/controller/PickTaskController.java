package controller;

import dao.PickTaskDAO;
import dao.GoodsDeliveryNoteDAO;
import dao.UserDAO;
import dto.PickTaskDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PickTaskController", urlPatterns = { "/pick-task" })
public class PickTaskController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "myTasks";
        }

        try {
            switch (action) {
                case "myTasks" -> handleMyTasks(request, response);
                case "detail" -> handleDetail(request, response);
                case "assign" -> handleAssignForm(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/pick-task?action=myTasks");
            }
        } catch (Exception e) {
            Logger.getLogger(PickTaskController.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException(e);
        }
    }

    private void handleMyTasks(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PickTaskDAO pickTaskDao = new PickTaskDAO();
        
        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String status = request.getParameter("status");
        List<PickTaskDTO> tasks = pickTaskDao.getMyPickTasks(user.getUserId(), status);

        request.setAttribute("tasks", tasks);
        request.setAttribute("status", status);

        request.getRequestDispatcher("WEB-INF/views/outbound/pick-task-list.jsp")
               .forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PickTaskDAO pickTaskDao = new PickTaskDAO();
        Long pickTaskId = parseLong(request.getParameter("id"), -1);
        
        if (pickTaskId <= 0) {
            response.sendRedirect(request.getContextPath() + "/pick-task?action=myTasks");
            return;
        }

        PickTaskDTO task = pickTaskDao.getPickTaskById(pickTaskId);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/pick-task?action=myTasks");
            return;
        }

        request.setAttribute("task", task);
        request.getRequestDispatcher("WEB-INF/views/outbound/pick-task-detail.jsp")
               .forward(request, response);
    }

    private void handleAssignForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        GoodsDeliveryNoteDAO gdnDao = new GoodsDeliveryNoteDAO();
        UserDAO userDao = new UserDAO();
        
        Long gdnId = parseLong(request.getParameter("gdnId"), -1);
        if (gdnId <= 0) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
            return;
        }

        dto.GDNDetailDTO gdn = gdnDao.getGDNDetailById(gdnId);
        if (gdn == null) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
            return;
        }

        // Get warehouse staff users
        List<model.User> warehouseStaff = userDao.getUsersByRole("WAREHOUSE_STAFF");

        request.setAttribute("gdn", gdn);
        request.setAttribute("warehouseStaff", warehouseStaff);

        request.getRequestDispatcher("WEB-INF/views/outbound/pick-task-assign.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "assign" -> handleAssign(request, response);
                case "confirm" -> handleConfirm(request, response);
                default -> response.sendRedirect(request.getContextPath() + "/pick-task?action=myTasks");
            }
        } catch (Exception e) {
            Logger.getLogger(PickTaskController.class.getName()).log(Level.SEVERE, null, e);
            throw new ServletException(e);
        }
    }

    private void handleAssign(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PickTaskDAO pickTaskDao = new PickTaskDAO();
        GoodsDeliveryNoteDAO gdnDao = new GoodsDeliveryNoteDAO();
        
        Long gdnId = parseLong(request.getParameter("gdnId"), -1);
        Long assignedTo = parseLong(request.getParameter("assignedTo"), -1);
        
        if (gdnId <= 0 || assignedTo <= 0) {
            response.sendRedirect(request.getContextPath() + "/goods-delivery-note?action=list");
            return;
        }

        User user = (User) request.getSession().getAttribute("USER");
        Long assignedBy = user != null ? user.getUserId() : null;

        Long pickTaskId = pickTaskDao.createPickTaskFromGDN(gdnId, assignedTo, assignedBy);
        
        // Update GDN status to ONGOING
        gdnDao.updateGDNStatus(gdnId, "ONGOING");
        
        response.sendRedirect(request.getContextPath() + "/pick-task?action=detail&id=" + pickTaskId);
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response) throws Exception {
        PickTaskDAO pickTaskDao = new PickTaskDAO();
        GoodsDeliveryNoteDAO gdnDao = new GoodsDeliveryNoteDAO();
        
        Long pickTaskId = parseLong(request.getParameter("pickTaskId"), -1);
        
        if (pickTaskId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Get pick task to get GDN ID
        PickTaskDTO task = pickTaskDao.getPickTaskById(pickTaskId);
        if (task == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Parse quantities from request
        String[] lineIds = request.getParameterValues("lineIds");
        String[] qtyPickedStrs = request.getParameterValues("qtyPicked");
        
        if (lineIds == null || qtyPickedStrs == null || lineIds.length != qtyPickedStrs.length) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        List<dto.PickTaskLineDTO> lines = task.getLines();
        for (int i = 0; i < lineIds.length; i++) {
            Long lineId = Long.parseLong(lineIds[i]);
            java.math.BigDecimal qtyPicked = new java.math.BigDecimal(qtyPickedStrs[i]);
            
            for (dto.PickTaskLineDTO line : lines) {
                if (line.getPickTaskLineId().equals(lineId)) {
                    line.setQtyPicked(qtyPicked);
                    break;
                }
            }
        }

        // Confirm pick task
        pickTaskDao.confirmPickTask(pickTaskId, lines);
        
        // Update GDN status to CONFIRMED
        gdnDao.updateGDNStatus(task.getGdnId(), "CONFIRMED");
        
        response.sendRedirect(request.getContextPath() + "/pick-task?action=myTasks");
    }

    private long parseLong(String raw, long def) {
        try {
            return (raw == null || raw.isBlank()) ? def : Long.parseLong(raw);
        } catch (Exception e) {
            return def;
        }
    }
}
