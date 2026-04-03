package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ViewFavouritesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Model> favList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {

            String sql = """
                SELECT m.model_id, m.brand_name, m.model_name, m.price,
                       m.engine_cc, m.fuel_type, m.transmission,
                       m.release_year, m.image_url, m.top_features, m.official_url
                FROM favourites f
                JOIN models m ON f.model_id = m.model_id
                ORDER BY f.added_at DESC
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Model m = new Model(
                        rs.getInt("model_id"),
                        rs.getString("brand_name"),
                        rs.getString("model_name"),
                        rs.getDouble("price"),
                        rs.getString("engine_cc"),
                        rs.getString("fuel_type"),
                        rs.getString("transmission"),
                        rs.getInt("release_year"),
                        rs.getString("image_url"),
                        rs.getString("top_features"),
                        rs.getString("official_url")
                );

                favList.add(m);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("favourites", favList);
        req.getRequestDispatcher("/favourites.jsp").forward(req, resp);
    }
}
