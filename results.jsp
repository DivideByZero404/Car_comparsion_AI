<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="carcompai.Model" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String ctx = request.getContextPath();

    List<Model> results = (List<Model>) request.getAttribute("results");
    boolean noData = (results == null || results.isEmpty());

    String fuelType = request.getParameter("fuel_type");
    String transmission = request.getParameter("transmission");
    String price = request.getParameter("max_price");
    String sort = request.getParameter("sort_by");
    String saved = request.getParameter("saved");

    if (fuelType == null) fuelType = "Any";
    if (transmission == null) transmission = "Any";
    if (price == null) price = "Not Selected";
    if (sort == null) sort = "price_asc";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CarCompAI – Results</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

<style>

/* =========================================================
   COLORS
   ========================================================= */
:root {
    --bg-dark: #020617;
    --bg-sidebar: #030918;
    --card-bg: #151f2f;
    --border: #283345;
    --pill: #0f172a;
    --text-main: #f9fafb;
    --text-muted: #9ca3af;
    --blue: #2563eb;
    --glow: rgba(37, 99, 235, 0.1);
}

/* =========================================================
   GLOBAL
   ========================================================= */
body {
    margin: 0;
    padding: 0;
    background: var(--bg-dark);
    font-family: 'Inter', sans-serif;
    color: var(--text-main);
}

* { box-sizing: border-box; }

/* BLACK NAVBAR */
.navbar-fixed {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 2000;
    background: #000 !important;
    height: 80px;
    border-bottom: 1px solid rgba(255,255,255,0.06);
}

/* =========================================================
   SIDEBAR (UPGRADED)
   ========================================================= */
.sidebar {
    position: fixed;
    top: 80px;
    left: 0;
    width: 295px;
    height: calc(100vh - 80px);
    background: var(--bg-sidebar);
    padding: 28px 26px;
    border-right: 1px solid rgba(255,255,255,0.05);
    overflow-y: auto;
}

.sidebar::-webkit-scrollbar { display: none; }

.sidebar-title {
    font-size: 21px;
    font-weight: 700;
    margin-bottom: 4px;
}

.sidebar-sub {
    font-size: 14px;
    color: var(--text-muted);
    margin-bottom: 22px;
}

.filter-label {
    font-size: 11px;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: var(--text-muted);
    margin-bottom: 6px;
}

/* SMALLER FILTER PILLS */
.filter-pill {
    padding: 6px 12px;
    background: #0f172a;
    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 999px;
    font-size: 12px;
    display: inline-flex;
    margin-bottom: 12px;
}

.modify-link {
    color: #60a5fa;
    margin-top: 8px;
    display: block;
    font-size: 14px;
}

/* Smart Suggestions */
.suggestion-title {
    margin-top: 30px;
    margin-bottom: 6px;
    font-size: 17px;
    font-weight: 600;
}

.sidebar-hint {
    color: var(--text-muted);
    font-size: 13px;
    margin-bottom: 16px;
}

.suggestion-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 14px;
}

.pill-btn {
    padding: 12px 12px;
    border-radius: 10px;
    background: linear-gradient(145deg, #0e1626, #0a101c);
    border: 1px solid rgba(255,255,255,0.05);
    color: #dbe5f5;
    box-shadow: 0 4px 10px rgba(0,0,0,0.35);
    cursor: pointer;
    transition: .25s;
}

.pill-btn:hover {
    background: #1d4ed8;
    border-color: #3b82f6;
    color: white;
}

/* =========================================================
   MAIN CONTENT
   ========================================================= */
.main {
    margin-left: 295px;
    padding: 110px 42px 42px;
}

.main h1 {
    margin: 0;
    font-size: 32px;
    font-weight: 700;
}

.sub-text {
    color: var(--text-muted);
    font-size: 14px;
}

.recommended {
    background: #111827;
    padding: 14px 18px;
    border: 1px solid #1e2535;
    border-radius: 14px;
    margin: 16px 0 20px;
}

/* =========================================================
   CAR GRID
   ========================================================= */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(265px, 1fr));
    gap: 28px;
}

.car-card {
    background: var(--card-bg);
    padding: 18px;
    border-radius: 18px;
    border: 1px solid #1e2535;
    transition: .25s ease;
    box-shadow: 0 4px 18px rgba(0,0,0,0.4);
}

.car-card:hover { transform: translateY(-4px); }

/* image */
.image-box {
    height: 170px;
    border-radius: 14px;
    overflow: hidden;
    margin-bottom: 14px;
    position: relative;
}

.image-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* overlay */
.view-overlay {
    position: absolute;
    inset: 0;
    background: rgba(15, 23, 42, 0.55);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    color: #f8fafc;
    font-size: 15px;
    font-weight: 600;
    transition: .3s ease;
}

.image-box:hover .view-overlay { opacity: 1; }

.tag {
    padding: 4px 10px;
    background: #1e293b;
    border-radius: 999px;
    font-size: 12px;
    color: #cbd5e1;
    margin-right: 6px;
}

/* footer buttons */
.footer-row {
    margin-top: 14px;
    display: flex;
    justify-content: space-between;
}

