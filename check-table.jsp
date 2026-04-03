<%@ page import="java.sql.*" %>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/carcompai_db?useSSL=false&allowPublicKeyRetrieval=true",
        "root", "root");
    
    // Check if table exists
    DatabaseMetaData meta = conn.getMetaData();
    ResultSet rs = meta.getTables(null, null, "user_favourites", null);
    
    if (rs.next()) {
        out.println("user_favourites table EXISTS<br>");
        
        // Show table structure
        Statement stmt = conn.createStatement();
        ResultSet rs2 = stmt.executeQuery("DESCRIBE user_favourites");
        out.println("Table structure:<br>");
        while (rs2.next()) {
            out.println(rs2.getString("Field") + " - " + rs2.getString("Type") + "<br>");
        }
        
        // Show data
        ResultSet rs3 = stmt.executeQuery("SELECT * FROM user_favourites");
        out.println("<br>Data in table:<br>");
        while (rs3.next()) {
            out.println("ID: " + rs3.getInt("id") + ", UserID: " + rs3.getInt("user_id") + ", ModelID: " + rs3.getInt("model_id") + "<br>");
        }
        
    } else {
        out.println("user_favourites table DOES NOT EXIST<br>");
        
        // Create it
        Statement stmt = conn.createStatement();
        stmt.executeUpdate("CREATE TABLE user_favourites (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, model_id INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE, UNIQUE KEY unique_user_model (user_id, model_id))");
        out.println("Table created successfully!<br>");
    }
    
    conn.close();
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
}
%>