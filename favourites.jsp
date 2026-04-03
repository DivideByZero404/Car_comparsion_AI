<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="carcompai.Model" %>

<%
    String ctx = request.getContextPath();
    List<Model> favourites = (List<Model>) session.getAttribute("favourites");
    boolean empty = (favourites == null || favourites.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Favourite Cars – CarCompAI</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

<style>

/* ============================
   COLORS
============================ */
:root {
    --bg: #020617;
    --bg-sidebar: #030918;
    --card: #0d1525;
    --border: rgba(255,255,255,0.08);
    --text: #f8fafb;
    --text2: #a5b1c6;
    --red: #ef4444;
    --blue: #3b82f6;
}

/* ============================
   GLOBAL
============================ */
* { box-sizing: border-box; }
body {
    margin: 0;
    background: var(--bg);
    color: var(--text);
    font-family: "Inter", sans-serif;
}

/* ============================
   FIXED NAVBAR (SOLID BLACK)
============================ */
.navbar-fixed {
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    z-index: 5000;
    background: #000 !important;
    border-bottom: 1px solid var(--border);
}

.navbar-fixed .navbar {
    background: #000 !important;
}

/* ============================
   SIDEBAR
============================ */
.sidebar {
    width: 310px;
    background: var(--bg-sidebar);
    padding: 140px 28px 40px;
    border-right: 1px solid var(--border);
    min-height: 100vh;
    position: fixed;
}

.profile-box {
    background: #0f172a;
    padding: 22px;
    border-radius: 14px;
    border: 1px solid var(--border);
    margin-bottom: 35px;
}

.profile-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    overflow: hidden;
}
.profile-avatar img { width:100%; height:100%; }

.profile-name {
    margin-top: 10px;
    font-size: 18px;
    font-weight: 600;
}

.sidebar h3 {
    color: var(--text2);
    font-size: 14px;
    text-transform: uppercase;
    margin: 28px 0 12px;
}

.sidebar a {
    display: block;
    padding: 10px 0;
    font-size: 15px;
    color: var(--text);
    text-decoration: none;
    transition: 0.2s ease;
}
.sidebar a:hover { color: var(--blue); }
.sidebar a.active { color: var(--blue); font-weight: 600; }

/* ============================
   MAIN CONTENT
============================ */
.main {
    margin-left: 310px;
    padding: 150px 50px 60px;
    width: calc(100% - 310px);
}

.main h1 {
    font-size: 36px;
    font-weight: 800;
    margin-bottom: 24px;
}

/* ============================
   GRID — 3 per row
============================ */
.grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 28px;
}

/* ============================
   CAR CARD
============================ */
.car-card {
    background: var(--card);
    border-radius: 16px;
    padding: 18px;
    border: 1px solid var(--border);
}

.car-img {
    height: 190px;
    overflow: hidden;
    border-radius: 12px;
    margin-bottom: 14px;
}
.car-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.tag {
    display: inline-block;
    padding: 6px 12px;
    background: #1e293b;
    color: #cbd5e1;
    border-radius: 999px;
    font-size: 12px;
    margin-right: 6px;
}

.meta-text {
    color: var(--text2);
    font-size: 14px;
    margin-top: 8px;
}

.remove-btn {
    margin-top: 14px;
    padding: 9px 16px;
    background: var(--red);
    border: none;
    border-radius: 10px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}
.remove-btn::before { content: "♥"; }

/* ============================
   EMPTY STATE
============================ */
.empty-box {
    margin-top: 140px;
    text-align: center;
}
.empty-box img {
    width: 200px;
    opacity: 0.65;
    margin-bottom: 20px;
}
.empty-box p {
    font-size: 20px;
    color: #cbd5e1;
}

</style>
</head>

<body>

<!-- FIXED NAVBAR -->
<div class="navbar-fixed">
    <%@ include file="navbar.jsp" %>
</div>

<div class="layout">

<!-- SIDEBAR -->
<div class="sidebar">

    <h3>Dashboard</h3>
    
    <a href="<%=ctx%>/search">Search</a>
    <a class="active" href="<%=ctx%>/favourites">Favourites</a>
    <a href="<%=ctx%>/compare">Compare</a>

    <h3>Quick Tools</h3>
    <a href="#" onclick="clearAll(); return false;">🗑 Clear All Favourites</a>

    <form id="clearForm" action="<%=ctx%>/clearFavourites" method="post" style="display:none;"></form>
</div>

<!-- MAIN CONTENT -->
<div class="main">

    <h1>Your Favourite Cars</h1>

    <% if (empty) { %>

        <div class="empty-box">
            <img src="https://cdn-icons-png.flaticon.com/512/4076/4076503.png">
            <p>♥ No favourites yet — start saving cars you love!</p>
        </div>

    <% } else { %>

        <div class="grid">

        <% for (Model m : favourites) { %>

            <div class="car-card">

                <div class="car-img">
                    <img src="<%= m.getImageUrl() %>">
                </div>

                <h2><%= m.getBrandName() %> – <%= m.getModelName() %></h2>

                <span class="tag"><%= m.getFuelType() %></span>
                <span class="tag"><%= m.getTransmission() %></span>

                <p class="meta-text">
                    ₹ <%= String.format("%,.0f", m.getPrice()) %> •
                    Engine: <%= m.getEngineCc() %> •
                    Year: <%= m.getReleaseYear() %>
                </p>

                <form action="<%=ctx%>/saveFavourite" method="post">
                    <input type="hidden" name="modelId" value="<%= m.getModelId() %>">
                    <input type="hidden" name="remove" value="true">
                    <button class="remove-btn">Remove</button>
                </form>

            </div>

        <% } %>

        </div>

    <% } %>

</div>

</div>

<script>
function clearAll() {
    if (confirm("Clear all favourites?")) {
        document.getElementById("clearForm").submit();
    }
}
</script>

</body>
</html>
