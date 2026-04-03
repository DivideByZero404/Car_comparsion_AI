<%@ page import="carcompai.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
String username = "testuser2";
String email = "test2@test.com";
String password = "testpass2";

Connection conn = null;
PreparedStatement pstmt = null;

try {
    conn = DBConnection.getConnection();
    if (conn == null) {
        out.println("Database connection failed");
        return;
    }
    
    String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, username);
    pstmt.setString(2, email);
    pstmt.setString(3, password);
    
    int result = pstmt.executeUpdate();
    
    if (result > 0) {
        out.println("Account created successfully! User: " + username + ", Email: " + email);
    } else {
        out.println("Failed to create account");
    }
    
} catch (SQLException e) {
    out.println("Database error: " + e.getMessage());
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>