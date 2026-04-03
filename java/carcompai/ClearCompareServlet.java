package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ClearCompareServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        // Remove the compare list completely
        session.removeAttribute("compareModels");

        // Redirect back to compare page
        resp.sendRedirect("compare");
    }
}
