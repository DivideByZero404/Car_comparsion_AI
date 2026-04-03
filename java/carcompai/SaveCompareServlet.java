package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SaveCompareServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String idStr = req.getParameter("modelId");

        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        int modelId = Integer.parseInt(idStr);

        CarDao dao = new CarDao();
        Model m = dao.getModelById(modelId);

        // Session contains Model objects
        List<Model> compareList = (List<Model>) session.getAttribute("compareList");

        if (compareList == null)
            compareList = new ArrayList<>();

        // Avoid duplicates + limit 3
        boolean exists = compareList.stream()
                .anyMatch(x -> x.getModelId() == modelId);

        if (!exists && compareList.size() < 3)
            compareList.add(m);

        session.setAttribute("compareList", compareList);

        resp.sendRedirect(req.getContextPath() + "/compare");
    }
}
