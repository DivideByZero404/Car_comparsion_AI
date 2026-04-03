package carcompai;

import java.io.IOException;
import java.util.List;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fuelType = safe(request.getParameter("fuel_type"));
        String transmission = safe(request.getParameter("transmission"));
        String priceStr = safe(request.getParameter("max_price"));
        String sortBy = safe(request.getParameter("sort_by"));
        String suggestion = safe(request.getParameter("suggestion"));
        
        // Store original search parameters in session
        HttpSession session = request.getSession();
        String origFuel = fuelType != null ? fuelType : "Any";
        String origTrans = transmission != null ? transmission : "Any";
        String origPrice = priceStr != null ? priceStr : "1500000";
        String origSort = sortBy != null ? sortBy : "price_asc";
        
        session.setAttribute("last_fuel_type", origFuel);
        session.setAttribute("last_transmission", origTrans);
        session.setAttribute("last_max_price", origPrice);
        session.setAttribute("last_sort_by", origSort);

        CarDao dao = new CarDao();
        FavouriteDAO favDao = new FavouriteDAO();   // ⭐ added
        List<Model> results;

        // ⭐ Fetch favourite count once
        int favCount = 0;
        try {
            if (session.getAttribute("user_id") != null) {
                int userId = (Integer) session.getAttribute("user_id");
                favCount = favDao.getFavouriteCount(userId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.setAttribute("favCount", favCount);  // ⭐ send to JSP

        // ---------------- REMOVE "Any" ----------------
        if ("Any".equalsIgnoreCase(fuelType)) fuelType = null;
        if ("Any".equalsIgnoreCase(transmission)) transmission = null;

        // ---------------- CLEAN PRICE ----------------
        double maxPrice = cleanPrice(priceStr);
        
        // Debug output
        System.out.println("Search params - Fuel: " + fuelType + ", Trans: " + transmission + ", Price: " + maxPrice + ", Sort: " + sortBy);

        /* -------- SMART SUGGESTIONS -------- */
        if (suggestion != null) {

            switch (suggestion) {

                case "budget_under_10":
                    results = dao.getCarsUnderPrice(1000000);
                    break;

                case "electric":
                    results = dao.getElectricCars();
                    break;

                case "latest":
                    results = dao.getLatestModels();
                    break;

                default:
                    results = dao.searchCars(fuelType, transmission, maxPrice, sortBy);
            }

            request.setAttribute("results", results);
            request.getRequestDispatcher("/results.jsp").forward(request, response);
            return;
        }

        /* -------- NORMAL SEARCH -------- */
        results = dao.searchCars(fuelType, transmission, maxPrice, sortBy);

        request.setAttribute("results", results);
        request.getRequestDispatcher("/results.jsp").forward(request, response);
    }

    // SAFE STRING
    private String safe(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    // ⭐ CLEAN PRICE LIKE "₹ 12,50,000" → 1250000
    private double cleanPrice(String s) {
        if (s == null) return -1;

        try {
            s = s.replaceAll("[^0-9]", "");  // remove ₹ , commas , spaces
            if (s.isEmpty()) return -1;
            return Double.parseDouble(s);
        } catch (Exception e) {
            return -1;
        }
    }
}
