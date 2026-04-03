package carcompai;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavouriteDAO {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/carcompai_db?useSSL=false&allowPublicKeyRetrieval=true",
                "root",
                "root"
        );
    }

    public void addFavourite(int userId, int modelId) throws SQLException {
        String sql = "INSERT IGNORE INTO user_favourites(user_id, model_id) VALUES(?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, modelId);
            ps.executeUpdate();
        }
    }

    public void removeFavourite(int userId, int modelId) throws SQLException {
        String sql = "DELETE FROM user_favourites WHERE user_id = ? AND model_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, modelId);
            ps.executeUpdate();
        }
    }

    public int getFavouriteCount(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_favourites WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }

        return 0;
    }

    public void clearAllFavourites(int userId) throws SQLException {
        String sql = "DELETE FROM user_favourites WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public List<Integer> getAllFavouriteIds(int userId) throws SQLException {

        List<Integer> list = new ArrayList<>();
        String sql = "SELECT model_id FROM user_favourites WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("model_id"));
                }
            }
        }

        return list;
    }

    public List<Model> getFavouritesByIds(List<Integer> ids) throws SQLException {

        if (ids == null || ids.isEmpty()) return new ArrayList<>();

        List<Model> result = new ArrayList<>();

        String sql = "SELECT * FROM models WHERE model_id IN (" +
                ids.toString().replace("[", "").replace("]", "") + ")";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

                result.add(m);
            }
        }

        return result;
    }
}