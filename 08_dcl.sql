


-- =====================================================================
-- BLOCK A : Connect as SYSTEM (DBA) and create users
-- =====================================================================

BEGIN
    EXECUTE IMMEDIATE 'DROP USER billing_admin_user CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP USER customer_service_user CASCADE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 1. Billing-administrator user
--    Has full DML on financial tables but NOT DDL on the customer table.
CREATE USER billing_admin_user IDENTIFIED BY "Admin#2026"
    DEFAULT TABLESPACE   USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON   USERS;

-- 2. Customer-service user
--    Read-only access; can see only the public view (PII redacted).
CREATE USER customer_service_user IDENTIFIED BY "Cs#2026"
    DEFAULT TABLESPACE   USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 0 ON           USERS;        -- cannot create objects

-- Both users need CREATE SESSION just to log in
GRANT CREATE SESSION TO billing_admin_user;
GRANT CREATE SESSION TO customer_service_user;

-- =====================================================================
-- BLOCK B : Create roles (still connected as SYSTEM)
-- Roles bundle privileges for easier maintenance.
-- =====================================================================


CREATE ROLE billing_admin_role;
CREATE ROLE customer_service_role;
CREATE ROLE auditor_role;

-- =====================================================================
-- BLOCK C : The schema owner GRANTS object privileges TO the roles.
--   *** Switch SQL Developer's connection back to the SCHEMA OWNER WHICH IS DBPROJECT IN MY CASE ***
-- =====================================================================
-- billing_admin_role  : full DML on transaction tables, SELECT on rest
GRANT SELECT, INSERT, UPDATE, DELETE ON invoice  TO billing_admin_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON payment  TO billing_admin_role;
GRANT SELECT, INSERT, UPDATE         ON usage_record TO billing_admin_role;
GRANT SELECT                          ON customer  TO billing_admin_role;
GRANT SELECT                          ON subscription_plan      TO billing_admin_role;
GRANT SELECT                          ON customer_subscription  TO billing_admin_role;
GRANT SELECT                          ON vw_customer_billing_summary TO billing_admin_role;
GRANT SELECT                          ON vw_overdue_invoices         TO billing_admin_role;
GRANT SELECT                          ON vw_monthly_revenue_dashboard TO billing_admin_role;

-- customer_service_role : read-only on safe views ONLY
GRANT SELECT ON vw_customer_public        TO customer_service_role;
GRANT SELECT ON vw_active_subscriptions   TO customer_service_role;
GRANT SELECT ON subscription_plan         TO customer_service_role;

-- auditor_role : read EVERYTHING but cannot change anything
GRANT SELECT ON customer               TO auditor_role;
GRANT SELECT ON prepaid_customer       TO auditor_role;
GRANT SELECT ON postpaid_customer      TO auditor_role;
GRANT SELECT ON subscription_plan      TO auditor_role;
GRANT SELECT ON customer_subscription  TO auditor_role;
GRANT SELECT ON usage_record           TO auditor_role;
GRANT SELECT ON invoice                TO auditor_role;
GRANT SELECT ON payment                TO auditor_role;
GRANT SELECT ON vw_customer_billing_summary    TO auditor_role;
GRANT SELECT ON vw_monthly_revenue_dashboard   TO auditor_role;

-- =====================================================================
-- BLOCK D : Connect as SYSTEM again and assign roles to users
-- =====================================================================
GRANT billing_admin_role     TO billing_admin_user;
GRANT auditor_role           TO billing_admin_user;       -- bonus: admin can also audit
GRANT customer_service_role  TO customer_service_user;

-- =====================================================================
-- BLOCK E : REVOKE example  (still as the SCHEMA OWNER)
-- The auditor must NEVER see actual payment amounts because the audit
-- team is external.  We revoke SELECT on PAYMENT and re-grant a
-- masking view (commented out here — would be a separate view).
-- =====================================================================

REVOKE SELECT ON subscription_plan       FROM   customer_service_role;
-- REVOKE SELECT ON payment FROM auditor_role;
-- (Demonstration of REVOKE; uncomment to test.)
-- =====================================================================
-- BLOCK F : Privilege-test walkthrough  (run as the respective user)
-- =====================================================================
  CONNECT customer_service_user/Cs#2026
  SELECT * FROM dbproject.vw_customer_public;           -- works
--     SELECT * FROM <SCHEMA_OWNER>.customer;       -- ORA-00942: insufficient privileges
--     INSERT INTO <SCHEMA_OWNER>.invoice ...;      -- ORA-01031: insufficient privileges
--
-- 2.  CONNECT billing_admin_user/Admin#2026

   DELETE FROM <SCHEMA_OWNER>.customer;               -- fails: no DELETE on customer
--
