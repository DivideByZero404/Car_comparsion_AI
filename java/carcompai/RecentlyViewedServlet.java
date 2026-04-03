package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class RecentlyViewedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        List<Model> viewed = (List<Model>) session.getAttribute("recentlyViewed");

        if (viewed == null) {
            viewed = new ArrayList<>();
        }

        req.setAttribute("recentlyViewed", viewed);

        req.getRequestDispatcher("/recentlyViewed.jsp").forward(req, resp);
    }
}