.save-btn {
    padding: 8px 16px;
    border-radius: 10px;
    background: #1e293b;
    color: #e2e8f0;
    border: 1px solid #334155;
}

.save-btn:hover { background: #334155; }

/* ⭐ FIXED: Correct Compare Path */
.compare-btn {
    padding: 8px 16px;
    background: var(--blue);
    border-radius: 10px;
    color: white;
    border: none;
}

.compare-btn:hover { filter: brightness(1.08); }

/* =============================
   Toast (Save Confirmation)
   ============================= */
.toast {
    position: fixed;
    right: 25px;
    bottom: 25px;
    background: #0d1117;
    padding: 12px 18px;
    border-radius: 10px;
    color: #a7f3d0;
    font-weight: 500;
    font-size: 14px;
    border: 1px solid #1f2937;
    box-shadow: 0 4px 14px rgba(0,0,0,0.5);
    opacity: 0;
    transform: translateY(20px);
    transition: .4s ease;
}

.toast.show {
    opacity: 1;
    transform: translateY(0);
}

</style>
</head>

<body>

<div class="navbar-fixed">
    <%@ include file="navbar.jsp" %>
</div>

<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-title">Filters & Insights</div>
        <div class="sidebar-sub">Your chosen preferences</div>

        <div class="filter-label">Fuel Type</div>
        <div class="filter-pill"><%= fuelType %></div>

        <div class="filter-label">Transmission</div>
        <div class="filter-pill"><%= transmission %></div>

        <div class="filter-label">Budget</div>
        <div class="filter-pill"><%= price %></div>

        <div class="filter-label">Sort By</div>
        <div class="filter-pill"><%= sort %></div>

        <a href="<%= ctx %>/index.jsp?fuel_type=<%= fuelType %>&transmission=<%= transmission %>&max_price=<%= price %>&sort_by=<%= sort %>" class="modify-link">Modify search</a>

        <div class="suggestion-title">Smart Suggestions</div>
        <div class="sidebar-hint">Quick explore categories</div>

        <form action="<%= ctx %>/search" method="POST">
            <div class="suggestion-grid">
                <button class="pill-btn" name="suggestion" value="budget_under_10">Under 10 Lakhs</button>
                <button class="pill-btn" name="suggestion" value="suv">SUV</button>
                <button class="pill-btn" name="suggestion" value="electric">Electric</button>
                <button class="pill-btn" name="suggestion" value="latest">Latest</button>
                <button class="pill-btn" name="suggestion" value="family">Family</button>
                <button class="pill-btn" name="suggestion" value="mileage">Mileage</button>
            </div>
        </form>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main">
        <h1>Search Results</h1>
        <p class="sub-text"><%= results != null ? results.size() : 0 %> models found</p>

        <% if (!noData) { %>
        <div class="recommended">
            <h2>RECOMMENDED PICK</h2>
            <p><b><%= results.get(0).getBrandName() %> – <%= results.get(0).getModelName() %></b></p>
        </div>
        <% } %>

        <div class="grid">

        <% if (!noData) {
            for (Model m : results) { %>

            <div class="car-card">

                <div class="image-box">
                    <a href="<%= m.getOfficialUrl() %>" target="_blank">
                        <img src="<%= m.getImageUrl() %>" alt="car">
                        <div class="view-overlay">View Car →</div>
                    </a>
                </div>

                <h3><%= m.getBrandName() %> – <%= m.getModelName() %></h3>

                <div class="tags">
                    <span class="tag"><%= m.getFuelType() %></span>
                    <span class="tag"><%= m.getTransmission() %></span>
                </div>

                <p class="sub-text">
                    Price: ₹<%= String.format("%,.0f", m.getPrice()) %><br>
                    Engine: <%= m.getEngineCc() %><br>
                    Launch Year: <%= m.getReleaseYear() %>
                </p>

                <div class="footer-row">

                    <!-- SAVE TO FAV -->
                    <% if (session.getAttribute("email") != null) { %>
                        <form action="<%= ctx %>/addFavourite" method="post">
                            <input type="hidden" name="modelId" value="<%= m.getModelId() %>">
                            <button class="save-btn" type="submit">Save</button>
                        </form>
                    <% } else { %>
                        <button class="save-btn" onclick="if(confirm('Login to add favourites. Go to Login page?')) window.location.href='<%= ctx %>/login.jsp'">Save</button>
                    <% } %>

                    <!-- ⭐ FIXED: CORRECT COMPARE URL -->
                    <form action="<%= ctx %>/addToCompare" method="post">
                        <input type="hidden" name="modelId" value="<%= m.getModelId() %>">
                        <button class="compare-btn">Add to Compare</button>
                    </form>

                </div>

            </div>

        <% }} else { %>
            <p>No cars found.</p>
        <% } %>

        </div>

    </main>

</div>

<!-- TOAST -->
<div id="toast" class="toast">✓ Saved to favourites</div>

<script>
    <% if ("true".equals(saved)) { %>
        let t = document.getElementById("toast");
        setTimeout(() => t.classList.add("show"), 200);
        setTimeout(() => t.classList.remove("show"), 3000);
    <% } %>


</script>

</body>
</html>
