<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="carcompai.Model" %>

<%
    List<Model> viewed = (List<Model>) request.getAttribute("recentlyViewed");
    boolean empty = (viewed == null || viewed.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
<title>Recently Viewed Cars</title>
<style>
body {
    background:#020617;
    color:white;
    font-family:Inter, sans-serif;
}
.car {
    background:#111827;
    padding:20px;
    margin:20px;
    border-radius:14px;
}
</style>
</head>
<body>

<h1 style="padding:20px;">Recently Viewed Cars</h1>

<% if (empty) { %>
    <p style="padding:20px; color:#9ca3af;">No recently viewed cars.</p>
<% } else { %>

<% for (Model m : viewed) { %>
<div class="car">
    <h2><%= m.getBrandName() %> - <%= m.getModelName() %></h2>
    <p>₹ <%= m.getPrice() %></p>
</div>
<% } %>

<% } %>

</body>
</html>
