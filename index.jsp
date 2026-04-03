<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get search parameters from URL or session
    String savedFuelType = request.getParameter("fuel_type");
    String savedTransmission = request.getParameter("transmission");
    String savedMaxPrice = request.getParameter("max_price");
    String savedSortBy = request.getParameter("sort_by");
    
    // If not in URL, check session
    if (savedFuelType == null) savedFuelType = (String) session.getAttribute("last_fuel_type");
    if (savedTransmission == null) savedTransmission = (String) session.getAttribute("last_transmission");
    if (savedMaxPrice == null) savedMaxPrice = (String) session.getAttribute("last_max_price");
    if (savedSortBy == null) savedSortBy = (String) session.getAttribute("last_sort_by");
    
    // Set defaults if still null
    if (savedFuelType == null) savedFuelType = "Any";
    if (savedTransmission == null) savedTransmission = "Any";
    if (savedMaxPrice == null) savedMaxPrice = "1500000";
    if (savedSortBy == null) savedSortBy = "price_asc";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>CarCompAI – Cinematic Car Discovery</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

<style>
    body {
        margin: 0;
        font-family: 'Inter', sans-serif;
        color: white;
        overflow-x: hidden;
        background: black;
        height: 100vh;
        overflow: hidden;
    }

    /* CINEMATIC VIDEO */
    .video-bg {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        z-index: -2;
        filter: brightness(70%) contrast(115%) saturate(120%);
    }

    .top-gradient {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 180px;
        background: linear-gradient(to bottom, rgba(0,0,0,0.9), transparent);
        z-index: -1;
    }

    /* NAVBAR */
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 24px 60px;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 100;
        background: rgba(0,0,0,0.45);
        backdrop-filter: blur(6px);
        box-sizing: border-box;
    }

    .logo {
        font-size: 34px;
        font-weight: 800;
        letter-spacing: -1px;
        color: white;
    }

    .nav-links {
        display: flex;
        gap: 35px;
        white-space: nowrap;
        align-items: center;
    }

    .nav-links a {
        color: #e5e7eb;
        font-size: 17px;
        font-weight: 500;
        padding: 4px 6px;
        text-decoration: none;
        transition: 0.2s;
    }

    .nav-links a:hover { color: white; }

    /* HERO */
    .hero {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 170px 70px 0 70px;
        animation: fadeUp 1s ease-out;
    }

    .hero-text h1 {
        font-size: 64px;
        font-weight: 800;
        margin-bottom: 18px;
        line-height: 1.1;
        text-shadow: 0 3px 10px rgba(0,0,0,0.6);
    }

    .hero-text p {
        font-size: 18px;
        opacity: 0.95;
        line-height: 1.6;
        text-shadow: 0 2px 8px rgba(0,0,0,0.5);
    }

    /* FORM BOX */
    .form-box {
        width: 430px;
        padding: 40px;
        border-radius: 24px;
        background: rgba(255,255,255,0.08);
        backdrop-filter: blur(25px);
        border: 1px solid rgba(255,255,255,0.18);
        animation: floatUp 1.3s ease-out;
    }

    .form-box label {
        font-size: 15px;
        opacity: 0.9;
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
    }

    .form-box select {
        width: 100%;
        padding: 14px;
        border-radius: 12px;
        background: rgba(255,255,255,0.18);
        border: 1px solid rgba(255,255,255,0.25);
        color: white;
        margin-bottom: 26px;
        outline: none;
    }

    select option {
        background: rgba(50,50,50,0.9);
        color: white;
        padding: 10px;
    }

    /* Slider */
    .slider {
        width: 100%;
        margin-bottom: 10px;
    }

    .price-label {
        margin-top: 8px;
        margin-bottom: 24px;
        font-size: 18px;
        font-weight: 700;
    }

    .search-btn {
        width: 100%;
        padding: 16px;
        border-radius: 12px;
        background: #1d4ed8;
        border: none;
        color: white;
        font-size: 20px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.25s ease;
    }

    .search-btn:hover {
        background: #2b55ff;
        box-shadow: 0 0 20px rgba(29,78,216,0.5);
    }

    .footer {
        position: fixed;
        bottom: 18px;
        left: 0;
        width: 100%;
        text-align: center;
        color: #d1d5db;
        font-size: 14px;
        letter-spacing: 0.5px;
        text-shadow: 0 2px 8px rgba(0,0,0,0.5);
        animation: fadeIn 1.2s ease-out;
    }

    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    @keyframes floatUp { from { opacity: 0; transform: translateY(25px); } to { opacity: 1; transform: translateY(0); } }
</style>

</head>
<body>

    <%@ include file="navbar.jsp" %>

<video class="video-bg" autoplay loop muted playsinline>
    <source src="${pageContext.request.contextPath}/assets/video.mp4" type="video/mp4">
</video>

<div class="top-gradient"></div>

<div class="hero">
    <div class="hero-text">
        <h1>Find the car<br>that matches you.</h1>
        <p>Smart AI-powered discovery across fuel types, transmissions, budget & release year — helping you choose confidently.</p>
    </div>

    <div style="display: flex; flex-direction: column; align-items: center;">
        <% if (session.getAttribute("email") != null) { %>
            <% 
                String email = (String) session.getAttribute("email");
                String displayName = email.substring(0, email.indexOf("@"));
            %>
            <div style="text-align: center; color: black; font-weight: bold; margin-bottom: 20px; font-size: 24px;">Welcome, <%= displayName %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/search" method="POST">
            <div class="form-box">

            <label>Fuel Type</label>
            <select name="fuel_type">
                <option value="Any" <%= "Any".equals(savedFuelType) ? "selected" : "" %>>Any</option>
                <option <%= "Petrol".equals(savedFuelType) ? "selected" : "" %>>Petrol</option>
                <option <%= "Diesel".equals(savedFuelType) ? "selected" : "" %>>Diesel</option>
                <option <%= "Hybrid".equals(savedFuelType) ? "selected" : "" %>>Hybrid</option>
                <option <%= "Electric".equals(savedFuelType) ? "selected" : "" %>>Electric</option>
            </select>

            <label>Transmission</label>
            <select name="transmission">
                <option value="Any" <%= "Any".equals(savedTransmission) ? "selected" : "" %>>Any</option>
                <option <%= "Manual".equals(savedTransmission) ? "selected" : "" %>>Manual</option>
                <option <%= "Automatic".equals(savedTransmission) ? "selected" : "" %>>Automatic</option>
            </select>

            <label>Max Budget (₹)</label>
            <input type="range" min="100000" max="3000000" value="<%= savedMaxPrice %>"
                   name="max_price"
                   class="slider" id="priceRange"
                   oninput="priceValue.innerHTML = '₹ ' + Number(priceRange.value).toLocaleString()">
            <div id="priceValue" class="price-label">₹ <%= String.format("%,d", Integer.parseInt(savedMaxPrice)) %></div>

            <label>Sort By</label>
            <select name="sort_by">
                <option value="price_asc" <%= "price_asc".equals(savedSortBy) ? "selected" : "" %>>Low → High</option>
                <option value="price_desc" <%= "price_desc".equals(savedSortBy) ? "selected" : "" %>>High → Low</option>
                <option value="year_desc" <%= "year_desc".equals(savedSortBy) ? "selected" : "" %>>Newest First</option>
                <option value="year_asc" <%= "year_asc".equals(savedSortBy) ? "selected" : "" %>>Oldest First</option>
            </select>

            <button class="search-btn">Search</button>
        </div>
    </form>
    </div>
</div>

<div class="footer">
    © 2025 CarCompAI — Crafted for modern car buyers.
</div>

</body>
</html>
