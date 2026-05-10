-- =====================================================================
-- File        : 04_indexes.sql
-- Purpose     : Create non-unique B-tree indexes that improve query
--               performance.  Oracle automatically creates a unique
--               index for every PRIMARY KEY and UNIQUE constraint, so
--               those are NOT repeated here. .
-- =====================================================================



-- ---------------------------------------------------------------------
-- 1. IDX_CUSTOMER_CITY
-- WHY? : Marketing reports filter customers by city very often
-- (e.g. "active customers in Lahore"). Without an index, those queries
-- perform full scans on CUSTOMER which becomes painful as the table
-- grows beyond a few thousand rows.
-- ---------------------------------------------------------------------
CREATE INDEX idx_customer_city
ON customer (city);

-- ---------------------------------------------------------------------
-- 2. IDX_USAGE_BILLING_FLAG
-- WHY? : The monthly billing procedure scans USAGE_RECORD for
-- rows where IS_BILLED = 'N'.  Without an index, this requires a full scan of
-- the USAGE_RECORD table every month, which becomes increasingly expensive
-- ---------------------------------------------------------------------
CREATE INDEX idx_usage_billing_flag
ON usage_record (is_billed, customer_id);

-- ---------------------------------------------------------------------
-- 3. IDX_INVOICE_STATUS_DUE
-- WHY? : Used by the "overdue invoices" view and by the daily
-- collections report.  Composite index supports filters on STATUS and
-- range scans on DUE_DATE in a single seek.
-- ---------------------------------------------------------------------
CREATE INDEX idx_invoice_status_due
ON invoice (invoice_status, due_date);

-- ---------------------------------------------------------------------
-- 4. IDX_PAYMENT_DATE
-- WHY? : Cash-flow / revenue queries aggregate PAYMENT rows
-- by month, which means range scans on PAYMENT_DATE.
-- ---------------------------------------------------------------------
CREATE INDEX idx_payment_date
ON payment (payment_date);

-- ---------------------------------------------------------------------
-- 5. IDX_SUBSCRIPTION_STATUS
-- WHY? : The active-subscriptions view filters on
-- subscription_status = 'ACTIVE'. The plan_id is appended to the index
-- so that joins to SUBSCRIPTION_PLAN can use index-only access.
-- ---------------------------------------------------------------------
CREATE INDEX idx_subscription_status
ON customer_subscription (subscription_status, plan_id);
