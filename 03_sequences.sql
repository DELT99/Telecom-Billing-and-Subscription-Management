-- =====================================================================
-- File        : 03_sequences.sql
-- Purpose     : Create sequences for every surrogate primary key.

-- =====================================================================



-- ---------------------------------------------------------------------
-- Sequence for CUSTOMER.customer_id, why to use a sequence for surrogate PKs?
-- data in 05_insert_data.sql uses literal IDs for
-- readability, so the sequence is set to start at 2001 to leave a safe
-- gap.  Future inserts  will pull from 2001 onwards via seq_customer_id.NEXTVAL.

-- ---------------------------------------------------------------------
CREATE SEQUENCE seq_customer_id
    START WITH       2001
    INCREMENT BY     1
    MINVALUE         1
    NOMAXVALUE
    NOCYCLE
    CACHE            20
    NOORDER;

-- ---------------------------------------------------------------------
-- Sequence for SUBSCRIPTION_PLAN.plan_id
-- Sample data uses 101-108; sequence starts at 201.
-- ---------------------------------------------------------------------
CREATE SEQUENCE seq_plan_id
    START WITH       201
    INCREMENT BY     1
    MINVALUE         1
    NOMAXVALUE
    NOCYCLE
    CACHE            10
    NOORDER;

-- ---------------------------------------------------------------------
-- Sequence for INVOICE.invoice_id
-- Sample data uses 9001-9025; sequence starts at 10001.
-- The PL/SQL billing procedure in 09_plsql.sql calls
-- seq_invoice_id.NEXTVAL whenever it generates a new invoice.
-- ---------------------------------------------------------------------
CREATE SEQUENCE seq_invoice_id
    START WITH       10001
    INCREMENT BY     1
    MINVALUE         1
    NOMAXVALUE
    NOCYCLE
    CACHE            20
    NOORDER;

-- ---------------------------------------------------------------------
-- Sequence for PAYMENT.payment_id
-- Sample data uses 50001-50025; sequence starts at 60001.
-- ---------------------------------------------------------------------
CREATE SEQUENCE seq_payment_id
    START WITH       60001
    INCREMENT BY     1
    MINVALUE         1
    NOMAXVALUE
    NOCYCLE
    CACHE            20
    NOORDER;

