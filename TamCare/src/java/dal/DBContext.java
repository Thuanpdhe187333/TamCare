/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal; // Đã đổi tên package cho chuẩn MVC

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author TamCare Team
 */
public class DBContext {

    protected Connection connection;

    public DBContext() {
        try {
            // Thay đổi thông tin đăng nhập của bạn ở đây
            String user = "sa";
            String pass = "123"; // Mật khẩu SQL của bạn (nếu khác 123 hãy sửa lại)
            
            // Đã đổi tên Database thành TamCareDB và thêm tham số bảo mật
            String url = "jdbc:sqlserver://localhost:1433;databaseName=TamCareDB;encrypt=true;trustServerCertificate=true";
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    // Chạy file này (Shift + F6) để kiểm tra kết nối
    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        if (dbContext.isConnected()) {
            System.out.println("Done!");
        } else {
            System.out.println("Kết nối cơ sở dữ liệu thất bại. Vui lòng kiểm tra lại user/pass hoặc tên database.");
        }
        dbContext.closeConnection();
    }
}