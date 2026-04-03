<%
String ctx = request.getContextPath();
String lastFuel = (String) session.getAttribute("last_fuel_type");
String lastTrans = (String) session.getAttribute("last_transmission");
String lastPrice = (String) session.getAttribute("last_max_price");
String lastSort = (String) session.getAttribute("last_sort_by");

String searchUrl = ctx + "/search";
if (lastFuel != null) {
    searchUrl += "?fuel_type=" + lastFuel + "&transmission=" + lastTrans + "&max_price=" + lastPrice + "&sort_by=" + lastSort;
}

out.println("Generated URL: " + searchUrl + "<br>");
out.println("lastFuel: " + lastFuel + "<br>");
out.println("lastTrans: " + lastTrans + "<br>");
out.println("lastPrice: " + lastPrice + "<br>");
out.println("lastSort: " + lastSort + "<br>");
%>
<a href="<%= searchUrl %>">Test Link</a>