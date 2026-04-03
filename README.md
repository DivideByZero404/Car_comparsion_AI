# CarCompAI — AI-Powered Car Comparison & Discovery Platform

> A cinematic, full-stack web application that helps users discover, compare, and get AI-powered advice on cars — built with Java Servlets, JSP, and MySQL.



---

## Features

- **Smart Car Search** — Filter cars by fuel type, transmission, budget (slider), and sort order
- **AI Car Advisor** — Ask natural language questions about cars and get AI-generated recommendations
- **Side-by-Side Comparison** — Compare multiple car models across specs in a detailed layout
- **Favourites System** — Save and manage favourite cars tied to your user account
- **Recently Viewed** — Tracks and displays cars browsed in the current session
- **User Authentication** — Signup, login, and session management with email and username
- **Cinematic UI** — Dark theme with video background, glassmorphism form cards, and smooth animations
- **Responsive Navbar** — Persistent navigation with login state awareness

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | JSP, HTML, CSS, JavaScript |
| Backend | Java Servlets (Jakarta EE) |
| Database | MySQL |
| AI Integration | AI Advisor via REST API (`/aiCompare` servlet) |
| Styling | Custom CSS with glassmorphism and dark theme |
| Font | Inter (Google Fonts) |

---

## Project Structure

```
carcompai/
├── src/
│   └── main/
│       ├── java/carcompai/
│       │   ├── Model.java              # Car model entity
│       │   └── (Servlets)             # Search, Compare, Auth, AI, Favourites
│       └── webapp/
│           ├── index.jsp              # Landing page with search form
│           ├── results.jsp            # Search results grid
│           ├── compare.jsp            # Side-by-side car comparison
│           ├── compare_success.jsp    # Comparison success state
│           ├── ai-advisor.jsp         # AI car advisor interface
│           ├── favourites.jsp         # Saved favourites page
│           ├── recentlyViewed.jsp     # Recently viewed cars
│           ├── login.jsp              # Login page
│           ├── signup.jsp             # Signup page
│           ├── navbar.jsp             # Shared navbar component
│           └── assets/
│               └── video.mp4          # Hero background video
└── schema.sql                         # MySQL database schema
```

---

## Database Schema

```sql
-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User favourites table
CREATE TABLE user_favourites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    model_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_model (user_id, model_id)
);
```

---

## Getting Started

### Prerequisites

- Java JDK 17 or above
- Apache Tomcat 10+
- MySQL 8+
- Maven (optional, if using pom.xml)

### Setup

**1. Clone the repository**
```bash
git clone https://github.com/your-username/carcompai.git
cd carcompai
```

**2. Set up the database**
```bash
mysql -u root -p
```
```sql
CREATE DATABASE carcompai;
USE carcompai;
SOURCE schema.sql;
```

**3. Configure database connection**

Update your DB credentials in the servlet or `context.xml`:
```xml
<Resource name="jdbc/carcompai"
    url="jdbc:mysql://localhost:3306/carcompai"
    username="your_username"
    password="your_password" />
```

**4. Deploy to Tomcat**
- Build the project as a WAR file
- Drop it into Tomcat's `webapps/` directory
- Start Tomcat:
```bash
./bin/startup.sh
```

**5. Open in browser**
```
http://localhost:8080/carcompai
```

---

## Color Palette

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#020617` | Page background |
| Card Background | `#151f2f` | Result cards |
| Accent Blue | `#2563eb` | Buttons, highlights |
| Text Primary | `#f9fafb` | Headings, labels |
| Text Secondary | `#9ca3af` | Subtitles, meta info |

---

## Credits

Built by Sreenithi R  
Department of Computer Applictions

---

> This project was built for academic purposes.
