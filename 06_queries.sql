-- =====================================================================
-- File        : 06_queries.sql
-- Purpose     : Demonstrate every category of SQL queries.  Each query is also preceded by a business
--               question written in the report, and some extra queires to show details.
-- =====================================================================


SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name  AS full_name,
        c.city,
        p.current_balance,
        p.last_recharge_date
FROM    customer         c
JOIN    prepaid_customer p ON c.customer_id = p.customer_id
WHERE   c.account_status = 'ACTIVE'
ORDER   BY p.current_balance DESC;

-- =====================================================================
-- 2. BASIC SELECT with arithmetic 
-- Business question : "Show every plan together with a 'value score'
-- =====================================================================
SELECT  plan_id,
        plan_name,
        plan_type,
        monthly_rental,
        free_minutes,
        CASE
            WHEN monthly_rental = 0 THEN 0
            ELSE ROUND(free_minutes / monthly_rental, 2)
        END                                AS minutes_per_rupee,
        CASE
            WHEN plan_type = 'BUNDLE' THEN 'Best for heavy users'
            WHEN plan_type = 'DATA'   THEN 'Best for internet users'
            WHEN plan_type = 'VOICE'  THEN 'Best for callers'
            ELSE                            'Niche pack'
        END                                AS recommendation
FROM    subscription_plan
WHERE   plan_status = 'ACTIVE'
ORDER   BY monthly_rental;

-- =====================================================================
-- 3. AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN, MAX)
-- Business question : "How many invoices have we generated in total,
-- and what are the total / average / min / max amounts?"
-- =====================================================================
SELECT  COUNT(*)                  AS invoice_count,
        SUM(total_amount)         AS total_billed,
        ROUND(AVG(total_amount),2) AS average_invoice,
        MIN(total_amount)         AS smallest_invoice,
        MAX(total_amount)         AS largest_invoice
FROM    invoice;

-- =====================================================================
-- 4. GROUP BY  --  city-wise customer counts
-- Business question : "Which cities have the most subscribers?"
-- =====================================================================
SELECT  city,
        COUNT(*)                                    AS total_customers,
        SUM(CASE WHEN customer_type = 'PREPAID'  THEN 1 ELSE 0 END) AS prepaid_count,
        SUM(CASE WHEN customer_type = 'POSTPAID' THEN 1 ELSE 0 END) AS postpaid_count
FROM    customer
GROUP   BY city
ORDER   BY total_customers DESC;

-- =====================================================================
-- 5. GROUP BY + HAVING
-- Business question : "Show plans that have at least 3 active
-- subscriptions."
-- =====================================================================
SELECT  sp.plan_id,
        sp.plan_name,
        sp.plan_type,
        COUNT(cs.customer_id) AS active_subscribers
FROM    subscription_plan      sp
JOIN    customer_subscription  cs ON sp.plan_id = cs.plan_id
WHERE   cs.subscription_status = 'ACTIVE'
GROUP   BY sp.plan_id, sp.plan_name, sp.plan_type
HAVING  COUNT(cs.customer_id) >= 3
ORDER   BY active_subscribers DESC;

-- =====================================================================
-- 6. GROUP BY + HAVING with aggregate filter
-- Business question : "Find customers whose total billed amount across
-- all invoices exceeds Rs. 5000 - showing high-value customers."
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        COUNT(i.invoice_id)                AS invoice_count,
        SUM(i.total_amount)                AS total_billed
FROM    customer c
JOIN    invoice  i ON c.customer_id = i.customer_id
GROUP   BY c.customer_id, c.first_name, c.last_name
HAVING  SUM(i.total_amount) > 5000
ORDER   BY total_billed DESC;

-- =====================================================================
-- 7. INNER JOIN  --  customer + their active subscription + plan
-- Business question : "List every active subscription with the
-- subscriber's name, the plan name, and the start date."
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        sp.plan_name,
        sp.plan_type,
        cs.start_date,
        cs.end_date,
        cs.subscription_fee_paid
FROM    customer              c
INNER   JOIN customer_subscription cs ON c.customer_id = cs.customer_id
INNER   JOIN subscription_plan     sp ON cs.plan_id    = sp.plan_id
WHERE   cs.subscription_status = 'ACTIVE'
ORDER   BY c.customer_id;

-- =====================================================================
-- 8. LEFT OUTER JOIN  --  customers WITHOUT any active subscription
-- Business question : "Which customers have NO active subscription?
-- The retention team needs to call them and pitch a plan."
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        c.phone_number,
        c.city,
        c.customer_type
FROM    customer c
LEFT    JOIN customer_subscription cs
         ON c.customer_id = cs.customer_id
         AND cs.subscription_status = 'ACTIVE'
