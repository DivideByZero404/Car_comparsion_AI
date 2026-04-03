<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

 


<style>
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 22px 50px;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        background: rgba(0,0,0,0.45);
        backdrop-filter: blur(6px);
        z-index: 1000;
    }

    .logo {
        font-size: 30px;
        font-weight: 800;
        color: white;
    }

    .nav-links {
        display: flex;
        gap: 35px;
        align-items: center;
    }

    .nav-links a {
        color: #e5e7eb;
        font-size: 17px;
        font-weight: 500;
        text-decoration: none;
        transition: 0.2s ease;
    }

    .nav-links a:hover {
        color: white;
    }

    .badge {
        background: red;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 12px;
        margin-left: 6px;
        color: white;
        font-weight: bold;
    }
</style>

<div class="navbar">
    <div class="logo">CarCompAI</div>

    <div class="nav-links">
        <% if (session.getAttribute("email") == null) { %>
            <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/index.jsp">Search</a>

        <a href="${pageContext.request.contextPath}/favourites">
            Favourites 
        </a>

        <a href="${pageContext.request.contextPath}/compare">Compare</a>
        
        <% if (session.getAttribute("email") != null) { %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        <% } %>

    </div>
</div>
