package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import util.CommonVariables;

public class DBContext {

    // Get database connection
    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(CommonVariables.URL, CommonVariables.USERNAME, CommonVariables.PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return conn; // Trả về đối tượng kết nối mới
    }

    public static void main(String[] args) {
        getConnection();
    }

}
