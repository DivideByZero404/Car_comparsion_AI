<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="carcompai.Model" %>

<%
    String ctx = request.getContextPath();
    List<Model> compareModels = (List<Model>) request.getAttribute("compareModels");
    if (compareModels == null) compareModels = new java.util.ArrayList<>();
    boolean empty = compareModels.isEmpty();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Compare Cars – CarCompAI</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

<style>
:root {
    --bg: #020617;
    --sidebar: #030918;
    --card-glass: rgba(255,255,255,0.03);
    --text: #f1f5f9;
    --text2: #9ca3af;
    --blue: #3b82f6;
}

body {
    margin: 0;
    font-family: "Inter", sans-serif;
    background: var(--bg);
    color: var(--text);
}
* { box-sizing: border-box; }

.navbar-fixed {
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 90px;
    display: flex;
    align-items: center;
    background: #000 !important;
    z-index: 9999;
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

.layout { display: flex; }

.sidebar {
    width: 300px;
    background: rgba(3, 9, 24, 0.7);
    backdrop-filter: blur(8px);
    padding: 140px 25px 40px;
    min-height: 100vh;
    position: fixed;
    top: 0;
    left: -250px;
    transition: left 0.3s ease;
    z-index: 1000;
}
.sidebar:hover {
    left: 0;
}
.sidebar h3 {
    color: var(--text2);
    font-size: 14px;
    margin-bottom: 10px;
    text-transform: uppercase;
}
.sidebar a {
    display: block;
    padding: 10px 0;
    color: var(--text);
    font-size: 15px;
    text-decoration: none;
    transition: .25s ease;
}
.sidebar a:hover { color: var(--blue); }
.sidebar .active { color: var(--blue); font-weight: 600; }

.main {
    margin-left: 50px;
    padding: 120px 50px 60px;
    width: calc(100% - 50px);
    display: flex;
    gap: 40px;
    align-items: flex-start;
}

.left-section { flex: 1.5; }

.left-section h1 {
    font-size: 38px;
    margin-bottom: 25px;
    font-weight: 900;
    transition: transform 0.3s ease;
}
.sidebar:hover ~ .main .left-section h1 {
    transform: translateX(250px);
}
.sidebar:hover ~ .main .left-section p {
    transform: translateX(250px);
    transition: transform 0.3s ease;
}

.compare-top {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
    gap: 30px;
    transition: transform 0.3s ease;
}
.sidebar:hover ~ .main .compare-top {
    transform: translateX(250px);
    grid-template-columns: repeat(1, 340px);
}

.compare-card {
    background: var(--card-glass);
    backdrop-filter: blur(12px);
    border-radius: 20px;
    padding: 22px;
    border: 1px solid rgba(255,255,255,0.06);
    box-shadow: 0 8px 22px rgba(0,0,0,0.60);
    transition: 0.3s;
}
.compare-card:hover { transform: translateY(-6px) scale(1.02); }

.compare-image {
    height: 220px;
    border-radius: 14px;
    overflow: hidden;
    margin-bottom: 14px;
}
.compare-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.badge {
    background: #ef4444;
    padding: 6px 12px;
    font-size: 13px;
    border-radius: 8px;
    display: inline-block;
    margin-bottom: 14px;
}

.spec {
    font-size: 14px;
    padding: 4px 0;
    color: var(--text2);
}
.spec b { color: var(--text); }

.remove-btn {
    margin-top: 18px;
    padding: 12px;
    background: #ef4444;
    border: none;
    border-radius: 12px;
    color: white;
    font-size: 15px;
    font-weight: 600;
    width: 100%;
    cursor: pointer;
    transition: .25s;
}
.remove-btn:hover { background: #dc2626; }

.ai-box {
    flex: 1.5;
    position: sticky;
    top: 120px;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(12px);
    padding: 25px;
    border-radius: 14px;
    border: 1px solid rgba(255,255,255,0.12);
    box-shadow: 0 8px 22px rgba(0,0,0,0.60);
    color: var(--text);
}

.ai-box textarea {
    width: 100%;
    background: #F1F2F4;
    color: #1e293b;
    border: 1px solid rgba(0,0,0,0.15);
    border-radius: 10px;
    padding: 12px;
    font-size: 15px;
}

.ai-box button {
    padding: 12px 18px;
    background: var(--blue);
    border: none;
    border-radius: 10px;
    color: white;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    margin-top: 15px;
}
.ai-box button:hover { background: #2563eb; }

.ai-response-box {
    background: #E5E7EB;
    color: #1e293b;
    padding: 14px;
    border-radius: 10px;
    border: 1px solid rgba(0,0,0,0.12);
    font-size: 15px;
    white-space: pre-wrap;
    height: 250px;
    overflow-y: auto;
    margin-top: 10px;
}
</style>
</head>

<body>

<div class="navbar-fixed">
    <%@ include file="navbar.jsp" %>
</div>

<div class="layout">

    <div class="sidebar">
        <h3>Dashboard</h3>
        <% 
            String lastFuel = (String) session.getAttribute("last_fuel_type");
            String lastTrans = (String) session.getAttribute("last_transmission");
            String lastPrice = (String) session.getAttribute("last_max_price");
            String lastSort = (String) session.getAttribute("last_sort_by");
            
            String searchUrl = ctx + "/search";
            if (lastFuel != null) {
                searchUrl += "?fuel_type=" + lastFuel + "&transmission=" + lastTrans + "&max_price=" + lastPrice + "&sort_by=" + lastSort;
            }
        %>
        <a href="<%= searchUrl %>">Back to Search</a>
        <a href="<%=ctx%>/favourites">Favourites</a>
        <a class="active" href="<%=ctx%>/compare">Compare</a>

        <h3>Quick Tools</h3>
        <a href="#" onclick="clearCompare(); return false;">🗑 Clear Compare</a>

        <form id="clearForm" action="<%=ctx%>/clearCompare" method="post" style="display:none;"></form>
    </div>

    <div class="main">

        <div class="left-section">
            <h1>Compare Cars</h1>

            <% if (empty) { %>
                <p style="color:var(--text2); font-size:18px;">
                    No cars added to comparison yet.
                </p>
            <% } else { %>

            <div class="compare-top">
            <%
                int i = 0;
                for (Model c : compareModels) {

                    // *** FIXED — NO COMMAS ***
                    String formattedPrice = String.valueOf((long)c.getPrice());
            %>

                <div class="compare-card">

                    <span class="badge">Car <%= (i + 1) %></span>

                    <div class="compare-image">
                        <img src="<%= c.getImageUrl() %>">
                    </div>

                    <h2><%= c.getBrandName() %> – <%= c.getModelName() %></h2>

                    <div class="spec"><b>₹ <%= formattedPrice %></b></div>
                    <div class="spec">Engine: <b><%= c.getEngineCc() %></b></div>
                    <div class="spec">Fuel: <b><%= c.getFuelType() %></b></div>
                    <div class="spec">Transmission: <b><%= c.getTransmission() %></b></div>
                    <div class="spec">Year: <b><%= c.getReleaseYear() %></b></div>

                    <form action="<%= ctx %>/removeCompare" method="post">
                        <input type="hidden" name="modelId" value="<%= c.getModelId() %>">
                        <button class="remove-btn">Remove</button>
                    </form>

                    <div style="display:flex; gap:12px; margin-top:15px;">

                        <button type="button"
                            class="ai-btn-detail"
                            data-brand="<%= c.getBrandName() %>"
                            data-model="<%= c.getModelName() %>"
                            data-engine="<%= c.getEngineCc() %>"
                            data-fuel="<%= c.getFuelType() %>"
                            data-trans="<%= c.getTransmission() %>"
                            data-year="<%= c.getReleaseYear() %>"
                            data-price="<%= formattedPrice %>"
                            onclick="askAboutCar(this)"
                            style="background:#1e293b;color:white;padding:10px 14px;border:none;border-radius:10px;font-size:14px;cursor:pointer;">
                            Ask AI About This Car
                        </button>

                        <button type="button"
                            class="ai-btn-similar"
                            data-brand="<%= c.getBrandName() %>"
                            data-model="<%= c.getModelName() %>"
                            data-engine="<%= c.getEngineCc() %>"
                            data-fuel="<%= c.getFuelType() %>"
                            data-trans="<%= c.getTransmission() %>"
                            data-year="<%= c.getReleaseYear() %>"
                            data-price="<%= formattedPrice %>"
                            onclick="suggestSimilar(this)"
                            style="background:#334155;color:white;padding:10px 14px;border:none;border-radius:10px;font-size:14px;cursor:pointer;">
                            Suggest Similar Cars
                        </button>

                    </div>

                </div>

            <%
                    i++;
                }
            %>
            </div>

            <% if (compareModels.size() > 1) { %>
                <div style="text-align: center; margin-top: 30px;">
                    <button onclick="compareBoth()" style="background: #3b82f6; color: white; padding: 15px 30px; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer;">Compare</button>
                </div>
            <% } %>

            <% } %>

        </div>

        <div class="ai-box">
            <h2>AI Car Advisor</h2>

            <textarea id="context" rows="4" placeholder="Car details..."></textarea><br><br>
            <textarea id="question" rows="3" placeholder="Your question..."></textarea>

            <button onclick="askAI()">Ask AI</button>

            <h3 style="margin-top:20px;">AI Response:</h3>
            <div id="answer" class="ai-response-box"></div>
        </div>

    </div>
</div>

<script>
function clearCompare() {
    if (confirm("Clear all compared cars?")) {
        document.getElementById("clearForm").submit();
    }
}

function askAboutCar(btn) {
    const d = btn.dataset;
    const ctx = "Car: " + d.brand + " " + d.model + " | Engine: " + d.engine + " | Fuel: " + d.fuel + " | Transmission: " + d.trans + " | Year: " + d.year + " | Price: ₹" + d.price;

    document.getElementById('context').value  = ctx;
    document.getElementById('question').value = 'Tell me about this car in detail.';

    askAI();
    document.querySelector('.ai-box').scrollIntoView({ behavior: 'smooth' });
}

function suggestSimilar(btn) {
    const d = btn.dataset;
    const ctx = "Car: " + d.brand + " " + d.model + " | Engine: " + d.engine + " | Fuel: " + d.fuel + " | Transmission: " + d.trans + " | Year: " + d.year + " | Price: ₹" + d.price;

    document.getElementById('context').value  = ctx;
    document.getElementById('question').value =
        'Suggest similar cars to this model and explain why they are good alternatives.';

    askAI();
    document.querySelector('.ai-box').scrollIntoView({ behavior: 'smooth' });
}

function compareBoth() {
    const cards = document.querySelectorAll('.ai-btn-detail');
    if (cards.length > 1) {
        let ctx = "";
        
        for (let i = 0; i < cards.length; i++) {
            const car = cards[i].dataset;
            ctx += "Car " + (i + 1) + ": " + car.brand + " " + car.model + " | Engine: " + car.engine + " | Fuel: " + car.fuel + " | Transmission: " + car.trans + " | Year: " + car.year + " | Price: ₹" + car.price;
            if (i < cards.length - 1) ctx += "\n\n";
        }
        
        document.getElementById('context').value = ctx;
        document.getElementById('question').value = 'Compare these cars in detail. Which one is better and why?';
        
        askAI();
        document.querySelector('.ai-box').scrollIntoView({ behavior: 'smooth' });
    }
}

function askAI() {
    let question = document.getElementById("question").value;
    let context  = document.getElementById("context").value;
    
    // Show loading spinner and clear previous response
    document.getElementById("answer").innerHTML = '<div style="display:flex;align-items:center;gap:10px;"><div style="width:20px;height:20px;border:3px solid #f3f3f3;border-top:3px solid #3498db;border-radius:50%;animation:spin 1s linear infinite;"></div>Loading AI response...</div><style>@keyframes spin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}</style>';

    fetch("<%=ctx%>/aiCompare", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "question=" + encodeURIComponent(question) +
              "&context=" + encodeURIComponent(context)
    })
    .then(res => res.json())
    .then(data => {
        if (data.answer) {
            document.getElementById("answer").innerText = data.answer;
        } else {
            document.getElementById("answer").innerText = 
                "AI Error: Invalid response → " + JSON.stringify(data);
        }
    })
    .catch(err => {
        document.getElementById("answer").innerText = "Fetch Error: " + err;
    });
}

</script>

</body>
</html>
