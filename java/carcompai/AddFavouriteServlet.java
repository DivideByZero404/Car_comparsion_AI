package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class AddFavouriteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Check if user is logged in
        HttpSession session = req.getSession();
        if (session.getAttribute("email") == null || session.getAttribute("user_id") == null) {
            resp.setContentType("application/json");
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Please login to add favorites\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String modelIdStr = req.getParameter("modelId");
        if (modelIdStr == null) {
            resp.sendRedirect("search");
            return;
        }

        try {
            FavouriteDAO dao = new FavouriteDAO();
            dao.addFavourite(userId, Integer.parseInt(modelIdStr));
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect("favourites");
    }
}
