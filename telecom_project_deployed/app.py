from flask import Flask, render_template, request, redirect, url_for, flash, session
import db
import os
from datetime import datetime, date, timedelta

app = Flask(__name__)
app.secret_key = os.urandom(24)

# --- Jinja helpers ---
@app.template_filter("strftime")
def jinja_strftime(value, fmt="%Y-%m-%d"):
    """
    Allows templates to format datetimes via: {{ some_value|strftime('%Y-%m-%d') }}
    Special-case: {{ 'now'|strftime(...) }} formats the current local time.
    """
    if value is None:
        return ""
    if value == "now":
        return datetime.now().strftime(fmt)
    if isinstance(value, (datetime, date)):
        return value.strftime(fmt)
    # Best-effort fallback: just stringify unknown inputs
    return str(value)

# Initialize the database (creates missing tables if needed)
with app.app_context():
    print("\n" + "="*60)
    print("INITIALIZING APPLICATION")
    print("="*60)
    db.init_db()
    print("-"*60)
    print("Testing database connection...")
    if db.test_connection():
        print("✓ Application initialized successfully")
    else:
        print("✗ WARNING: Database connection test failed")
        print("  Reports may not work until the database is accessible")
    print("="*60 + "\n")

@app.route('/')
def index():
    if 'logged_in' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        # Simple authentication based on our db.init_db setup
        conn = db.get_connection()
        if not conn:
            flash('Database connection failed. Please try again later.', 'error')
            return redirect(url_for('login'))
            
        cursor = None
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM admin_users WHERE username = :1 AND password_hash = :2", (username, password))
            user = cursor.fetchone()
            if user:
                session['logged_in'] = True
                session['username'] = username
                flash('Login successful!', 'success')
                return redirect(url_for('dashboard'))
            else:
                flash('Invalid credentials!', 'error')
        except Exception as e:
            flash(f'Login error: {str(e)}', 'error')
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

# --- Dashboard ---
@app.route('/dashboard')
def dashboard():
    if 'logged_in' not in session:
        return redirect(url_for('login'))
        
    stats = db.get_dashboard_stats()
    return render_template('dashboard.html', stats=stats)

# --- Customers ---
@app.route('/customers')
def customers():
    if 'logged_in' not in session: return redirect(url_for('login'))
    all_customers = db.get_all_customers()
    return render_template('customers.html', customers=all_customers)

@app.route('/subscriptions')
def subscriptions():
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    customers = db.get_all_customers()
    plans = db.get_all_plans(active_only=True)
    active_subs = db.get_active_subscriptions()
    return render_template('subscriptions.html', customers=customers, plans=plans, subscriptions=active_subs)

@app.route('/subscriptions/subscribe', methods=['POST'])
def subscribe_plan():
    if 'logged_in' not in session:
        return redirect(url_for('login'))

    customer_id = request.form.get('customer_id')
    plan_id = request.form.get('plan_id')
    start_date = request.form.get('start_date') or None
    fee_paid = request.form.get('subscription_fee_paid') or None
    gen_invoice = request.form.get('generate_invoice') == 'on'

    if not customer_id or not plan_id:
        flash("Please select both customer and plan.", "danger")
        return redirect(url_for('subscriptions'))

    success, msg, _invoice_id = db.subscribe_customer_to_plan(
        int(customer_id),
        int(plan_id),
        start_date_s=start_date,
        subscription_fee_paid=fee_paid,
        generate_invoice=gen_invoice,
    )
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('subscriptions'))

@app.route('/customers/add', methods=['POST'])
def add_customer():
    if 'logged_in' not in session: return redirect(url_for('login'))
    
    data = {
        'cnic': request.form['cnic'],
        'first_name': request.form['first_name'],
        'last_name': request.form['last_name'],
        'date_of_birth': request.form['date_of_birth'],
        'gender': request.form['gender'],
        'phone_number': request.form['phone_number'],
        'email': request.form.get('email', ''),
        'city': request.form['city'],
        'address': request.form.get('address', ''),
        'customer_type': request.form['customer_type']
    }
    success, msg = db.add_customer(data)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('customers'))

@app.route('/customers/delete/<int:id>', methods=['POST'])
def delete_customer(id):
    if 'logged_in' not in session: return redirect(url_for('login'))
    success, msg = db.delete_customer(id)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('customers'))

# --- Billing ---
@app.route('/billing')
def billing():
    if 'logged_in' not in session: return redirect(url_for('login'))
    invoices = db.get_all_invoices()
    customers = db.get_customers_for_billing()
    return render_template('billing.html', invoices=invoices, customers=customers)

