package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

public class RemoveCompareServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int modelId = Integer.parseInt(request.getParameter("modelId"));

        HttpSession session = request.getSession();
        List<Model> list = (List<Model>) session.getAttribute("compareModels");

        if (list != null) {
            list.removeIf(m -> m.getModelId() == modelId);
        }

        session.setAttribute("compareModels", list);
        response.sendRedirect("compare");
    }
}
