-- =====================================================================
-- File        : 09_plsql.sql
-- Project     : Telecom Billing & Subscription Management
-- Purpose     : PL/SQL business logic for the project.  Contains:
--                 (1) Procedure  sp_generate_monthly_invoices
--                       - Loops every postpaid customer using a CURSOR,
--                         sums their unbilled usage, fetches the active
--                         plan rental, computes 13% tax, INSERTs an
--                         INVOICE row using seq_invoice_id.NEXTVAL,
--                         then flips IS_BILLED = 'Y' on the consumed
--                         usage rows.
--                 (2) Function   fn_get_outstanding_balance
--                       - Returns the balance still due for a customer.
--                 (3) Trigger    trg_update_invoice_on_payment
--                       - After each payment, automatically refreshes
--                         the parent invoice's amount_paid and status.
-- Database    : Oracle 11g Express Edition
-- FIRST, In SQLPLUS, switch to your schema owner connection (WHICH IS DBPROJECT IN MY CASE).
-- =====================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

-- =====================================================================
-- (1)  PROCEDURE  sp_generate_monthly_invoices
-- ---------------------------------------------------------------------
-- Generates a monthly invoice for every active POSTPAID customer for
-- the billing period passed as IN parameters.  Demonstrates:
--   * explicit CURSOR with a row-by-row loop
--   * %ROWTYPE record
--   * conditional control flow
--   * sequence usage (seq_invoice_id.NEXTVAL)
--   * RAISE_APPLICATION_ERROR for input validation
--   * structured EXCEPTION handler with NO_DATA_FOUND and OTHERS
-- =====================================================================
CREATE OR REPLACE PROCEDURE sp_generate_monthly_invoices (
    p_period_start  IN DATE,
    p_period_end    IN DATE
) IS
    -- Cursor : every active postpaid customer
    CURSOR c_postpaid IS
        SELECT  c.customer_id,
                c.first_name || ' ' || c.last_name AS full_name,
                pc.billing_cycle_day
        FROM    customer          c
        JOIN    postpaid_customer pc ON c.customer_id = pc.customer_id
        WHERE   c.account_status = 'ACTIVE';

    v_customer        c_postpaid%ROWTYPE;
    v_usage_total     NUMBER(10,2);
    v_rental_total    NUMBER(10,2);
    v_tax_rate        CONSTANT NUMBER := 0.13;     -- 13% sales tax (FBR)
    v_tax_amount      NUMBER(10,2);
    v_total_amount    NUMBER(10,2);
    v_due_date        DATE;
    v_new_invoice_id  NUMBER(10);
    v_invoices_made   NUMBER := 0;

BEGIN
    --input validation --
    IF p_period_end <= p_period_start THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Billing period END must be AFTER period START.');
    END IF;
    IF p_period_end > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Cannot bill for a period that has not ended yet.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('=== Monthly billing run started ===');
    DBMS_OUTPUT.PUT_LINE('Period : ' || TO_CHAR(p_period_start, 'YYYY-MM-DD')
                       || '  to  '   || TO_CHAR(p_period_end,   'YYYY-MM-DD'));

    --  main loop ---
    OPEN c_postpaid;
    LOOP
        FETCH c_postpaid INTO v_customer;
        EXIT WHEN c_postpaid%NOTFOUND;

        -- (a) sum unbilled usage for this customer in the period
        BEGIN
            SELECT NVL(SUM(charge_amount), 0)
            INTO   v_usage_total
            FROM   usage_record
            WHERE  customer_id = v_customer.customer_id
            AND    is_billed   = 'N'
            AND    usage_timestamp BETWEEN p_period_start AND p_period_end;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_usage_total := 0;
        END;

        -- (b) sum rentals from the customer's ACTIVE subscriptions
        BEGIN
            SELECT NVL(SUM(sp.monthly_rental), 0)
            INTO   v_rental_total
            FROM   customer_subscription cs
            JOIN   subscription_plan      sp ON cs.plan_id = sp.plan_id
            WHERE  cs.customer_id          = v_customer.customer_id
            AND    cs.subscription_status  = 'ACTIVE';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rental_total := 0;
        END;

        -- (c) skip customers with absolutely nothing to bill
        IF (v_usage_total + v_rental_total) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [skip] customer ' || v_customer.customer_id
                || ' (' || v_customer.full_name || ')  -- nothing to bill');
            CONTINUE;
        END IF;

        -- (d) compute totals
        v_tax_amount   := ROUND( (v_usage_total + v_rental_total) * v_tax_rate, 2 );
        v_total_amount := v_usage_total + v_rental_total + v_tax_amount;
        v_due_date     := p_period_end + 14;        -- 14-day net term

        -- (e) insert the new invoice
        v_new_invoice_id := seq_invoice_id.NEXTVAL;
        INSERT INTO invoice (
            invoice_id, customer_id,
            billing_period_start, billing_period_end,
            generated_date, due_date,
            usage_charges, rental_charges, tax_amount,
            total_amount,  amount_paid,    invoice_status
        ) VALUES (
            v_new_invoice_id, v_customer.customer_id,
            p_period_start,   p_period_end,
            SYSDATE,          v_due_date,
            v_usage_total,    v_rental_total, v_tax_amount,
            v_total_amount,   0,              'UNPAID'
        );

        -- (f) flag the consumed usage rows so they are not double-billed
        UPDATE usage_record
        SET    is_billed = 'Y'
        WHERE  customer_id     = v_customer.customer_id
        AND    is_billed       = 'N'
        AND    usage_timestamp BETWEEN p_period_start AND p_period_end;

        v_invoices_made := v_invoices_made + 1;
        DBMS_OUTPUT.PUT_LINE('  [ok]   invoice ' || v_new_invoice_id
            || ' for customer ' || v_customer.customer_id
            || ' (' || v_customer.full_name || ')'
            || '  total = Rs.' || v_total_amount);
    END LOOP;
    CLOSE c_postpaid;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('=== Run finished. ' || v_invoices_made
                       || ' invoice(s) generated. ===');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF c_postpaid%ISOPEN THEN CLOSE c_postpaid; END IF;
        DBMS_OUTPUT.PUT_LINE('!! Billing run aborted : ' || SQLERRM);
        RAISE;
