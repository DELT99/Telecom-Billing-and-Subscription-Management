-- =====================================================================
-- File        : 10_drop_all.sql
-- Purpose     : Cleanly drop all database objects so that the schema can
--               be rebuilt from scratch. GOOD PRACITCE
-- =====================================================================




-- ---------------------------------------------------------------------
-- 1. Drop views (must be dropped before their underlying tables)
-- ---------------------------------------------------------------------
BEGIN
    FOR v IN (SELECT view_name FROM user_views
              WHERE view_name IN ('VW_CUSTOMER_BILLING_SUMMARY',
                                  'VW_ACTIVE_SUBSCRIPTIONS',
                                  'VW_MONTHLY_REVENUE_DASHBOARD',
                                  'VW_OVERDUE_INVOICES',
                                  'VW_CUSTOMER_PUBLIC')) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v.view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view : ' || v.view_name);
    END LOOP;
END;
/

-- ---------------------------------------------------------------------
-- 2. Drop PL/SQL procedures, functions and triggers
-- ---------------------------------------------------------------------
BEGIN
    FOR p IN (SELECT object_name, object_type FROM user_objects
              WHERE object_type IN ('PROCEDURE','FUNCTION','TRIGGER','PACKAGE')
              AND object_name IN ('SP_GENERATE_MONTHLY_INVOICES',
                                  'FN_GET_OUTSTANDING_BALANCE',
                                  'TRG_UPDATE_INVOICE_ON_PAYMENT')) LOOP
        EXECUTE IMMEDIATE 'DROP ' || p.object_type || ' ' || p.object_name;
        DBMS_OUTPUT.PUT_LINE('Dropped ' || p.object_type || ' : ' || p.object_name);
    END LOOP;
END;
/

-- ---------------------------------------------------------------------
-- 3. Drop tables in the reverse order of their FK dependencies.
--    CASCADE CONSTRAINTS ensures FKs are removed automatically.
-- ---------------------------------------------------------------------
BEGIN
    FOR t IN (SELECT table_name FROM user_tables
              WHERE table_name IN ('PAYMENT',
                                   'INVOICE',
                                   'USAGE_RECORD',
                                   'CUSTOMER_SUBSCRIPTION',
                                   'SUBSCRIPTION_PLAN',
                                   'PREPAID_CUSTOMER',
                                   'POSTPAID_CUSTOMER',
                                   'CUSTOMER')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
        DBMS_OUTPUT.PUT_LINE('Dropped table : ' || t.table_name);
    END LOOP;
END;
/

-- ---------------------------------------------------------------------
-- 4. Drop sequences
-- ---------------------------------------------------------------------
BEGIN
    FOR s IN (SELECT sequence_name FROM user_sequences
              WHERE sequence_name IN ('SEQ_CUSTOMER_ID',
                                      'SEQ_PLAN_ID',
                                      'SEQ_INVOICE_ID',
                                      'SEQ_PAYMENT_ID')) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
        DBMS_OUTPUT.PUT_LINE('Dropped sequence : ' || s.sequence_name);
    END LOOP;
END;
/

-- ---------------------------------------------------------------------
-- 5. Drop indexes that were created explicitly (PK / UK indexes are
--    dropped automatically with the table).
-- ---------------------------------------------------------------------
BEGIN
    FOR i IN (SELECT index_name FROM user_indexes
              WHERE index_name IN ('IDX_CUSTOMER_CITY',
                                   'IDX_USAGE_BILLING_FLAG',
                                   'IDX_INVOICE_STATUS_DUE',
                                   'IDX_PAYMENT_DATE',
                                   'IDX_SUBSCRIPTION_STATUS')) LOOP
        EXECUTE IMMEDIATE 'DROP INDEX ' || i.index_name;
        DBMS_OUTPUT.PUT_LINE('Dropped index : ' || i.index_name);
    END LOOP;
END;
/
