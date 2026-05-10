# Telecom-Billing-and-Subscription-Managementt – 4th Semester

A full-stack database-driven telecom billing system built using Oracle 11g, Flask, and HTML/CSS/JS.
The project demonstrates real-world telecom operations including customer management, subscriptions, billing, and automated invoice generation using stored procedures and triggers.

🚀 Project Features

👤 Customer & Account Management

📦 Subscription Plan Handling

💳 Automated Billing System

⚙️ Oracle Stored Procedures & Triggers

📊 Monthly Invoice Generation

🔐 Secure Database Authentication

🌐 Flask-based Web Interface

🛠️ Tech Stack

Database: Oracle 11g Express Edition

Backend: Python (Flask)

Frontend: HTML, CSS, JavaScript

Database Connectivity: oracledb


# ⚙️ How to Run the Project Locally
1️⃣ Database Setup (Oracle 11g)

Make sure Oracle 11g is installed and running.

Create a new schema: (you can change these credentials with your choice)

Username: dbproject 

Password: 123

Run all provided .sql scripts in order to:
Create tables,
Insert sample data,
Add triggers,
Create stored procedures

✔ After this step, the database is fully ready to operate on ORACLE 11G.

2️⃣ Backend Setup (Flask API) - Optional

Install dependencies:

pip install flask cx_Oracle

Open the project folder:

telecom_project_deployed

Update database credentials in app.py: (if you have set credentials of your choice)

username = "dbproject"
password = "123"

Run the Flask server:

python app.py

Server will start at:

http://localhost:5000
3️⃣ Frontend Access

You can access the system in two ways:

🌐 Open browser and go to:

http://localhost:5000

OR

📄 Open start.html directly for login UI (basic access)


🔗 System Architecture

Frontend (HTML/CSS/JS) → Flask API → Oracle 11g Database
✔ All requests are processed through Flask, which communicates with Oracle DB in real-time.

📌 Important Notes
This project runs locally only due to Oracle 11g dependency.
Ensure Oracle Listener service is active before running backend.
Database credentials must match your local setup.
🎓 Academic Purpose

This project was developed as part of the Database Systems course (4th Semester) to demonstrate:

Relational database design
Normalization (up to 3NF)
SQL programming
Backend integration with database
Real-world billing system simulation
👨‍💻 Author

-Muhammad Talha

-Khizar Hayyat

BS Computer Science – FAST NUCES
