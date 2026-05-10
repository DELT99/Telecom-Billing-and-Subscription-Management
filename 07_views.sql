-- =====================================================================
-- File        : 07_views.sql
-- Purpose     : Created views which are:
--                 (a) summary / reporting view  (vw_customer_billing_summary)
--                 (b) role-based / security view (vw_customer_public)
--                 (c) complex multi-table dashboard (vw_monthly_revenue_dashboard)
--                 (d) operational view of active subscriptions
--                 (e) operational view of overdue invoices
-- =====================================================================





-- VIEW 1 :  vw_customer_billing_summary
-- Type    :  Aggregated reporting view (one row per customer)
-- Use     :  Quick "at-a-glance" billing health for every customer.
-- =====================================================================
CREATE OR REPLACE VIEW vw_customer_billing_summary AS
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name              AS full_name,
        c.customer_type,
        c.city,
        c.account_status,
        COUNT(DISTINCT i.invoice_id)                    AS total_invoices,
        NVL(SUM(i.total_amount), 0)                     AS total_billed,
        NVL(SUM(i.amount_paid),  0)                     AS total_paid,
        NVL(SUM(i.total_amount), 0) - NVL(SUM(i.amount_paid), 0) AS outstanding_balance,
        SUM(CASE WHEN i.invoice_status = 'OVERDUE' THEN 1 ELSE 0 END) AS overdue_count
FROM    customer c
LEFT    JOIN invoice i ON c.customer_id = i.customer_id
GROUP   BY c.customer_id, c.first_name, c.last_name,
          c.customer_type, c.city, c.account_status;

COMMENT ON TABLE vw_customer_billing_summary IS 'One-row-per-customer billing dashboard.';

-- =====================================================================
-- VIEW 2 :  vw_customer_public
-- Type    :  Role-based / security view.
-- Use     :  Customer-service agents need to see the customer's name,
--            city and plan but MUST NOT see CNIC, date of birth or
--            email.  
-- =====================================================================
CREATE OR REPLACE VIEW vw_customer_public AS
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        c.phone_number,
        c.city,
        c.customer_type,
        c.account_status,
        c.registration_date
FROM    customer c;

COMMENT ON TABLE vw_customer_public IS 'PII-redacted view; safe to grant to customer-service role.';

-- =====================================================================
-- VIEW 3 :  vw_monthly_revenue_dashboard
-- Type    :  Multi-table dashboard view.
-- Use     :  Finance team's monthly Key Performance Indicators.  Aggregates invoices, payments
--            and active subscriptions by calendar month.
-- =====================================================================
CREATE OR REPLACE VIEW vw_monthly_revenue_dashboard AS
SELECT  rev_month,
        invoices_generated,
        total_billed_amount,
        successful_payments,
        total_collected,
        ROUND( (total_collected / NULLIF(total_billed_amount, 0)) * 100, 2 ) AS collection_pct
FROM   (SELECT  TO_CHAR(i.generated_date, 'YYYY-MM') AS rev_month,
                COUNT(DISTINCT i.invoice_id)                       AS invoices_generated,
                SUM(i.total_amount)                                AS total_billed_amount,
                (SELECT COUNT(*)
                 FROM   payment p
                 WHERE  p.payment_status = 'SUCCESS'
                 AND    TO_CHAR(p.payment_date, 'YYYY-MM') =
                        TO_CHAR(i.generated_date, 'YYYY-MM')
                )                                                  AS successful_payments,
                (SELECT NVL(SUM(p.amount_paid),0)
                 FROM   payment p
                 WHERE  p.payment_status = 'SUCCESS'
                 AND    TO_CHAR(p.payment_date, 'YYYY-MM') =
                        TO_CHAR(i.generated_date, 'YYYY-MM')
                )                                                  AS total_collected
        FROM   invoice i
        GROUP  BY TO_CHAR(i.generated_date, 'YYYY-MM'));

COMMENT ON TABLE vw_monthly_revenue_dashboard IS 'Finance KPI: invoices generated, billed, collected, collection percentage by month.';

-- =====================================================================
-- VIEW 4 :  vw_active_subscriptions
-- Type    :  Operational / day-to-day view.
-- Use     :  Support agents quickly check what plan a caller is on.
-- =====================================================================
CREATE OR REPLACE VIEW vw_active_subscriptions AS
SELECT  cs.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.phone_number,
        sp.plan_id,
        sp.plan_name,
        sp.plan_type,
        sp.monthly_rental,
        cs.start_date,
        cs.end_date,
        sp.validity_days,
        cs.subscription_fee_paid
FROM    customer_subscription cs
JOIN    customer              c  ON cs.customer_id = c.customer_id
JOIN    subscription_plan     sp ON cs.plan_id     = sp.plan_id
WHERE   cs.subscription_status = 'ACTIVE';

COMMENT ON TABLE vw_active_subscriptions IS 'Live list of active customer-plan combinations.';

-- =====================================================================
-- VIEW 5 :  vw_overdue_invoices
-- Type    :  Operational alert view.
-- Use     :  Drives the daily "collections call list".  Computes
--            days_overdue on the fly so stale data cannot lie.
-- =====================================================================
CREATE OR REPLACE VIEW vw_overdue_invoices AS
SELECT  i.invoice_id,
        i.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.phone_number,
        i.billing_period_end,
        i.due_date,
        TRUNC(SYSDATE) - TRUNC(i.due_date) AS days_overdue,
        i.total_amount,
        i.amount_paid,
        i.total_amount - i.amount_paid     AS outstanding
FROM    invoice  i
JOIN    customer c ON i.customer_id = c.customer_id
WHERE   i.due_date    < SYSDATE
AND     i.amount_paid < i.total_amount;

COMMENT ON TABLE vw_overdue_invoices IS 'Drives daily collections workflow; days_overdue is computed live.';

