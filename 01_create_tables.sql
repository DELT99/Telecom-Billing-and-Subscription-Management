-- =====================================================================
-- Group       : Muhammad Talha 24F-0793 , Khizar Hayat 24F-0812
-- Project     : Telecom Billing & Subscription Management
-- Purpose     : Create all 8 base tables for the project schema.
-- =====================================================================




-- =====================================================================
-- 1. CUSTOMER  (parent in the EERD specialization hierarchy)
-- =====================================================================
CREATE TABLE customer (
    customer_id        NUMBER(10)      NOT NULL,
    cnic               VARCHAR2(15)    NOT NULL,
    first_name         VARCHAR2(50)    NOT NULL,
    last_name          VARCHAR2(50)    NOT NULL,
    date_of_birth      DATE            NOT NULL,
    gender             CHAR(1)         NOT NULL,
    phone_number       VARCHAR2(15)    NOT NULL,
    email              VARCHAR2(100),
    city               VARCHAR2(50)    NOT NULL,
    address            VARCHAR2(200),
    registration_date  DATE            DEFAULT SYSDATE NOT NULL,
    customer_type      VARCHAR2(10)    NOT NULL,
    account_status     VARCHAR2(10)    DEFAULT 'ACTIVE' NOT NULL,

    CONSTRAINT pk_customer PRIMARY KEY (customer_id),
    CONSTRAINT uk_customer_cnic UNIQUE (cnic),
    CONSTRAINT uk_customer_phone UNIQUE (phone_number),
    CONSTRAINT ck_customer_gender CHECK (gender IN ('M','F')),
    CONSTRAINT ck_customer_type CHECK (customer_type IN ('PREPAID','POSTPAID')),
    CONSTRAINT ck_customer_status CHECK (account_status IN ('ACTIVE','SUSPENDED','CLOSED'))
);

COMMENT ON TABLE customer IS 'Master record of every telecom subscriber (parent of the prepaid/postpaid ISA hierarchy).';

-- =====================================================================
-- 2. PREPAID_CUSTOMER  (specialization of CUSTOMER, disjoint, total)
--    The PK is also a FK to CUSTOMER, which is the textbook way of
-- =====================================================================
CREATE TABLE prepaid_customer (
    customer_id            NUMBER(10)      NOT NULL,
    current_balance        NUMBER(10,2)    DEFAULT 0    NOT NULL,
    last_recharge_date     DATE,
    last_recharge_amount   NUMBER(8,2),
    total_recharges        NUMBER(6)       DEFAULT 0    NOT NULL,
    --
    CONSTRAINT pk_prepaid_customer       PRIMARY KEY (customer_id),
    CONSTRAINT ck_prepaid_balance        CHECK (current_balance      >= 0),
    CONSTRAINT ck_prepaid_recharge_amt   CHECK (last_recharge_amount IS NULL OR last_recharge_amount > 0),
    CONSTRAINT ck_prepaid_total_rech     CHECK (total_recharges      >= 0)
);

COMMENT ON TABLE prepaid_customer IS 'Subclass of CUSTOMER. Pre-pays for service via balance top-ups.';

-- =====================================================================
-- 3. POSTPAID_CUSTOMER  (specialization of CUSTOMER, disjoint, total)
-- =====================================================================
CREATE TABLE postpaid_customer (
    customer_id           NUMBER(10)      NOT NULL,
    credit_limit          NUMBER(10,2)    NOT NULL,
    billing_cycle_day     NUMBER(2)       DEFAULT 1    NOT NULL,
    security_deposit      NUMBER(10,2)    DEFAULT 0    NOT NULL,
    bill_delivery_method  VARCHAR2(10)    DEFAULT 'EMAIL' NOT NULL,
    --
    CONSTRAINT pk_postpaid_customer        PRIMARY KEY (customer_id),
    CONSTRAINT ck_postpaid_credit_limit    CHECK (credit_limit > 0),
    CONSTRAINT ck_postpaid_cycle_day       CHECK (billing_cycle_day BETWEEN 1 AND 28),
    CONSTRAINT ck_postpaid_deposit         CHECK (security_deposit >= 0),
    CONSTRAINT ck_postpaid_delivery        CHECK (bill_delivery_method IN ('EMAIL','SMS','POSTAL'))
);

COMMENT ON TABLE postpaid_customer IS 'Subclass of CUSTOMER. Receives a monthly invoice and pays in arrears.';

