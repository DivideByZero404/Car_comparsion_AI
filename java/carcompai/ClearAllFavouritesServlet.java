package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClearAllFavouritesServlet extends HttpServlet {

    private FavouriteDAO favDAO = new FavouriteDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // 1️⃣ CLEAR FROM DATABASE
        try {
            int userId = (Integer) session.getAttribute("user_id");
            favDAO.clearAllFavourites(userId);
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // 2️⃣ CLEAR FROM SESSION
        session.setAttribute("favourites", new ArrayList<Model>());

        // 🔴 reset the count so navbar indicator = 0
        session.setAttribute("favCount", 0);

        // 3️⃣ REDIRECT TO FAVOURITES PAGE (fresh load)
        resp.sendRedirect(req.getContextPath() + "/favourites");
    }
}