@app.route('/billing/generate', methods=['POST'])
def generate_bill():
    if 'logged_in' not in session: return redirect(url_for('login'))

    # Validate and normalize billing dates to avoid Oracle constraint failures (e.g. CK_INVOICE_DUE).
    try:
        period_start_s = request.form['period_start']
        period_end_s = request.form['period_end']
        due_date_s = request.form.get('due_date') or ""

        period_start = datetime.strptime(period_start_s, "%Y-%m-%d").date()
        period_end = datetime.strptime(period_end_s, "%Y-%m-%d").date()
        due_date = datetime.strptime(due_date_s, "%Y-%m-%d").date() if due_date_s else None

        if period_end <= period_start:
            flash("Billing period end date must be strictly after the start date.", "danger")
            return redirect(url_for('billing'))

        # Enforce a safe, business-reasonable due date:
        # - If not provided, set to period_end + 10 days
        # - Must not be before period_end
        # - Must be at least tomorrow to satisfy Oracle CK_INVOICE_DUE (due_date >= SYSDATE)
        today = date.today()
        recommended_due = period_end + timedelta(days=10)
        
        # Ensure it's at least tomorrow to safely pass SYSDATE check
        min_safe_due_date = today + timedelta(days=1)
        
        if due_date is None:
            due_date = max(recommended_due, min_safe_due_date)
        elif due_date < period_end or due_date < min_safe_due_date:
            due_date = max(recommended_due, min_safe_due_date)
            flash(f"Due date was adjusted to {due_date} to satisfy invoice rules (must be strictly after today and after billing period end).", "warning")

        data = {
            'customer_id': request.form['customer_id'],
            'period_start': period_start.strftime("%Y-%m-%d"),
            'period_end': period_end.strftime("%Y-%m-%d"),
            'due_date': due_date.strftime("%Y-%m-%d"),
            'usage_charges': request.form['usage_charges'],
            'rental_charges': request.form['rental_charges'],
            'tax_amount': request.form['tax_amount'],
            'total_amount': request.form['total_amount']
        }
    except Exception:
        flash("Invalid billing dates. Please re-check the period and due date.", "danger")
        return redirect(url_for('billing'))

    success, msg = db.generate_invoice(data)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('billing'))

@app.route('/billing/update_status/<int:id>', methods=['POST'])
def update_bill_status(id):
    if 'logged_in' not in session: return redirect(url_for('login'))
    status = request.form['status']
    success, msg = db.update_invoice_status(id, status)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('billing'))

# --- Payments ---
@app.route('/payments')
def payments():
    if 'logged_in' not in session: return redirect(url_for('login'))
    payments = db.get_all_payments()
    invoices = db.get_all_invoices()
    return render_template('payments.html', payments=payments, invoices=invoices)

@app.route('/payments/add', methods=['POST'])
def add_payment():
    if 'logged_in' not in session: return redirect(url_for('login'))
    data = {
        'invoice_id': request.form['invoice_id'],
        'amount_paid': request.form['amount_paid'],
        'payment_method': request.form['payment_method'],
        'transaction_reference': request.form.get('transaction_reference', '')
    }
    success, msg = db.add_payment(data)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('payments'))

# --- Complaints ---
@app.route('/complaints')
def complaints():
    if 'logged_in' not in session: return redirect(url_for('login'))
    complaints = db.get_all_complaints()
    customers = db.get_all_customers()
    return render_template('complaints.html', complaints=complaints, customers=customers)

@app.route('/complaints/add', methods=['POST'])
def add_complaint():
    if 'logged_in' not in session: return redirect(url_for('login'))
    data = {
        'customer_id': request.form['customer_id'],
        'description': request.form['description'],
        'complaint_type': request.form.get('complaint_type', 'OTHER'),
        'priority': request.form.get('priority', 'MEDIUM')
    }
    success, msg = db.add_complaint(data)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('complaints'))

@app.route('/complaints/resolve/<int:id>', methods=['POST'])
def resolve_complaint(id):
    if 'logged_in' not in session: return redirect(url_for('login'))
    resolution = request.form['resolution']
    success, msg = db.resolve_complaint(id, resolution)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('complaints'))

@app.route('/complaints/reject/<int:id>', methods=['POST'])
def reject_complaint(id):
    if 'logged_in' not in session: return redirect(url_for('login'))
    reason = request.form['reason']
    success, msg = db.reject_complaint(id, reason)
    flash(msg, 'success' if success else 'danger')
    return redirect(url_for('complaints'))

# --- Reports ---
@app.route('/reports/monthly')
def monthly_report():
    if 'logged_in' not in session: return redirect(url_for('login'))
    
    # If year/month omitted, default to current month but still show generator UI
    year = request.args.get('year', type=int) or datetime.now().year
    month = request.args.get('month', type=int) or datetime.now().month
    
    # Test connection first
    if not db.test_connection():
        flash('Database connection failed. Please ensure the Oracle database is running and accessible.', 'error')
        return redirect(url_for('dashboard'))
    
    # Always render the page; report contains defaults even if partial data fails
    report = db.get_monthly_report(year, month)
    if not report:
        flash('Unable to generate report. There may be an issue with the database. Check the server logs.', 'error')
        return redirect(url_for('dashboard'))
    
    return render_template('monthly_report.html', report=report)

if __name__ == '__main__':
    app.run(debug=True)