package carcompai;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompareDAO {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/carcompai_db",
                "root",
                "root"
        );
    }

    /* ------------------------------------------
       ADD MODEL TO COMPARE (per user)
       ------------------------------------------ */
    public void addToCompare(Integer userId, int modelId) throws SQLException {

        String deleteSql;
        String insertSql;

        if (userId == null) {
            // no login yet: store as user_id = NULL
            deleteSql = "DELETE FROM compare WHERE user_id IS NULL AND model_id = ?";
            insertSql = "INSERT INTO compare(user_id, model_id) VALUES (NULL, ?)";
        } else {
            deleteSql = "DELETE FROM compare WHERE user_id = ? AND model_id = ?";
            insertSql = "INSERT INTO compare(user_id, model_id) VALUES (?, ?)";
        }

        try (Connection conn = getConnection()) {

            // 1) make sure no duplicate row
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                if (userId == null) {
                    ps.setInt(1, modelId);
                } else {
                    ps.setInt(1, userId);
                    ps.setInt(2, modelId);
                }
                ps.executeUpdate();
            }

            // 2) insert fresh
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                if (userId == null) {
                    ps.setInt(1, modelId);
                } else {
                    ps.setInt(1, userId);
                    ps.setInt(2, modelId);
                }
                ps.executeUpdate();
            }
        }
    }

    /* ------------------------------------------
       REMOVE ONE MODEL FROM COMPARE
       ------------------------------------------ */
    public void removeFromCompare(Integer userId, int modelId) throws SQLException {
        String sql;

        if (userId == null) {
            sql = "DELETE FROM compare WHERE user_id IS NULL AND model_id = ?";
        } else {
            sql = "DELETE FROM compare WHERE user_id = ? AND model_id = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId == null) {
                ps.setInt(1, modelId);
            } else {
                ps.setInt(1, userId);
                ps.setInt(2, modelId);
            }

            ps.executeUpdate();
        }
    }

    /* ------------------------------------------
       CLEAR ALL COMPARE ITEMS FOR USER
       ------------------------------------------ */
    public void clearCompare(Integer userId) throws SQLException {
        String sql;

        if (userId == null) {
            sql = "DELETE FROM compare WHERE user_id IS NULL";
        } else {
            sql = "DELETE FROM compare WHERE user_id = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) {
                ps.setInt(1, userId);
            }

            ps.executeUpdate();
        }
    }

    /* ------------------------------------------
       GET COUNT (for badge / limit)
       ------------------------------------------ */
    public int getCompareCount(Integer userId) throws SQLException {
        String sql;

        if (userId == null) {
            sql = "SELECT COUNT(*) FROM compare WHERE user_id IS NULL";
        } else {
            sql = "SELECT COUNT(*) FROM compare WHERE user_id = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) {
                ps.setInt(1, userId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /* ------------------------------------------
       GET FULL MODEL DETAILS FOR COMPARE
       ------------------------------------------ */
    public List<Model> getCompareModels(Integer userId) throws SQLException {

        List<Model> list = new ArrayList<>();

        String sql;
        if (userId == null) {
            sql = """
                  SELECT m.*
                  FROM compare c
                  JOIN models m ON c.model_id = m.model_id
                  WHERE c.user_id IS NULL
                  """;
        } else {
            sql = """
                  SELECT m.*
                  FROM compare c
                  JOIN models m ON c.model_id = m.model_id
                  WHERE c.user_id = ?
                  """;
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null) {
                ps.setInt(1, userId);
            }

            try (ResultSet rs = ps.executeQuery()) {

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

                    list.add(m);
                }
            }
        }

        return list;
    }
}
