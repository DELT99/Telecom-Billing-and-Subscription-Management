-- =====================================================================
-- File        : 02_constraints.sql
-- Purpose     : Add all FOREIGN KEY constraints in a single, ordered
--               script. Keeping FKs in a separate file allows the
--               CREATE-TABLE statements in 01_create_tables.sql to be
--               run in any order during development. best approach!
-- =====================================================================


ALTER TABLE prepaid_customer
ADD CONSTRAINT fk_prepaid_customer
FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
ON DELETE CASCADE;

ALTER TABLE postpaid_customer
ADD CONSTRAINT fk_postpaid_customer
FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
ON DELETE CASCADE;

-- ---------------------------------------------------------------------
-- M:N junction : customer_subscription
--   - FK to customer  : CASCADE (closing a customer removes their
--                       subscription history; matches business rule).
--   - FK to plan      : NO ACTION (the default).  Discontinuing a plan
--                       must not silently delete history; the DBA must
--                       expire the plan instead.
-- ---------------------------------------------------------------------
ALTER TABLE customer_subscription
ADD CONSTRAINT fk_subscription_customer
FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
ON DELETE CASCADE;

ALTER TABLE customer_subscription
ADD CONSTRAINT fk_subscription_plan
FOREIGN KEY (plan_id) REFERENCES subscription_plan (plan_id);
-- (no ON DELETE clause = NO ACTION  =>  blocks DROP-with-data)

-- ---------------------------------------------------------------------
-- usage_record  ->>  customer
--   - CASCADE because usage data belongs to the customer; if the
--     customer is purged, their call detail records go with them.
-- ---------------------------------------------------------------------
ALTER TABLE usage_record
ADD CONSTRAINT fk_usage_customer
FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
ON DELETE CASCADE;

-- ---------------------------------------------------------------------
-- invoice  ->>  customer
--   - default.  An invoice is a financial record that must
--     survive the customer's account closure for audit / tax purposes.
--     If the customer must be deleted, the operations team should
--     anonymise the customer record rather than cascade-delete invoices.
-- ---------------------------------------------------------------------
ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_customer
FOREIGN KEY (customer_id) REFERENCES customer (customer_id);

-- ---------------------------------------------------------------------
-- payment  ->  invoice
--   - NO ACTION.  Same reasoning as above: payments are financial
--     records that should never be silently destroyed.
-- ---------------------------------------------------------------------
ALTER TABLE payment
ADD CONSTRAINT fk_payment_invoice
FOREIGN KEY (invoice_id) REFERENCES invoice (invoice_id);
