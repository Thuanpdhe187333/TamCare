/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "AdminStatsServlet", urlPatterns = {"/admin-stats"})
public class AdminStatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        
        // 1. Lấy dữ liệu cho biểu đồ
        Map<String, Integer> roleData = dao.countUserByRole();
        Map<String, Integer> growthData = dao.getUserGrowth();
        
        // 2. Lấy danh sách user cho bảng CRUD
        List<User> list = dao.getAllUsers();
        
        request.setAttribute("roleData", roleData);
        request.setAttribute("growthData", growthData);
        request.setAttribute("listUsers", list);
        
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }
}