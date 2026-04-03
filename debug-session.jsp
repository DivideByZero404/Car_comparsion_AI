<%@ page import="java.util.*" %>
<%
out.println("Session Debug:<br>");
out.println("Session ID: " + session.getId() + "<br><br>");

out.println("All session attributes:<br>");
Enumeration<String> attrs = session.getAttributeNames();
while (attrs.hasMoreElements()) {
    String name = attrs.nextElement();
    Object value = session.getAttribute(name);
    out.println(name + " = " + value + "<br>");
}

out.println("<br>Request parameters:<br>");
Enumeration<String> params = request.getParameterNames();
while (params.hasMoreElements()) {
    String name = params.nextElement();
    String value = request.getParameter(name);
    out.println(name + " = " + value + "<br>");
}

out.println("<br>Referer: " + request.getHeader("referer") + "<br>");
%>