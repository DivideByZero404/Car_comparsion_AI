package carcompai;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.*;


public class CompareServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Model> list = (List<Model>) session.getAttribute("compareModels");

        if (list == null) {
            list = new ArrayList<>();
        }

        request.setAttribute("compareModels", list);
        request.getRequestDispatcher("/compare.jsp").forward(request, response);
    }
}
