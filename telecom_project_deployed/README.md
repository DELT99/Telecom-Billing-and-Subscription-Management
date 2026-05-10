# Telecom Billing & Subscription Management System

A Flask-based frontend for a telecom billing and subscription management system connected to an Oracle database.

## Overview

This project provides a web interface for:
- Customer management
- Billing and invoices
- Payments tracking
- Complaint handling
- Dashboard statistics

The frontend is implemented using Flask and connects to Oracle via the `oracledb` driver.

## Prerequisites

- Python 3.8 or higher
- Oracle Database 11g XE or a compatible Oracle database
- Oracle Instant Client (optional but recommended for thick mode)
- Windows, Linux, or macOS

## Required Python Packages

`telecom_project_deployed/requirements.txt` includes:
- `Flask==2.3.3`
- `oracledb==1.4.2`

Install dependencies with:

```bash
pip install -r requirements.txt
```

## Oracle Configuration

This app connects to Oracle using a database user named `dbproject` with password `123`.

Default Oracle connection settings:
- Host: `localhost`
- Port: `1521`
- Service name: `XE`

### Optional: Oracle Instant Client

The project uses Oracle Instant Client if installed at:

`C:\instantclient_23_0`

If Instant Client is not available, the app will fall back to thin mode.

## Database Setup

1. Start Oracle Database and verify the listener is running.
2. Create the `dbproject` schema/user with password `123`.
3. Grant required privileges to `dbproject`.
4. Run the SQL scripts from the repository in order:
   - `01_create_tables.sql`
   - `02_constraints.sql`
   - `03_sequences.sql`
   - `04_indexes.sql`
   - `05_insert_data.sql`

If you need complaints support, also run:
- `create_complaints.sql`

> Note: The application will also create an `admin_users` table automatically on first startup if it does not exist.

## Running the Application

From the `telecom_project_deployed` folder, run:

```bash
python app.py
```

Then open your browser at:

```text
http://localhost:5000
```

## Default Login

- Username: `admin`
- Password: `admin`

## Project Files

- `app.py` – Flask application routes and views
- `db.py` – Oracle connection and database helper functions
- `requirements.txt` – Python dependencies
- `templates/` – HTML templates for pages
- `static/` – CSS and JavaScript assets

## Important Notes

- The app uses parameterized queries to reduce SQL injection risk.
- The `db.py` file connects to Oracle with:
  - `user="dbproject"`
  - `password="123"`
  - `host="localhost"`
  - `port=1521`
  - `service_name="XE"`

If your environment differs, update `db.py` accordingly.

## Troubleshooting

### Database connection failed
- Confirm Oracle is running.
- Confirm the listener is active.
- Verify `dbproject` credentials.
- If using Instant Client, confirm it is installed at `C:\instantclient_23_0`.

### Python import errors
- Run `pip install -r requirements.txt`
- Make sure the correct Python interpreter is active.

### App not reachable
- Confirm the app started successfully.
- Check for port conflicts on `5000`.
- If needed, change the port in `app.py`.

## Customization

- Update Oracle connection settings in `db.py` for your own host, port, service name, username, and password.
- Add new pages by adding routes in `app.py` and templates in `templates/`.
- Customize styling in `static/css/style.css`.

- Font Awesome icons for UI elements

### JavaScript
- Main functionality in `static/js/main.js`
- Form validation and user interactions
- Table filtering and search

## Production Deployment

### Security Considerations
- Change default login credentials
- Use environment variables for database credentials
- Enable HTTPS in production
- Implement proper session management

### Performance Optimization
- Database connection pooling
- Caching for static assets
- Database indexing for large datasets

## Support

For issues or questions:
1. Check the troubleshooting section
2. Verify all prerequisites are met
3. Review error logs in console
4. Ensure database is properly configured

## License

This project is developed for educational purposes as part of the Telecom Billing & Subscription Management System coursework.