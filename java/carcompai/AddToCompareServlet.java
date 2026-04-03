package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

public class AddToCompareServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int modelId = Integer.parseInt(request.getParameter("modelId"));

        CarDao dao = new CarDao();
        Model model = dao.getModelById(modelId);

        HttpSession session = request.getSession();
        List<Model> list = (List<Model>) session.getAttribute("compareModels");

        if (list == null) {
            list = new ArrayList<>();
        }

        // avoid duplicates
        boolean exists = false;
        for (Model m : list) {
            if (m.getModelId() == modelId) {
                exists = true;
                break;
            }
        }

        if (!exists && model != null) {
            list.add(model);
        }

        session.setAttribute("compareModels", list);
        
        // Store search parameters for back navigation
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("search")) {
            session.setAttribute("search_referer", referer);
        }

        response.sendRedirect("compare");
    }
}