END sp_generate_monthly_invoices;
/

-- =====================================================================
-- (2)  FUNCTION  fn_get_outstanding_balance
-- ---------------------------------------------------------------------
-- Returns the total outstanding balance (sum of total_amount minus
-- amount_paid) for the given customer, across ALL their invoices.
-- =====================================================================
CREATE OR REPLACE FUNCTION fn_get_outstanding_balance (
    p_customer_id IN customer.customer_id%TYPE
) RETURN NUMBER
IS
    v_outstanding NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(total_amount - amount_paid), 0)
    INTO   v_outstanding
    FROM   invoice
    WHERE  customer_id = p_customer_id;

    RETURN v_outstanding;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('fn_get_outstanding_balance error: ' || SQLERRM);
        RETURN -1;        -- caller sees a sentinel value indicating error
END fn_get_outstanding_balance;
/

-- =====================================================================
-- (3)  TRIGGER  trg_update_invoice_on_payment
-- ---------------------------------------------------------------------
-- AFTER a successful payment is INSERTED, recompute the parent
-- invoice's amount_paid and update its status.
-- =====================================================================
CREATE OR REPLACE TRIGGER trg_update_invoice_on_payment
AFTER INSERT ON payment
FOR EACH ROW
WHEN (NEW.payment_status = 'SUCCESS')
DECLARE
    v_total_amount NUMBER(10,2);
    v_new_paid     NUMBER(10,2);
    v_new_status   VARCHAR2(10);
BEGIN
    SELECT total_amount, amount_paid + :NEW.amount_paid
    INTO   v_total_amount, v_new_paid
    FROM   invoice
    WHERE  invoice_id = :NEW.invoice_id;

    IF    v_new_paid >= v_total_amount THEN v_new_status := 'PAID';
    ELSIF v_new_paid >  0              THEN v_new_status := 'PARTIAL';
    ELSE                                    v_new_status := 'UNPAID';
    END IF;

    UPDATE invoice
    SET    amount_paid    = v_new_paid,
           invoice_status = v_new_status
    WHERE  invoice_id     = :NEW.invoice_id;
END;
/

-- =====================================================================
-- TEST BLOCK -- exercise everything that was just compiled
-- =====================================================================
PROMPT --- Test 1 : invoke the billing procedure for April 2026 ---
BEGIN
    sp_generate_monthly_invoices(
        p_period_start => TO_DATE('2026-04-01','YYYY-MM-DD'),
        p_period_end   => TO_DATE('2026-04-30','YYYY-MM-DD')
    );
END;
/

 --- Test 2 : check outstanding balance via the function ---
SELECT customer_id,
       first_name || ' ' || last_name              AS full_name,
       fn_get_outstanding_balance(customer_id)     AS outstanding
FROM   customer
WHERE  customer_type = 'POSTPAID'
ORDER  BY customer_id;


-- Prove the trigger IGNORES failed payments , INSERT A FAILED PAYMENT MANUALLY, THEN CHECK THE INVOICE REMAINS UNCHANGED
INSERT INTO payment VALUES (
    seq_payment_id.NEXTVAL,
    9009,
    SYSDATE,
    5000.00,
    'CARD',
    'TRG-TEST-FAIL',
    'FAILED'
);
COMMIT;

-- Invoice 9009 should be UNCHANGED
SELECT invoice_id, total_amount, amount_paid, invoice_status
FROM invoice
WHERE invoice_id = 9009;