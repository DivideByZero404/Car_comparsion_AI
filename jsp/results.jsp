<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="carcompai.Model" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CarCompAI – Results Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-page: #171b24;
            --bg-panel: #1f2430;
            --bg-card: #151927;
            --chip-bg: #111827;
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --text-main: #f9fafb;
            --text-muted: #9ca3af;
            --border-subtle: #303646;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: var(--bg-page);
            color: var(--text-main);
            overflow-x: hidden;
        }

        /* ---------------- NAVBAR ---------------- */

        .navbar {
            position: fixed;
            top: 0;
            width: 100%;
            padding: 18px 70px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0,0,0,0.9);
            z-index: 50;
        }

        .logo {
            font-size: 30px;
            font-weight: 800;
            color: white;
        }

        .nav-links {
            display: flex;
            gap: 32px;
        }

        .nav-links a {
            color: #e5e7eb;
            font-size: 16px;
            text-decoration: none;
            transition: 0.2s;
        }

        .nav-links a:hover { color: white; }

        /* ---------------- LAYOUT ---------------- */

        .page-shell { padding-top: 90px; }

        .layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            min-height: calc(100vh - 90px);
        }

        /* ---------------- SIDEBAR ---------------- */

        .sidebar {
            background: var(--bg-panel);
            border-right: 1px solid var(--border-subtle);
            padding: 24px;
        }

        .side-block { margin-bottom: 32px; }

        .side-title {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .side-label {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 10px;
        }

        .side-chip {
            display: inline-block;
            padding: 6px 14px;
            background: var(--chip-bg);
            border-radius: 999px;
            font-size: 12px;
            border: 1px solid var(--border-subtle);
            margin-top: 4px;
        }

        .modify-link {
            display: inline-block;
            margin-top: 14px;
            font-size: 13px;
            color: var(--primary);
            text-decoration: none;
        }

        .modify-link:hover { text-decoration: underline; }

        /* Suggestions */

        .suggest-grid {
            display: grid;
            grid-template-columns: repeat(2,1fr);
            gap: 10px;
            margin-top: 12px;
        }

        .suggest-btn {
            border: 1px solid var(--border-subtle);
            border-radius: 16px;
            padding: 8px 10px;
            font-size: 11px;
            background: var(--chip-bg);
            color: var(--text-main);
            cursor: pointer;
            transition: .18s;
        }

        .suggest-btn:hover {
            background: #1e293b;
            border-color: var(--primary);
        }

        /* Workspace */

        .side-link {
            padding: 10px 12px;
            border-radius: 999px;
            font-size: 13px;
            margin-bottom: 6px;
            color: var(--text-muted);
        }

        .side-link.active {
            background: rgba(37,99,235,0.18);
            color: white;
        }

        /* ---------------- MAIN ---------------- */

        .main {
            padding: 30px 36px;
            background: linear-gradient(to bottom, #1b202b, #0f172a);
        }

        .main-title { font-size: 26px; font-weight: 700; }

        .main-sub { font-size: 14px; color: var(--text-muted); }

        .ai-card {
            background: var(--bg-card);
            border-radius: 18px;
            border: 1px solid var(--border-subtle);
            padding: 22px;
            margin: 25px 0;
            display: flex;
            justify-content: space-between;
        }

        .ai-label {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .ai-model { font-size: 18px; font-weight: 600; margin-top: 6px; }

        .ai-meta { font-size: 13px; color: var(--text-muted); margin-top: 6px; }

        .ai-badge {
            padding: 8px 14px;
            border-radius: 999px;
            background: var(--primary);
            color: white;
            font-size: 12px;
            height: fit-content;
        }

        /* ---------------- CAR GRID ---------------- */

        .grid {
            display: grid;
            gap: 26px;
            grid-template-columns: repeat(auto-fill, minmax(280px,1fr));
        }

        .car-card {
            background: var(--bg-card);
            border: 1px solid var(--border-subtle);
            border-radius: 22px;
            padding: 18px;
            box-shadow: 0 18px 40px rgba(0,0,0,0.45);
        }

        .car-img-wrap {
            height: 210px;
            background: #020617;
            border-radius: 18px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .car-img-wrap img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .car-title { font-size: 17px; font-weight: 600; margin-bottom: 6px; }

        .pill-row { display: flex; gap: 10px; margin-bottom: 10px; }

        .pill {
            border-radius: 999px;
            padding: 4px 10px;
            border: 1px solid var(--border-subtle);
            background: #020617;
            font-size: 11px;
            color: var(--text-muted);
        }

        .car-meta { font-size: 13px; color: var(--text-muted); }

        .car-footer {
            display: flex;
            gap: 14px;
            margin-top: 18px;
        }

        .btn-small {
            flex: 1;
            padding: 11px 0;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid var(--border-subtle);
        }

        .btn-small.secondary {
            background: transparent;
            color: var(--text-muted);
        }

        .btn-small.primary {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        /* Footer */
        .footer {
            padding: 14px 32px;
            font-size: 12px;
            color: var(--text-muted);
            background: #050816;
            border-top: 1px solid #111827;
            display: flex;
            justify-content: space-between;
        }

    </style>
</head>

<body>

<%
    List<Model> results = (List<Model>) request.getAttribute("results");
    boolean noData = (results == null || results.isEmpty());
    String contextPath = request.getContextPath();

    String fuelType = request.getParameter("fuel_type");
    String transmission = request.getParameter("transmission");
    String maxPrice = request.getParameter("max_price");
    String sortBy = request.getParameter("sort_by");

    if (fuelType == null || fuelType.isEmpty()) fuelType = "Any";
    if (transmission == null || transmission.isEmpty()) transmission = "Any";
    if (maxPrice == null || maxPrice.isEmpty()) maxPrice = "No limit";

    Model best = !noData ? results.get(0) : null;

    String sortLabel;
    if ("price_desc".equals(sortBy)) sortLabel = "Price – high to low";
    else if ("year_desc".equals(sortBy)) sortLabel = "Newest first";
    else if ("year_asc".equals(sortBy)) sortLabel = "Oldest first";
    else sortLabel = "Price – low to high";
%>

<!-- NAVBAR -->
<div class="navbar">
    <div class="logo">CarCompAI</div>
    <div class="nav-links">
        <a href="<%= contextPath %>/jsp/index.jsp">Overview</a>
        <a href="<%= contextPath %>/jsp/index.jsp">Search</a>
        <a href="#">Favourites</a>
        <a href="#">Compare</a>
    </div>
</div>

<div class="page-shell">
<div class="layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="side-block">
            <div class="side-title">Search Summary</div>

            <div class="side-label">Fuel</div>
            <span class="side-chip"><%= fuelType %></span>

            <div class="side-label">Transmission</div>
            <span class="side-chip"><%= transmission %></span>

            <div class="side-label">Budget</div>
            <span class="side-chip">₹ <%= maxPrice %></span>

            <div class="side-label">Sort</div>
            <span class="side-chip"><%= sortLabel %></span>

            <a href="<%= contextPath %>/jsp/index.jsp" class="modify-link">← Modify Search</a>
        </div>

        <div class="side-block">
            <div class="side-title">Smart Suggestions</div>

            <form action="<%= contextPath %>/search" method="get">
                <input type="hidden" name="fuel_type" value="<%= fuelType %>">
                <input type="hidden" name="transmission" value="<%= transmission %>">
                <input type="hidden" name="max_price" value="<%= maxPrice %>">
                <input type="hidden" name="sort_by" value="<%= sortBy %>">

                <div class="suggest-grid">
                    <button type="submit" name="suggestion" value="budget_under_10" class="suggest-btn">Under ₹10 Lakhs</button>
                    <button type="submit" name="suggestion" value="suv_only" class="suggest-btn">Only SUVs</button>
                    <button type="submit" name="suggestion" value="electric" class="suggest-btn">Electric / Hybrid</button>
                    <button type="submit" name="suggestion" value="latest" class="suggest-btn">Latest Models</button>
                    <button type="submit" name="suggestion" value="family" class="suggest-btn">7-Seater Family</button>
                    <button type="submit" name="suggestion" value="mileage" class="suggest-btn">Best Mileage</button>
                </div>
            </form>
        </div>

        <div class="side-block">
            <div class="side-title">Workspace</div>
            <div class="side-link active">Search Results</div>
            <div class="side-link muted">Saved Favourites (soon)</div>
            <div class="side-link muted">Compare List (soon)</div>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main">

        <div class="main-title">Search Results</div>
        <div class="main-sub"><%= noData ? "No models found." : results.size() + " models found" %></div>

        <% if (!noData) { %>
        <section class="ai-card">
            <div>
                <div class="ai-label">Recommended Pick</div>
                <div class="ai-model"><%= best.getBrandName() %> – <%= best.getModelName() %></div>
                <div class="ai-meta">
                    Price ₹<%= best.getPrice() %> ,
                    <%= best.getFuelType() %> ,
                    <%= best.getTransmission() %> ,
                    Launch Year <%= best.getReleaseYear() %>
                </div>
            </div>
            <span class="ai-badge">Top Match</span>
        </section>
        <% } %>

        <!-- CAR LIST GRID -->
        <section class="grid">
            <% for (Model m : results) { %>
            <article class="car-card">
                <div class="car-img-wrap">
                    <img src="<%= m.getImageUrl() %>" alt="<%= m.getModelName() %>">
                </div>

                <div class="car-title"><%= m.getBrandName() %> – <%= m.getModelName() %></div>

                <div class="pill-row">
                    <span class="pill"><%= m.getFuelType() %></span>
                    <span class="pill"><%= m.getTransmission() %></span>
                </div>

                <div class="car-meta">Price: ₹<%= m.getPrice() %></div>
                <div class="car-meta">Engine: <%= m.getEngineCc() %>cc</div>
                <div class="car-meta">Launch Year: <%= m.getReleaseYear() %></div>

                <div class="car-footer">
                    <form action="<%= contextPath %>/saveFavourite" method="post" style="flex:1;">
                        <input type="hidden" name="modelId" value="<%= m.getModelId() %>">
                        <button type="submit" class="btn-small secondary">Save</button>
                    </form>

                    <form action="<%= contextPath %>/saveCompare" method="post" style="flex:1;">
                        <input type="hidden" name="modelId" value="<%= m.getModelId() %>">
                        <button type="submit" class="btn-small primary">Add to Compare</button>
                    </form>
                </div>
            </article>
            <% } %>
        </section>

    </main>

</div>

<footer class="footer">
    <div>© 2025 CarCompAI</div>
    <div>Dashboard UI</div>
</footer>

</div>

</body>
</html>
