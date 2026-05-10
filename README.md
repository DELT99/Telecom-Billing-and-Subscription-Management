# Telecom-Billing-and-Subscription-Management
Database Systems Project - 4rth Semester


🚀 How to Run Locally
Note: Because this system relies on a local Oracle database, the frontend cannot be hosted purely on GitHub. You must run the backend locally.

Set up the Database:
Ensure Oracle 11g is installed and running on your machine.

Run the provided .sql scripts to generate the tables, triggers, and stored procedures.

Start the API:
Ensure Python and Flask are installed.

Update the database connection credentials inside app.py. (I set the schema owner dbproject/123)

Run python app.py in your terminal. The server will start on http://localhost:5000
.
The UI will now successfully communicate with your local Oracle Database
