package model;

import java.sql.*;

public class DBConnection {
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe", "system", "student");
    }
}

