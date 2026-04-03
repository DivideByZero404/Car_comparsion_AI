<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Login – CarCompAI</title>

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

    .navbar {
        z-index: 10000 !important;
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        width: 100% !important;
    }

    /* HERO */
    .hero {
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 120px 70px 0 70px;
        animation: fadeUp 1s ease-out;
        min-height: calc(100vh - 120px);
    }

    /* FORM BOX */
    .form-box {
        width: 430px;
        padding: 40px;
        border-radius: 24px;
        background: rgba(255,255,255,0.04);
        backdrop-filter: blur(8px);
        border: 1px solid rgba(255,255,255,0.12);
        animation: floatUp 1.3s ease-out;
        z-index: 1;
        position: relative;
    }

    .form-title {
        font-size: 32px;
        font-weight: 800;
        margin-bottom: 30px;
        text-align: center;
        text-shadow: 0 3px 10px rgba(0,0,0,0.6);
    }

    .form-box label {
        font-size: 15px;
        opacity: 0.9;
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
    }

    .form-box input {
        width: 100%;
        padding: 14px;
        border-radius: 12px;
        background: rgba(255,255,255,0.18);
        border: 1px solid rgba(255,255,255,0.25);
        color: white;
        margin-bottom: 26px;
        outline: none;
        box-sizing: border-box;
        font-size: 16px;
    }

    .form-box input::placeholder {
        color: rgba(255,255,255,0.6);
    }

    .password-container {
        position: relative;
        margin-bottom: 26px;
    }

    .password-container input {
        margin-bottom: 0;
        padding-right: 50px;
    }

    .eye-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        cursor: pointer;
        user-select: none;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .eye-icon svg {
        width: 20px;
        height: 20px;
        stroke: rgba(255,255,255,0.7);
        fill: none;
        stroke-width: 2;
        transition: stroke 0.2s ease;
    }

    .eye-icon:hover svg {
        stroke: white;
    }

    .submit-btn {
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
        margin-bottom: 20px;
    }

    .submit-btn:hover {
        background: #2b55ff;
        box-shadow: 0 0 20px rgba(29,78,216,0.5);
    }

    .form-link {
        text-align: center;
        font-size: 15px;
        opacity: 0.9;
    }

    .form-link a {
        color: #3b82f6;
        text-decoration: none;
        font-weight: 600;
    }

    .form-link a:hover {
        color: #60a5fa;
        text-decoration: underline;
    }

    .hidden {
        display: none;
    }

    .password-strength {
        margin-top: -20px;
        margin-bottom: 20px;
    }

    .strength-bar {
        height: 6px;
        border-radius: 3px;
        background: rgba(255,255,255,0.2);
        margin-bottom: 8px;
        transition: all 0.3s ease;
    }

    .strength-bar.too-weak {
        background: #ef4444;
        width: 25%;
    }

    .strength-bar.weak {
        background: #f59e0b;
        width: 50%;
    }

    .strength-bar.strong {
        background: #10b981;
        width: 100%;
    }

    .strength-text {
        font-size: 13px;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .strength-text.too-weak {
        color: #ef4444;
    }

    .strength-text.weak {
        color: #f59e0b;
    }

    .strength-text.strong {
        color: #10b981;
    }

    #signupForm {
        margin-top: -50px;
    }



    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    @keyframes floatUp { from { opacity: 0; transform: translateY(25px); } to { opacity: 1; transform: translateY(0); } }
</style>

</head>
<body>

    <%@ include file="navbar.jsp" %>
    <style>
        .navbar {
            z-index: 99999 !important;
            width: 100% !important;
            padding: 22px 30px !important;
            box-sizing: border-box !important;
        }
        .nav-links {
            white-space: nowrap !important;
            overflow: visible !important;
        }
    </style>

<video class="video-bg" autoplay loop muted playsinline>
    <source src="${pageContext.request.contextPath}/assets/video.mp4" type="video/mp4">
</video>

