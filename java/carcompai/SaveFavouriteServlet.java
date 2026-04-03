package carcompai;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

  // ⭐ THIS WAS MISSING EARLIER
public class SaveFavouriteServlet extends HttpServlet {

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
            resp.sendRedirect("login.jsp");
            return;
        }

        int modelId = Integer.parseInt(req.getParameter("modelId"));
        boolean remove = Boolean.parseBoolean(req.getParameter("remove"));

        FavouriteDAO favDAO = new FavouriteDAO();

        int userId = (Integer) req.getSession().getAttribute("user_id");
        
        try {
            if (remove) {
                favDAO.removeFavourite(userId, modelId);
            } else {
                favDAO.addFavourite(userId, modelId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getHeader("referer"));
    }
}
