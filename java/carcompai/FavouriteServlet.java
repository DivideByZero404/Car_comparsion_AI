package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;


public class FavouriteServlet extends HttpServlet {

    private FavouriteDAO favDAO = new FavouriteDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("user_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("user_id");
        String modelIdParam = req.getParameter("modelId");
        String removeParam = req.getParameter("remove");

        if (modelIdParam == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "modelId missing");
            return;
        }

        int modelId = Integer.parseInt(modelIdParam);
        boolean remove = Boolean.parseBoolean(removeParam);

        try {
            if (remove) {
                favDAO.removeFavourite(userId, modelId);
            } else {
                favDAO.addFavourite(userId, modelId);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // refresh updated list in session
        try {
            List<Integer> ids = favDAO.getAllFavouriteIds(userId);
            List<Model> updatedFavs = favDAO.getFavouritesByIds(ids);
            session.setAttribute("favourites", updatedFavs);
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/favourites");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("user_id") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("user_id");

        try {
            // load from DB
            List<Integer> favIds = favDAO.getAllFavouriteIds(userId);
            List<Model> favModels = favDAO.getFavouritesByIds(favIds);

            // save to session (so JSP can use session.getAttribute)
            session.setAttribute("favourites", favModels);

            // also set request attribute (JSP uses this)
            req.setAttribute("favourites", favModels);

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/favourites.jsp").forward(req, resp);
    }
}
