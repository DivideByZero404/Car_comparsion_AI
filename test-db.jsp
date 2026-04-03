<%@ page import="carcompai.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
Connection conn = null;
try {
    conn = DBConnection.getConnection();
    if (conn != null) {
        out.println("Database connection: SUCCESS<br>");
        
        // Test insert
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "testuser");
        pstmt.setString(2, "test@test.com");
        pstmt.setString(3, "testpass");
        
        int result = pstmt.executeUpdate();
        out.println("Insert result: " + result + "<br>");
        
        // Test select
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM users");
        out.println("Users in database:<br>");
        while (rs.next()) {
            out.println("ID: " + rs.getInt("user_id") + ", Username: " + rs.getString("username") + ", Email: " + rs.getString("email") + "<br>");
        }
        
        pstmt.close();
        stmt.close();
        conn.close();
    } else {
        out.println("Database connection: FAILED");
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
    e.printStackTrace();
}
%>