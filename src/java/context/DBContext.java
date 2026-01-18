/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import util.CommonVariables;
/**
 *
 * @author Admin
 */
public class DBContext {

    protected static Connection connection ;
    
    // Get database connection
    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                // Register JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Create connection
                connection = DriverManager.getConnection(CommonVariables.URL, CommonVariables.USERNAME, CommonVariables.PASSWORD);
                System.out.println("Database connected successfully!");
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Connection failed! Check output console");
            e.printStackTrace();
        }
        return connection;
    }
    
    // Close database connection
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection!");
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Connection connection = getConnection();
    }
    
}