-- =====================================================================
-- 4. SUBSCRIPTION_PLAN  (plans that company sells)
-- =====================================================================
CREATE TABLE subscription_plan (
    plan_id          NUMBER(6)       NOT NULL,
    plan_name        VARCHAR2(50)    NOT NULL,
    plan_type        VARCHAR2(10)    NOT NULL,        -- VOICE / DATA / SMS / BUNDLE
    monthly_rental   NUMBER(8,2)     NOT NULL,
    free_minutes     NUMBER(6)       DEFAULT 0    NOT NULL,
    free_sms         NUMBER(6)       DEFAULT 0    NOT NULL,
    free_data_mb     NUMBER(8)       DEFAULT 0    NOT NULL,
    per_minute_rate  NUMBER(6,2)     DEFAULT 0    NOT NULL,     -- charge once free_minutes are consumed
    per_sms_rate     NUMBER(6,2)     DEFAULT 0    NOT NULL,
    per_mb_rate      NUMBER(6,4)     DEFAULT 0    NOT NULL,
    validity_days    NUMBER(4)       NOT NULL,
    plan_status      VARCHAR2(15)    DEFAULT 'ACTIVE' NOT NULL,
    --
    CONSTRAINT pk_subscription_plan      PRIMARY KEY (plan_id),
    CONSTRAINT uk_plan_name              UNIQUE (plan_name),
    CONSTRAINT ck_plan_type              CHECK (plan_type IN ('VOICE','DATA','SMS','BUNDLE')),
    CONSTRAINT ck_plan_rental            CHECK (monthly_rental >= 0),
    CONSTRAINT ck_plan_free_min          CHECK (free_minutes   >= 0),
    CONSTRAINT ck_plan_free_sms          CHECK (free_sms       >= 0),
    CONSTRAINT ck_plan_free_data         CHECK (free_data_mb   >= 0),
    CONSTRAINT ck_plan_per_min_rate      CHECK (per_minute_rate>= 0),
    CONSTRAINT ck_plan_per_sms_rate      CHECK (per_sms_rate   >= 0),
    CONSTRAINT ck_plan_per_mb_rate       CHECK (per_mb_rate    >= 0),
    CONSTRAINT ck_plan_validity          CHECK (validity_days  >  0),
    CONSTRAINT ck_plan_status            CHECK (plan_status IN ('ACTIVE','DISCONTINUED'))
);

COMMENT ON TABLE subscription_plan IS 'Catalog of voice/data/SMS/bundle plans offered to customers.';

-- =====================================================================
-- 5. CUSTOMER_SUBSCRIPTION  (M:N junction with COMPOSITE PK)
--    A customer can subscribe to many plans (and the same plan can be
--    re-subscribed at different times), so start_date is part of the
--    primary key.
-- =====================================================================
CREATE TABLE customer_subscription (
    customer_id            NUMBER(10)      NOT NULL,
    plan_id                NUMBER(6)       NOT NULL,
    start_date             DATE            NOT NULL,
    end_date               DATE,
    subscription_status    VARCHAR2(15)    DEFAULT 'ACTIVE' NOT NULL,
    subscription_fee_paid  NUMBER(8,2)     DEFAULT 0        NOT NULL,
    --
    CONSTRAINT pk_customer_subscription  PRIMARY KEY (customer_id, plan_id, start_date),
    CONSTRAINT ck_sub_status             CHECK (subscription_status IN ('ACTIVE','EXPIRED','CANCELLED')),
    CONSTRAINT ck_sub_dates              CHECK (end_date IS NULL OR end_date > start_date),
    CONSTRAINT ck_sub_fee                CHECK (subscription_fee_paid >= 0)
);

COMMENT ON TABLE customer_subscription IS 'Junction table resolving the M:N relationship between CUSTOMER and SUBSCRIPTION_PLAN.';

