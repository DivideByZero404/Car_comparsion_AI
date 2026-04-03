package carcompai;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarDao {

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/carcompai_db",
                "root",
                "root"
        );
    }

    // Map Row EXACTLY to Model.java
    private Model mapRow(ResultSet rs) throws Exception {
        return new Model(
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
    }

    // ============================
    // GET MODEL BY ID
    // ============================
    public Model getModelById(int modelId) {

        String sql = "SELECT * FROM models WHERE model_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, modelId);
            ResultSet rs = ps.executeQuery();

            if (rs.next())
                return mapRow(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // ============================
    // SEARCH CARS
    // ============================
    public List<Model> searchCars(String fuelType, String transmission, double maxPrice, String sortBy) {

        List<Model> list = new ArrayList<>();

        StringBuilder sb = new StringBuilder("SELECT * FROM models WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (fuelType != null && !fuelType.equalsIgnoreCase("Any")) {
            sb.append(" AND fuel_type = ? ");
            params.add(fuelType);
        }

        if (transmission != null && !transmission.equalsIgnoreCase("Any")) {
            sb.append(" AND transmission = ? ");
            params.add(transmission);
        }

        if (maxPrice > 0) {
            sb.append(" AND price <= ? ");
            params.add(maxPrice);
        }

        // Sorting
        if (sortBy != null) {
            switch (sortBy) {
                case "price_asc": sb.append(" ORDER BY price ASC "); break;
                case "price_desc": sb.append(" ORDER BY price DESC "); break;
                case "year_asc": sb.append(" ORDER BY release_year ASC "); break;
                case "year_desc": sb.append(" ORDER BY release_year DESC "); break;
            }
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++)
                ps.setObject(i + 1, params.get(i));

            ResultSet rs = ps.executeQuery();

            while (rs.next())
                list.add(mapRow(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

   // =======================================================
// GET CARS UNDER PRICE
// =======================================================
public List<Model> getCarsUnderPrice(double maxPrice) {

    List<Model> list = new ArrayList<>();
    String sql = "SELECT * FROM models WHERE price <= ? ORDER BY price ASC";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setDouble(1, maxPrice);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) list.add(mapRow(rs));
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}


// =======================================================
// GET ELECTRIC / HYBRID CARS
// =======================================================
public List<Model> getElectricCars() {

    List<Model> list = new ArrayList<>();
    String sql =
        "SELECT * FROM models WHERE fuel_type IN ('Electric','Hybrid') ORDER BY price ASC";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) list.add(mapRow(rs));
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}


// =======================================================
// GET LATEST MODELS
// =======================================================
public List<Model> getLatestModels() {

    List<Model> list = new ArrayList<>();
    String sql = "SELECT * FROM models ORDER BY release_year DESC LIMIT 50";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) list.add(mapRow(rs));
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}


}
