package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class SaveActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");

        String action = req.getParameter("action");    // compare / fav
        String brandName = req.getParameter("brandName");
        String modelName = req.getParameter("modelName");
        String priceStr = req.getParameter("price");
        String imageUrl = req.getParameter("imageUrl");

        if (action == null || brandName == null || modelName == null || priceStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Safely parse price
        double price = 0;
        try {
            price = Double.parseDouble(priceStr.trim());
        } catch (NumberFormatException e) {
            price = 0; // default fallback
        }

        // Determine table name
        String table;
        if ("compare".equalsIgnoreCase(action)) {
            table = "comparisons";
        } else if ("fav".equalsIgnoreCase(action)) {
            table = "favourites";
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String sql = "INSERT INTO " + table +
                " (brand_name, model_name, price, image_url) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, brandName);
            ps.setString(2, modelName);
            ps.setDouble(3, price);
            ps.setString(4, imageUrl);
            ps.executeUpdate();

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