WHERE   cs.customer_id IS NULL
ORDER   BY c.customer_id;

-- =====================================================================
-- 9. RIGHT OUTER JOIN  --  every plan and its subscriber count
-- Business question : "Show every plan in the catalog and the number
-- of customers currently subscribed to it (including plans with zero
-- subscribers, e.g. discontinued ones)."
-- =====================================================================
SELECT  sp.plan_id,
        sp.plan_name,
        sp.plan_status,
        COUNT(cs.customer_id) AS subscriber_count
FROM    customer_subscription cs
RIGHT   JOIN subscription_plan sp ON cs.plan_id = sp.plan_id
GROUP   BY sp.plan_id, sp.plan_name, sp.plan_status
ORDER   BY subscriber_count DESC, sp.plan_id;

-- =====================================================================
-- 10. MULTI-TABLE JOIN  --  customer + invoice + payment + plan
-- Business question : "Build a 360-degree report: for each invoice
-- show the customer, the plan they were on, the amount billed, and
-- how much they have actually paid."
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name        AS full_name,
        c.city,
        i.invoice_id,
        i.billing_period_start,
        i.billing_period_end,
        i.total_amount,
        NVL(SUM(p.amount_paid), 0)                AS total_paid,
        i.total_amount - NVL(SUM(p.amount_paid),0) AS outstanding,
        i.invoice_status
FROM    customer c
JOIN    invoice  i  ON c.customer_id = i.customer_id
LEFT    JOIN payment p
         ON i.invoice_id = p.invoice_id
         AND p.payment_status = 'SUCCESS'
GROUP   BY c.customer_id, c.first_name, c.last_name, c.city,
          i.invoice_id, i.billing_period_start, i.billing_period_end,
          i.total_amount, i.invoice_status
ORDER   BY c.customer_id, i.billing_period_start;

-- =====================================================================
-- 11. NON-CORRELATED SUBQUERY  --  customers with above-average billing
-- Business question : "Which customers have a total billed amount
-- greater than the system-wide average per-customer billing?"
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        SUM(i.total_amount)                AS total_billed
FROM    customer c
JOIN    invoice  i ON c.customer_id = i.customer_id
GROUP   BY c.customer_id, c.first_name, c.last_name
HAVING  SUM(i.total_amount) >
        (SELECT AVG(customer_total)        -- non-correlated inner query
         FROM   (SELECT SUM(total_amount) AS customer_total
                 FROM   invoice
                 GROUP  BY customer_id))
ORDER   BY total_billed DESC;

-- =====================================================================
-- 12. CORRELATED SUBQUERY  --  most recent invoice per customer
-- Business question : "Show the LATEST invoice for every postpaid
-- customer (i.e. their most recent bill)."
-- The inner query is correlated: it references the outer i1.customer_id
-- and re-runs once per outer row.
-- =====================================================================
SELECT  c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        i1.invoice_id,
        i1.billing_period_end,
        i1.total_amount,
        i1.invoice_status
FROM    customer c
JOIN    invoice  i1 ON c.customer_id = i1.customer_id
WHERE   c.customer_type = 'POSTPAID'
AND     i1.generated_date =
        (SELECT MAX(i2.generated_date)     -- correlated to i1.customer_id
         FROM   invoice i2
         WHERE  i2.customer_id = i1.customer_id)
ORDER   BY c.customer_id;

-- =====================================================================
-- 13. SUBQUERY in FROM clause (inline view)  --  top spenders per city
-- Business question : "For each city, who is the single customer with
-- the highest billed amount?"
-- =====================================================================
SELECT  city, customer_id, full_name, total_billed
FROM    (SELECT  c.city,
                 c.customer_id,
                 c.first_name || ' ' || c.last_name AS full_name,
                 SUM(i.total_amount)                AS total_billed,
                 RANK() OVER (PARTITION BY c.city
                              ORDER BY SUM(i.total_amount) DESC) AS city_rank
         FROM    customer c
         JOIN    invoice  i ON c.customer_id = i.customer_id
         GROUP   BY c.city, c.customer_id, c.first_name, c.last_name)
WHERE   city_rank = 1
ORDER   BY total_billed DESC;

-- =====================================================================
-- 14. EXISTS / NOT EXISTS  --  customers who have NEVER made a payment
-- Business question : "Identify customers who have at least one
-- invoice but have never made any successful payment."
-- =====================================================================
SELECT  DISTINCT c.customer_id,
        c.first_name || ' ' || c.last_name AS full_name,
        c.phone_number
FROM    customer c
JOIN    invoice  i ON c.customer_id = i.customer_id
WHERE   NOT EXISTS (
        SELECT 1
        FROM   payment p
        WHERE  p.invoice_id = i.invoice_id
        AND    p.payment_status = 'SUCCESS'
);