<div class="top-gradient"></div>

<div class="hero">
    <!-- LOGIN FORM -->
    <div id="loginForm" class="form-box">
        <h1 class="form-title">Login</h1>
        
        <form action="${pageContext.request.contextPath}/login" method="POST">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>

            <label>Password</label>
            <div class="password-container">
                <input type="password" id="loginPassword" name="password" placeholder="Enter your password" required>
                <span class="eye-icon" onclick="togglePassword('loginPassword', this)">
                    <svg viewBox="0 0 24 24">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                </span>
            </div>

            <button type="submit" class="submit-btn">Login</button>
        </form>

        <div class="form-link">
            Don't have an account? <a href="#" onclick="showSignup()">Sign Up</a>
        </div>
    </div>

    <!-- SIGNUP FORM -->
    <div id="signupForm" class="form-box hidden">
        <h1 class="form-title">Sign Up</h1>
        
        <% if (request.getAttribute("success") != null) { %>
            <div style="color: #10b981; font-weight: bold; text-align: center; margin-bottom: 20px; padding: 12px; background: rgba(16, 185, 129, 0.1); border-radius: 8px; border: 1px solid rgba(16, 185, 129, 0.3);"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/signup" method="POST">
            <label>Username</label>
            <input type="text" name="username" placeholder="Choose a username" required>
            
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>

            <label>Password</label>
            <div class="password-container">
                <input type="password" id="signupPassword" name="password" placeholder="Create a password" required oninput="checkPasswordStrength()">
                <span class="eye-icon" onclick="togglePassword('signupPassword', this)">
                    <svg viewBox="0 0 24 24">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                </span>
            </div>
            <div class="password-strength">
                <div class="strength-bar" id="strengthBar"></div>
                <div class="strength-text" id="strengthText"></div>
            </div>

            <label>Confirm Password</label>
            <div class="password-container">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                <span class="eye-icon" onclick="togglePassword('confirmPassword', this)">
                    <svg viewBox="0 0 24 24">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                </span>
            </div>

            <button type="submit" class="submit-btn">Sign Up</button>
        </form>

        <div class="form-link">
            Already have an account? <a href="#" onclick="showLogin()">Login</a>
        </div>
    </div>
</div>

<script>
function togglePassword(inputId, eyeIcon) {
    const input = document.getElementById(inputId);
    if (input.type === 'password') {
        input.type = 'text';
        // Open eye icon
        eyeIcon.innerHTML = `
            <svg viewBox="0 0 24 24">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
            </svg>
        `;
    } else {
        input.type = 'password';
        // Closed eye icon with slash
        eyeIcon.innerHTML = `
            <svg viewBox="0 0 24 24">
                <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
            </svg>
        `;
    }
}

function showSignup() {
    document.getElementById('loginForm').classList.add('hidden');
    document.getElementById('signupForm').classList.remove('hidden');
}

function showLogin() {
    document.getElementById('signupForm').classList.add('hidden');
    document.getElementById('loginForm').classList.remove('hidden');
}

function checkPasswordStrength() {
    const password = document.getElementById('signupPassword').value;
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    
    let score = 0;
    
    if (password.length >= 8) score++;
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[0-9]/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;
    
    strengthBar.className = 'strength-bar';
    strengthText.className = 'strength-text';
    
    if (password.length === 0) {
        strengthBar.className = 'strength-bar';
        strengthText.textContent = '';
        strengthText.className = 'strength-text';
    } else if (score <= 2) {
        strengthBar.classList.add('too-weak');
        strengthText.classList.add('too-weak');
        strengthText.textContent = 'Too Weak';
    } else if (score <= 3) {
        strengthBar.classList.add('weak');
        strengthText.classList.add('weak');
        strengthText.textContent = 'Weak';
    } else {
        strengthBar.classList.add('strong');
        strengthText.classList.add('strong');
        strengthText.textContent = 'Strong';
    }
}

</script>

</body>
</html>