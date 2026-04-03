package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

public class RemoveFavouriteServlet extends HttpServlet {

    private FavouriteDAO favouriteDAO;

    @Override
    public void init() throws ServletException {
        favouriteDAO = new FavouriteDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        String modelIdParam = req.getParameter("modelId");

        if (modelIdParam == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\":\"error\",\"message\":\"Missing modelId\"}");
            return;
        }

        try {
            int modelId = Integer.parseInt(modelIdParam);
            HttpSession session = req.getSession();
            int userId = (Integer) session.getAttribute("user_id");
            favouriteDAO.removeFavourite(userId, modelId);

            int count = favouriteDAO.getFavouriteCount(userId);
            out.write("{\"status\":\"ok\",\"count\":" + count + "}");
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("{\"status\":\"error\",\"message\":\"Invalid modelId\"}");
        } catch (SQLException e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"status\":\"error\",\"message\":\"DB error\"}");
            e.printStackTrace();
        }
    }
}