-- =====================================================================
-- 6. USAGE_RECORD  (transaction table with COMPOSITE PK)
--    Captures every billable event: call, SMS or data session.
-- =====================================================================
CREATE TABLE usage_record (
    customer_id          NUMBER(10)      NOT NULL,
    usage_timestamp      DATE            NOT NULL,
    service_type         VARCHAR2(10)    NOT NULL,
    duration_seconds     NUMBER(8)       DEFAULT 0    NOT NULL,
    data_volume_mb       NUMBER(10,2)    DEFAULT 0    NOT NULL,
    destination_number   VARCHAR2(15),
    charge_amount        NUMBER(8,2)     DEFAULT 0    NOT NULL,
    is_billed            CHAR(1)         DEFAULT 'N'  NOT NULL,
    --
    CONSTRAINT pk_usage_record         PRIMARY KEY (customer_id, usage_timestamp, service_type),
    CONSTRAINT ck_usage_service_type   CHECK (service_type IN ('CALL','SMS','DATA')),
    CONSTRAINT ck_usage_duration       CHECK (duration_seconds >= 0),
    CONSTRAINT ck_usage_data_vol       CHECK (data_volume_mb   >= 0),
    CONSTRAINT ck_usage_charge         CHECK (charge_amount    >= 0),
    CONSTRAINT ck_usage_billed_flag    CHECK (is_billed IN ('Y','N'))
);

COMMENT ON TABLE usage_record IS 'Each call/SMS/data session billed to a customer. Composite PK = (customer, timestamp, service).';

-- =====================================================================
-- 7. INVOICE  (one row per customer per billing period)
-- =====================================================================
CREATE TABLE invoice (
    invoice_id             NUMBER(10)      NOT NULL,
    customer_id            NUMBER(10)      NOT NULL,
    billing_period_start   DATE            NOT NULL,
    billing_period_end     DATE            NOT NULL,
    generated_date         DATE            DEFAULT SYSDATE NOT NULL,
    due_date               DATE            NOT NULL,
    usage_charges          NUMBER(10,2)    DEFAULT 0   NOT NULL,
    rental_charges         NUMBER(10,2)    DEFAULT 0   NOT NULL,
    tax_amount             NUMBER(10,2)    DEFAULT 0   NOT NULL,
    total_amount           NUMBER(10,2)    NOT NULL,
    amount_paid            NUMBER(10,2)    DEFAULT 0   NOT NULL,
    invoice_status         VARCHAR2(10)    DEFAULT 'UNPAID' NOT NULL,
    --
    CONSTRAINT pk_invoice              PRIMARY KEY (invoice_id),
    CONSTRAINT ck_invoice_period       CHECK (billing_period_end > billing_period_start),
    CONSTRAINT ck_invoice_due          CHECK (due_date >= generated_date),
    CONSTRAINT ck_invoice_usage_chg    CHECK (usage_charges    >= 0),
    CONSTRAINT ck_invoice_rental_chg   CHECK (rental_charges   >= 0),
    CONSTRAINT ck_invoice_tax          CHECK (tax_amount       >= 0),
    CONSTRAINT ck_invoice_total        CHECK (total_amount     >= 0),
    CONSTRAINT ck_invoice_paid         CHECK (amount_paid      >= 0),
    CONSTRAINT ck_invoice_status       CHECK (invoice_status IN ('UNPAID','PARTIAL','PAID','OVERDUE'))
);

COMMENT ON TABLE invoice IS 'Monthly bill produced for postpaid customers (and ad-hoc bills for prepaid where applicable).';

-- =====================================================================
-- 8. PAYMENT  (one row per payment received)
-- =====================================================================
CREATE TABLE payment (
    payment_id              NUMBER(10)      NOT NULL,
    invoice_id              NUMBER(10)      NOT NULL,
    payment_date            DATE            DEFAULT SYSDATE NOT NULL,
    amount_paid             NUMBER(10,2)    NOT NULL,
    payment_method          VARCHAR2(15)    NOT NULL,
    transaction_reference   VARCHAR2(50),
    payment_status          VARCHAR2(10)    DEFAULT 'SUCCESS' NOT NULL,
    --
    CONSTRAINT pk_payment            PRIMARY KEY (payment_id),
    CONSTRAINT ck_payment_amount     CHECK (amount_paid > 0),
    CONSTRAINT ck_payment_method     CHECK (payment_method IN ('CASH','CARD','BANK_TRANSFER','MOBILE_WALLET')),
    CONSTRAINT ck_payment_status     CHECK (payment_status IN ('SUCCESS','FAILED','PENDING'))
);

COMMENT ON TABLE payment IS 'Each payment recorded against an invoice. Multiple payments per invoice are allowed (partial payments).';

-- Run order (for safe run)   : 10_drop_all.sql  -  01_create_tables.sql  - 02_constraints.sql - 03_sequences.sql - 04_indexes.sql - 05_insert_data.sql - 06_queries.sql - 07_views.sql - 08_dcl.sql - 09_plsql.sql             