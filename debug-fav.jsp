<%@ page import="java.sql.*" %>
<%@ page import="carcompai.FavouriteDAO" %>
<%
HttpSession userSession = request.getSession();
Integer userId = (Integer) userSession.getAttribute("user_id");
String email = (String) userSession.getAttribute("email");

out.println("Current user - ID: " + userId + ", Email: " + email + "<br><br>");

if (userId != null) {
    try {
        FavouriteDAO dao = new FavouriteDAO();
        java.util.List<Integer> favIds = dao.getAllFavouriteIds(userId);
        out.println("User " + userId + " favourites: " + favIds + "<br>");
        
        // Check database directly
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/carcompai_db?useSSL=false&allowPublicKeyRetrieval=true",
            "root", "root");
        
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM user_favourites");
        out.println("<br>All data in user_favourites table:<br>");
        while (rs.next()) {
            out.println("ID: " + rs.getInt("id") + ", UserID: " + rs.getInt("user_id") + ", ModelID: " + rs.getInt("model_id") + "<br>");
        }
        
        // Check if old favourites table exists
        ResultSet rs2 = stmt.executeQuery("SHOW TABLES LIKE 'favourites'");
        if (rs2.next()) {
            out.println("<br>OLD favourites table still exists!<br>");
            ResultSet rs3 = stmt.executeQuery("SELECT * FROM favourites");
            while (rs3.next()) {
                out.println("Old table - ModelID: " + rs3.getInt("model_id") + "<br>");
            }
        }
        
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
} else {
    out.println("User not logged in");
}
%>