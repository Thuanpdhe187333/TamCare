package controller;

import dao.PurchaseOrderDAO;
import dto.PurchaseOrderListDTO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import util.ViewPath;

public class PurchaseOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int size = 20;

        String pageParam = request.getParameter("page");
        if (pageParam != null) page = Integer.parseInt(pageParam);

        int offset = (page - 1) * size;

        try {
            PurchaseOrderDAO dao = new PurchaseOrderDAO();
            List<PurchaseOrderListDTO> pos = dao.getPurchaseList(size, offset);
            request.setAttribute("pos", pos);
            request.setAttribute("page", page);
            request.getRequestDispatcher(ViewPath.PO_LIST).forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
