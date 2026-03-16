/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin gói từ membership.jsp
        String packageId = request.getParameter("packageId");
        String pointCost = request.getParameter("pointCost");
        
        // Đẩy thông tin sang trang confirm_payment.jsp
        request.setAttribute("packageId", packageId);
        request.setAttribute("pointCost", pointCost);
        request.getRequestDispatcher("confirm_payment.jsp").forward(request, response);
    }
}