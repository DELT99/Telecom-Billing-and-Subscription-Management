-- =====================================================================
-- File        : 05_insert_data.sql

-- All dates are written as TO_DATE('YYYY-MM-DD', 'YYYY-MM-DD') so the
-- script is independent of the session's NLS_DATE_FORMAT.
-- =====================================================================

SET SERVEROUTPUT ON;
SET FEEDBACK ON;

-- =====================================================================
-- 1. CUSTOMER  (20 rows)
--    customer_type acts as the discriminator for the ISA hierarchy.
-- =====================================================================
INSERT INTO customer VALUES (1001, '35202-1111111-1', 'Ahmed',    'Khan',     TO_DATE('1995-04-12','YYYY-MM-DD'), 'M', '03001234567', 'ahmed.khan@gmail.com',    'Lahore',     'House 12, Gulberg III',         TO_DATE('2024-01-15','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1002, '33100-2222222-2', 'Fatima',   'Ali',      TO_DATE('1998-08-25','YYYY-MM-DD'), 'F', '03012345678', 'fatima.ali@yahoo.com',    'Faisalabad', 'Street 5, Peoples Colony',      TO_DATE('2024-02-10','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1003, '42101-3333333-3', 'Bilal',    'Hussain',  TO_DATE('1990-11-03','YYYY-MM-DD'), 'M', '03023456789', 'bilal.hussain@gmail.com', 'Karachi',    'Flat 401, DHA Phase 6',         TO_DATE('2024-03-05','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1004, '36502-4444444-4', 'Ayesha',   'Malik',    TO_DATE('2000-02-14','YYYY-MM-DD'), 'F', '03034567890', 'ayesha.m@hotmail.com',    'Multan',     'Bosan Road',                    TO_DATE('2024-04-20','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1005, '37405-5555555-5', 'Hassan',   'Raza',     TO_DATE('1992-06-30','YYYY-MM-DD'), 'M', '03045678901', 'hassan.raza@gmail.com',   'Islamabad',  'Sector F-10',                   TO_DATE('2024-05-12','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1006, '33100-6666666-6', 'Sara',     'Iqbal',    TO_DATE('1999-09-09','YYYY-MM-DD'), 'F', '03056789012', 'sara.iqbal@gmail.com',    'Faisalabad', 'D-Ground',                      TO_DATE('2024-06-01','YYYY-MM-DD'), 'PREPAID',  'SUSPENDED');
INSERT INTO customer VALUES (1007, '35202-7777777-7', 'Usman',    'Ahmed',    TO_DATE('1988-01-20','YYYY-MM-DD'), 'M', '03067890123', 'usman.ahmed@gmail.com',   'Lahore',     'Johar Town',                    TO_DATE('2024-07-15','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1008, '42101-8888888-8', 'Hina',     'Tariq',    TO_DATE('1996-12-05','YYYY-MM-DD'), 'F', '03078901234', 'hina.tariq@gmail.com',    'Karachi',    'Clifton Block 4',               TO_DATE('2024-08-22','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1009, '37405-9999999-9', 'Omar',     'Saeed',    TO_DATE('1985-07-18','YYYY-MM-DD'), 'M', '03089012345', 'omar.saeed@gmail.com',    'Islamabad',  'F-7 Markaz',                    TO_DATE('2024-09-10','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
INSERT INTO customer VALUES (1010, '33100-1010101-0', 'Mariam',   'Yousaf',   TO_DATE('2001-03-22','YYYY-MM-DD'), 'F', '03090123456', 'mariam.y@gmail.com',      'Faisalabad', 'Jaranwala Road',                TO_DATE('2024-10-05','YYYY-MM-DD'), 'PREPAID',  'ACTIVE');
-- Postpaid customers
INSERT INTO customer VALUES (1011, '35202-1212121-1', 'Imran',    'Sheikh',   TO_DATE('1980-05-15','YYYY-MM-DD'), 'M', '03101234567', 'imran.sheikh@corp.pk',    'Lahore',     'Cantt Area',                    TO_DATE('2023-11-01','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1012, '42101-1313131-2', 'Sadia',    'Naveed',   TO_DATE('1987-10-10','YYYY-MM-DD'), 'F', '03112345678', 'sadia.naveed@corp.pk',    'Karachi',    'PECHS Block 2',                 TO_DATE('2023-09-20','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1013, '37405-1414141-3', 'Adeel',    'Mahmood',  TO_DATE('1975-02-28','YYYY-MM-DD'), 'M', '03123456789', 'adeel.m@corp.pk',         'Islamabad',  'Blue Area',                     TO_DATE('2023-08-15','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1014, '33100-1515151-4', 'Nida',     'Bashir',   TO_DATE('1991-07-04','YYYY-MM-DD'), 'F', '03134567890', 'nida.bashir@corp.pk',     'Faisalabad', 'Susan Road',                    TO_DATE('2023-12-10','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1015, '35202-1616161-5', 'Zain',     'Abbas',    TO_DATE('1993-11-11','YYYY-MM-DD'), 'M', '03145678901', 'zain.abbas@corp.pk',      'Lahore',     'Model Town',                    TO_DATE('2024-01-25','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1016, '42101-1717171-6', 'Rabia',    'Hameed',   TO_DATE('1982-04-08','YYYY-MM-DD'), 'F', '03156789012', 'rabia.h@corp.pk',         'Karachi',    'Gulshan e Iqbal',               TO_DATE('2023-07-12','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1017, '37405-1818181-7', 'Faisal',   'Akhtar',   TO_DATE('1984-09-19','YYYY-MM-DD'), 'M', '03167890123', 'faisal.akhtar@corp.pk',   'Islamabad',  'I-8 Sector',                    TO_DATE('2024-02-28','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1018, '33100-1919191-8', 'Komal',    'Aslam',    TO_DATE('1997-06-25','YYYY-MM-DD'), 'F', '03178901234', 'komal.aslam@corp.pk',     'Faisalabad', 'Madina Town',                   TO_DATE('2024-03-15','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1019, '35202-2020202-9', 'Tariq',    'Javed',    TO_DATE('1978-12-31','YYYY-MM-DD'), 'M', '03189012345', 'tariq.javed@corp.pk',     'Lahore',     'Defence Phase 5',               TO_DATE('2023-10-08','YYYY-MM-DD'), 'POSTPAID', 'ACTIVE');
INSERT INTO customer VALUES (1020, '42101-2121212-0', 'Saima',    'Riaz',     TO_DATE('1989-08-17','YYYY-MM-DD'), 'F', '03190123456', 'saima.riaz@corp.pk',      'Karachi',    'North Nazimabad',               TO_DATE('2024-04-30','YYYY-MM-DD'), 'POSTPAID', 'CLOSED');

-- =====================================================================
-- 2. PREPAID_CUSTOMER  (10 rows, customer_id 1001-1010)
-- =====================================================================
INSERT INTO prepaid_customer VALUES (1001,  120.50, TO_DATE('2026-04-25','YYYY-MM-DD'), 200.00, 18);
INSERT INTO prepaid_customer VALUES (1002,   45.75, TO_DATE('2026-04-30','YYYY-MM-DD'), 100.00, 22);
INSERT INTO prepaid_customer VALUES (1003,  500.00, TO_DATE('2026-05-01','YYYY-MM-DD'), 500.00,  9);
INSERT INTO prepaid_customer VALUES (1004,   12.00, TO_DATE('2026-04-20','YYYY-MM-DD'),  50.00, 30);
INSERT INTO prepaid_customer VALUES (1005,  890.25, TO_DATE('2026-05-05','YYYY-MM-DD'),1000.00, 12);
INSERT INTO prepaid_customer VALUES (1006,    0.00, TO_DATE('2026-03-15','YYYY-MM-DD'),  50.00,  5);
INSERT INTO prepaid_customer VALUES (1007,  235.00, TO_DATE('2026-05-02','YYYY-MM-DD'), 250.00,  8);
INSERT INTO prepaid_customer VALUES (1008,   78.50, TO_DATE('2026-04-28','YYYY-MM-DD'), 100.00, 14);
INSERT INTO prepaid_customer VALUES (1009, 1500.00, TO_DATE('2026-05-06','YYYY-MM-DD'),2000.00,  4);
INSERT INTO prepaid_customer VALUES (1010,   65.00, TO_DATE('2026-04-15','YYYY-MM-DD'), 100.00,  3);

-- =====================================================================
-- 3. POSTPAID_CUSTOMER  (10 rows, customer_id 1011-1020)
-- =====================================================================
INSERT INTO postpaid_customer VALUES (1011, 10000.00,  1, 2000.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1012,  5000.00,  5, 1500.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1013, 20000.00, 15, 5000.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1014,  8000.00, 10, 2000.00, 'SMS');
INSERT INTO postpaid_customer VALUES (1015, 15000.00, 20, 3000.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1016, 25000.00, 25, 5000.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1017, 12000.00,  1, 2500.00, 'POSTAL');
INSERT INTO postpaid_customer VALUES (1018,  6000.00,  7, 1500.00, 'SMS');
INSERT INTO postpaid_customer VALUES (1019, 30000.00, 28, 6000.00, 'EMAIL');
INSERT INTO postpaid_customer VALUES (1020,  7000.00, 12, 1500.00, 'EMAIL');

-- =====================================================================
-- 4. SUBSCRIPTION_PLAN  (8 rows)
-- =====================================================================
INSERT INTO subscription_plan VALUES (101, 'Daily Dhamaka',         'BUNDLE',     30.00,    100,    100,     100,  1.50, 1.00, 0.5000,   1, 'ACTIVE');
INSERT INTO subscription_plan VALUES (102, 'Weekly Power Pack',     'BUNDLE',   150.00,    300,   1000,     500,  1.20, 0.80, 0.4000,   7, 'ACTIVE');
INSERT INTO subscription_plan VALUES (103, 'Monthly Voice Pro',     'VOICE',    500.00,   1500,      0,       0,  1.00, 0.00, 0.0000,  30, 'ACTIVE');
INSERT INTO subscription_plan VALUES (104, 'Monthly 4G Internet',   'DATA',     800.00,      0,      0,   10000,  0.00, 0.00, 0.1500,  30, 'ACTIVE');
INSERT INTO subscription_plan VALUES (105, 'Monthly Mega Bundle',   'BUNDLE',  1500.00,   2000,   5000,   20000,  0.80, 0.50, 0.1000,  30, 'ACTIVE');
INSERT INTO subscription_plan VALUES (106, 'SMS Lover Pack',        'SMS',       50.00,      0,   5000,       0,  0.00, 0.30, 0.0000,  30, 'ACTIVE');
INSERT INTO subscription_plan VALUES (107, 'Annual Super Saver',    'BUNDLE', 12000.00,  30000,  60000,  240000,  0.50, 0.25, 0.0800, 365, 'ACTIVE');
INSERT INTO subscription_plan VALUES (108, 'Old Promo Bundle',      'BUNDLE',   800.00,   1000,   1000,    5000,  1.00, 0.50, 0.2000,  30, 'DISCONTINUED');

-- =====================================================================
-- 5. CUSTOMER_SUBSCRIPTION  (28 rows, composite PK = customer_id + plan_id + start_date)
-- =====================================================================
-- prepaid customers tend to use short-validity plans, so multiple subs over time
INSERT INTO customer_subscription VALUES (1001, 101, TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-02','YYYY-MM-DD'), 'EXPIRED',   30.00);
INSERT INTO customer_subscription VALUES (1001, 101, TO_DATE('2026-04-15','YYYY-MM-DD'), TO_DATE('2026-04-16','YYYY-MM-DD'), 'EXPIRED',   30.00);
INSERT INTO customer_subscription VALUES (1001, 102, TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-08','YYYY-MM-DD'), 'ACTIVE',   150.00);
INSERT INTO customer_subscription VALUES (1002, 102, TO_DATE('2026-04-20','YYYY-MM-DD'), TO_DATE('2026-04-27','YYYY-MM-DD'), 'EXPIRED',  150.00);
INSERT INTO customer_subscription VALUES (1002, 106, TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-31','YYYY-MM-DD'), 'ACTIVE',    50.00);
INSERT INTO customer_subscription VALUES (1003, 105, TO_DATE('2026-04-15','YYYY-MM-DD'), TO_DATE('2026-05-15','YYYY-MM-DD'), 'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1004, 101, TO_DATE('2026-04-25','YYYY-MM-DD'), TO_DATE('2026-04-26','YYYY-MM-DD'), 'EXPIRED',   30.00);
INSERT INTO customer_subscription VALUES (1004, 102, TO_DATE('2026-05-02','YYYY-MM-DD'), TO_DATE('2026-05-09','YYYY-MM-DD'), 'ACTIVE',   150.00);
INSERT INTO customer_subscription VALUES (1005, 104, TO_DATE('2026-04-10','YYYY-MM-DD'), TO_DATE('2026-05-10','YYYY-MM-DD'), 'ACTIVE',   800.00);
INSERT INTO customer_subscription VALUES (1005, 103, TO_DATE('2026-04-10','YYYY-MM-DD'), TO_DATE('2026-05-10','YYYY-MM-DD'), 'ACTIVE',   500.00);
INSERT INTO customer_subscription VALUES (1006, 106, TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'CANCELLED', 50.00);
INSERT INTO customer_subscription VALUES (1007, 105, TO_DATE('2026-04-20','YYYY-MM-DD'), TO_DATE('2026-05-20','YYYY-MM-DD'), 'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1008, 102, TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-08','YYYY-MM-DD'), 'ACTIVE',   150.00);
INSERT INTO customer_subscription VALUES (1009, 107, TO_DATE('2025-09-15','YYYY-MM-DD'), TO_DATE('2026-09-15','YYYY-MM-DD'), 'ACTIVE', 12000.00);
INSERT INTO customer_subscription VALUES (1010, 101, TO_DATE('2026-04-30','YYYY-MM-DD'), TO_DATE('2026-05-01','YYYY-MM-DD'), 'EXPIRED',   30.00);
-- postpaid customers usually have one ongoing monthly subscription
INSERT INTO customer_subscription VALUES (1011, 105, TO_DATE('2024-01-01','YYYY-MM-DD'), NULL,                                'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1012, 103, TO_DATE('2024-02-01','YYYY-MM-DD'), NULL,                                'ACTIVE',   500.00);
INSERT INTO customer_subscription VALUES (1012, 104, TO_DATE('2024-03-01','YYYY-MM-DD'), NULL,                                'ACTIVE',   800.00);
INSERT INTO customer_subscription VALUES (1013, 107, TO_DATE('2025-01-01','YYYY-MM-DD'), NULL,                                'ACTIVE', 12000.00);
INSERT INTO customer_subscription VALUES (1014, 105, TO_DATE('2024-06-01','YYYY-MM-DD'), NULL,                                'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1015, 103, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2025-04-01','YYYY-MM-DD'), 'EXPIRED',   500.00);
INSERT INTO customer_subscription VALUES (1015, 105, TO_DATE('2025-04-01','YYYY-MM-DD'), NULL,                                'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1016, 107, TO_DATE('2024-07-01','YYYY-MM-DD'), NULL,                                'ACTIVE', 12000.00);
INSERT INTO customer_subscription VALUES (1017, 104, TO_DATE('2024-03-01','YYYY-MM-DD'), NULL,                                'ACTIVE',   800.00);
INSERT INTO customer_subscription VALUES (1017, 103, TO_DATE('2024-03-01','YYYY-MM-DD'), NULL,                                'ACTIVE',   500.00);
INSERT INTO customer_subscription VALUES (1018, 105, TO_DATE('2024-04-01','YYYY-MM-DD'), NULL,                                'ACTIVE',  1500.00);
INSERT INTO customer_subscription VALUES (1019, 107, TO_DATE('2024-10-01','YYYY-MM-DD'), NULL,                                'ACTIVE', 12000.00);
INSERT INTO customer_subscription VALUES (1020, 105, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'CANCELLED', 1500.00);

-- =====================================================================
-- 6. USAGE_RECORD  (40 rows; composite PK = customer + timestamp + service_type)
--    NOTE: I deliberately use distinct timestamps per (customer,service)
--    so that the composite PK is never violated.
-- =====================================================================
-- prepaid customer 1001 (calls + SMS + data, mostly billed)
INSERT INTO usage_record VALUES (1001, TO_DATE('2026-04-01 09:15:30','YYYY-MM-DD HH24:MI:SS'), 'CALL',  120,    0, '03212345678', 18.00, 'Y');
INSERT INTO usage_record VALUES (1001, TO_DATE('2026-04-01 14:22:10','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03219876543',  1.00, 'Y');
INSERT INTO usage_record VALUES (1001, TO_DATE('2026-05-02 10:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0,  150,  NULL,         60.00, 'N');
INSERT INTO usage_record VALUES (1001, TO_DATE('2026-05-03 11:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  300,    0, '03331122334',  6.00, 'N');
-- prepaid customer 1002
INSERT INTO usage_record VALUES (1002, TO_DATE('2026-04-21 08:00:00','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03001234567',  0.00, 'Y');
INSERT INTO usage_record VALUES (1002, TO_DATE('2026-04-22 13:45:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',   60,    0, '03111111111',  1.20, 'Y');
INSERT INTO usage_record VALUES (1002, TO_DATE('2026-05-05 15:00:00','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03332222222',  0.00, 'N');
-- prepaid customer 1003
INSERT INTO usage_record VALUES (1003, TO_DATE('2026-04-16 10:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  900,    0, '03001112233', 12.00, 'Y');
INSERT INTO usage_record VALUES (1003, TO_DATE('2026-04-17 12:15:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0,  500,  NULL,         50.00, 'Y');
INSERT INTO usage_record VALUES (1003, TO_DATE('2026-05-04 09:30:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 1200,  NULL,        120.00, 'N');
-- prepaid customer 1004
INSERT INTO usage_record VALUES (1004, TO_DATE('2026-04-25 18:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',   45,    0, '03001234567',  0.00, 'Y');
INSERT INTO usage_record VALUES (1004, TO_DATE('2026-05-03 19:45:00','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03012345678',  0.00, 'N');
-- prepaid customer 1005 (heavy data user)
INSERT INTO usage_record VALUES (1005, TO_DATE('2026-04-12 07:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 2500,  NULL,        375.00, 'Y');
INSERT INTO usage_record VALUES (1005, TO_DATE('2026-04-15 21:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 3000,  NULL,        450.00, 'Y');
INSERT INTO usage_record VALUES (1005, TO_DATE('2026-05-06 08:30:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 4500,  NULL,        675.00, 'N');
-- prepaid customer 1007
INSERT INTO usage_record VALUES (1007, TO_DATE('2026-04-22 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 1200,    0, '03331122334', 18.00, 'Y');
INSERT INTO usage_record VALUES (1007, TO_DATE('2026-05-02 14:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  600,    0, '03212345678',  9.00, 'N');
-- prepaid customer 1008
INSERT INTO usage_record VALUES (1008, TO_DATE('2026-05-02 09:15:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  240,    0, '03331122334',  4.80, 'Y');
INSERT INTO usage_record VALUES (1008, TO_DATE('2026-05-05 16:00:00','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03012345678',  0.00, 'N');
-- prepaid customer 1009 (annual plan, lots of usage)
INSERT INTO usage_record VALUES (1009, TO_DATE('2026-04-10 10:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 1500,    0, '03001234567',  0.00, 'Y');
INSERT INTO usage_record VALUES (1009, TO_DATE('2026-04-15 13:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 5000,  NULL,          0.00, 'Y');
INSERT INTO usage_record VALUES (1009, TO_DATE('2026-05-04 18:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 6000,  NULL,          0.00, 'N');
-- postpaid customer 1011
INSERT INTO usage_record VALUES (1011, TO_DATE('2026-04-05 09:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 1800,    0, '03212345678', 14.40, 'Y');
INSERT INTO usage_record VALUES (1011, TO_DATE('2026-04-10 14:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 8000,  NULL,        800.00, 'Y');
INSERT INTO usage_record VALUES (1011, TO_DATE('2026-04-25 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 2400,    0, '03331122334', 19.20, 'Y');
INSERT INTO usage_record VALUES (1011, TO_DATE('2026-05-02 16:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  600,    0, '03212345678',  4.80, 'N');
-- postpaid customer 1012
INSERT INTO usage_record VALUES (1012, TO_DATE('2026-04-08 10:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  900,    0, '03001234567',  9.00, 'Y');
INSERT INTO usage_record VALUES (1012, TO_DATE('2026-04-20 17:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 1500,  NULL,        225.00, 'Y');
INSERT INTO usage_record VALUES (1012, TO_DATE('2026-05-04 12:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 2000,  NULL,        300.00, 'N');
-- postpaid customer 1013
INSERT INTO usage_record VALUES (1013, TO_DATE('2026-04-11 08:45:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 3600,    0, '03212345678', 18.00, 'Y');
INSERT INTO usage_record VALUES (1013, TO_DATE('2026-05-01 13:15:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0,12000,  NULL,        960.00, 'N');
-- postpaid customer 1014
INSERT INTO usage_record VALUES (1014, TO_DATE('2026-04-13 19:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 1200,    0, '03331122334',  9.60, 'Y');
INSERT INTO usage_record VALUES (1014, TO_DATE('2026-05-03 20:30:00','YYYY-MM-DD HH24:MI:SS'), 'SMS',     0,    0, '03012345678',  0.50, 'N');
-- postpaid customer 1015
INSERT INTO usage_record VALUES (1015, TO_DATE('2026-04-18 14:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 2100,    0, '03212345678', 16.80, 'Y');
INSERT INTO usage_record VALUES (1015, TO_DATE('2026-05-05 10:45:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 3500,  NULL,        525.00, 'N');
-- postpaid customer 1016
INSERT INTO usage_record VALUES (1016, TO_DATE('2026-04-19 09:30:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 4500,    0, '03331122334',  0.00, 'Y');
INSERT INTO usage_record VALUES (1016, TO_DATE('2026-05-06 11:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0,15000,  NULL,          0.00, 'N');
-- postpaid customer 1017
INSERT INTO usage_record VALUES (1017, TO_DATE('2026-04-21 16:00:00','YYYY-MM-DD HH24:MI:SS'), 'CALL',  720,    0, '03001234567',  7.20, 'Y');
INSERT INTO usage_record VALUES (1017, TO_DATE('2026-05-04 15:00:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 2200,  NULL,        330.00, 'N');
-- postpaid customer 1019
INSERT INTO usage_record VALUES (1019, TO_DATE('2026-04-23 10:15:00','YYYY-MM-DD HH24:MI:SS'), 'CALL', 5400,    0, '03212345678',  0.00, 'Y');
INSERT INTO usage_record VALUES (1019, TO_DATE('2026-05-05 12:30:00','YYYY-MM-DD HH24:MI:SS'), 'DATA',    0, 8000,  NULL,          0.00, 'N');

-- =====================================================================
-- 7. INVOICE  (25 rows; mostly for postpaid customers)
-- =====================================================================
INSERT INTO invoice VALUES (9001, 1011, TO_DATE('2026-02-01','YYYY-MM-DD'), TO_DATE('2026-02-28','YYYY-MM-DD'), TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-15','YYYY-MM-DD'),  450.00, 1500.00, 312.00, 2262.00, 2262.00, 'PAID');
INSERT INTO invoice VALUES (9002, 1011, TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-15','YYYY-MM-DD'),  680.00, 1500.00, 348.40, 2528.40, 2528.40, 'PAID');
INSERT INTO invoice VALUES (9003, 1011, TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), TO_DATE('2026-05-01','YYYY-MM-DD'), TO_DATE('2026-05-15','YYYY-MM-DD'),  833.60, 1500.00, 363.42, 2697.02, 1500.00, 'PARTIAL');
INSERT INTO invoice VALUES (9004, 1012, TO_DATE('2026-02-05','YYYY-MM-DD'), TO_DATE('2026-03-04','YYYY-MM-DD'), TO_DATE('2026-03-05','YYYY-MM-DD'), TO_DATE('2026-03-19','YYYY-MM-DD'),  150.00, 1300.00, 232.00, 1682.00, 1682.00, 'PAID');
INSERT INTO invoice VALUES (9005, 1012, TO_DATE('2026-03-05','YYYY-MM-DD'), TO_DATE('2026-04-04','YYYY-MM-DD'), TO_DATE('2026-04-05','YYYY-MM-DD'), TO_DATE('2026-04-19','YYYY-MM-DD'),  234.00, 1300.00, 245.36, 1779.36, 1779.36, 'PAID');
INSERT INTO invoice VALUES (9006, 1012, TO_DATE('2026-04-05','YYYY-MM-DD'), TO_DATE('2026-05-04','YYYY-MM-DD'), TO_DATE('2026-05-05','YYYY-MM-DD'), TO_DATE('2026-05-19','YYYY-MM-DD'),  525.00, 1300.00, 291.50, 2116.50,    0.00, 'UNPAID');
INSERT INTO invoice VALUES (9007, 1013, TO_DATE('2026-02-15','YYYY-MM-DD'), TO_DATE('2026-03-14','YYYY-MM-DD'), TO_DATE('2026-03-15','YYYY-MM-DD'), TO_DATE('2026-03-29','YYYY-MM-DD'),    0.00, 1000.00, 130.00, 1130.00, 1130.00, 'PAID');
INSERT INTO invoice VALUES (9008, 1013, TO_DATE('2026-03-15','YYYY-MM-DD'), TO_DATE('2026-04-14','YYYY-MM-DD'), TO_DATE('2026-04-15','YYYY-MM-DD'), TO_DATE('2026-04-29','YYYY-MM-DD'),   18.00, 1000.00, 132.34, 1150.34, 1150.34, 'PAID');
INSERT INTO invoice VALUES (9009, 1013, TO_DATE('2026-04-15','YYYY-MM-DD'), TO_DATE('2026-05-14','YYYY-MM-DD'), TO_DATE('2026-05-15','YYYY-MM-DD'), TO_DATE('2026-05-29','YYYY-MM-DD'),  960.00, 1000.00, 254.80, 2214.80,    0.00, 'UNPAID');
INSERT INTO invoice VALUES (9010, 1014, TO_DATE('2026-02-10','YYYY-MM-DD'), TO_DATE('2026-03-09','YYYY-MM-DD'), TO_DATE('2026-03-10','YYYY-MM-DD'), TO_DATE('2026-03-24','YYYY-MM-DD'),  120.00, 1500.00, 210.60, 1830.60, 1830.60, 'PAID');
INSERT INTO invoice VALUES (9011, 1014, TO_DATE('2026-03-10','YYYY-MM-DD'), TO_DATE('2026-04-09','YYYY-MM-DD'), TO_DATE('2026-04-10','YYYY-MM-DD'), TO_DATE('2026-04-24','YYYY-MM-DD'),  240.00, 1500.00, 226.20, 1966.20, 1966.20, 'PAID');
INSERT INTO invoice VALUES (9012, 1014, TO_DATE('2026-04-10','YYYY-MM-DD'), TO_DATE('2026-05-09','YYYY-MM-DD'), TO_DATE('2026-05-10','YYYY-MM-DD'), TO_DATE('2026-05-24','YYYY-MM-DD'),    9.60, 1500.00, 196.25, 1705.85,    0.00, 'UNPAID');
INSERT INTO invoice VALUES (9013, 1015, TO_DATE('2026-02-20','YYYY-MM-DD'), TO_DATE('2026-03-19','YYYY-MM-DD'), TO_DATE('2026-03-20','YYYY-MM-DD'), TO_DATE('2026-04-03','YYYY-MM-DD'),  300.00, 1500.00, 234.00, 2034.00, 2034.00, 'PAID');
INSERT INTO invoice VALUES (9014, 1015, TO_DATE('2026-03-20','YYYY-MM-DD'), TO_DATE('2026-04-19','YYYY-MM-DD'), TO_DATE('2026-04-20','YYYY-MM-DD'), TO_DATE('2026-05-04','YYYY-MM-DD'),  280.00, 1500.00, 231.40, 2011.40, 1000.00, 'PARTIAL');
INSERT INTO invoice VALUES (9015, 1016, TO_DATE('2026-02-25','YYYY-MM-DD'), TO_DATE('2026-03-24','YYYY-MM-DD'), TO_DATE('2026-03-25','YYYY-MM-DD'), TO_DATE('2026-04-08','YYYY-MM-DD'),    0.00, 1000.00, 130.00, 1130.00, 1130.00, 'PAID');
INSERT INTO invoice VALUES (9016, 1016, TO_DATE('2026-03-25','YYYY-MM-DD'), TO_DATE('2026-04-24','YYYY-MM-DD'), TO_DATE('2026-04-25','YYYY-MM-DD'), TO_DATE('2026-05-09','YYYY-MM-DD'),    0.00, 1000.00, 130.00, 1130.00, 1130.00, 'PAID');
INSERT INTO invoice VALUES (9017, 1017, TO_DATE('2026-02-01','YYYY-MM-DD'), TO_DATE('2026-02-28','YYYY-MM-DD'), TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-15','YYYY-MM-DD'),  500.00, 1300.00, 234.00, 2034.00, 2034.00, 'PAID');
INSERT INTO invoice VALUES (9018, 1017, TO_DATE('2026-03-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), TO_DATE('2026-04-01','YYYY-MM-DD'), TO_DATE('2026-04-15','YYYY-MM-DD'),  450.00, 1300.00, 227.50, 1977.50, 1977.50, 'PAID');
INSERT INTO invoice VALUES (9019, 1017, TO_DATE('2026-01-15','YYYY-MM-DD'), TO_DATE('2026-02-14','YYYY-MM-DD'), TO_DATE('2026-02-15','YYYY-MM-DD'), TO_DATE('2026-03-01','YYYY-MM-DD'),  337.20, 1300.00, 212.84, 1850.04,    0.00, 'OVERDUE');
INSERT INTO invoice VALUES (9020, 1018, TO_DATE('2026-03-07','YYYY-MM-DD'), TO_DATE('2026-04-06','YYYY-MM-DD'), TO_DATE('2026-04-07','YYYY-MM-DD'), TO_DATE('2026-04-21','YYYY-MM-DD'),  100.00, 1500.00, 208.00, 1808.00, 1808.00, 'PAID');
INSERT INTO invoice VALUES (9021, 1018, TO_DATE('2026-04-07','YYYY-MM-DD'), TO_DATE('2026-05-06','YYYY-MM-DD'), TO_DATE('2026-05-07','YYYY-MM-DD'), TO_DATE('2026-05-21','YYYY-MM-DD'),  150.00, 1500.00, 214.50, 1864.50,    0.00, 'UNPAID');
INSERT INTO invoice VALUES (9022, 1019, TO_DATE('2026-02-28','YYYY-MM-DD'), TO_DATE('2026-03-27','YYYY-MM-DD'), TO_DATE('2026-03-28','YYYY-MM-DD'), TO_DATE('2026-04-11','YYYY-MM-DD'),    0.00, 1000.00, 130.00, 1130.00, 1130.00, 'PAID');
INSERT INTO invoice VALUES (9023, 1019, TO_DATE('2026-03-28','YYYY-MM-DD'), TO_DATE('2026-04-26','YYYY-MM-DD'), TO_DATE('2026-04-27','YYYY-MM-DD'), TO_DATE('2026-05-11','YYYY-MM-DD'),    0.00, 1000.00, 130.00, 1130.00,  500.00, 'PARTIAL');
INSERT INTO invoice VALUES (9024, 1020, TO_DATE('2026-02-12','YYYY-MM-DD'), TO_DATE('2026-03-11','YYYY-MM-DD'), TO_DATE('2026-03-12','YYYY-MM-DD'), TO_DATE('2026-03-26','YYYY-MM-DD'),  280.00, 1500.00, 231.40, 2011.40, 2011.40, 'PAID');
INSERT INTO invoice VALUES (9025, 1020, TO_DATE('2026-03-12','YYYY-MM-DD'), TO_DATE('2026-04-11','YYYY-MM-DD'), TO_DATE('2026-04-12','YYYY-MM-DD'), TO_DATE('2026-04-26','YYYY-MM-DD'),  165.00, 1500.00, 216.45, 1881.45,    0.00, 'OVERDUE');

-- =====================================================================
-- 8. PAYMENT  (25 rows; multiple payments allowed per invoice)
-- =====================================================================
INSERT INTO payment VALUES (50001, 9001, TO_DATE('2026-03-10','YYYY-MM-DD'), 2262.00, 'BANK_TRANSFER', 'BT-2026-001', 'SUCCESS');
INSERT INTO payment VALUES (50002, 9002, TO_DATE('2026-04-12','YYYY-MM-DD'), 2528.40, 'BANK_TRANSFER', 'BT-2026-002', 'SUCCESS');
INSERT INTO payment VALUES (50003, 9003, TO_DATE('2026-05-08','YYYY-MM-DD'), 1500.00, 'CARD',          'CARD-2026-001', 'SUCCESS');
INSERT INTO payment VALUES (50004, 9004, TO_DATE('2026-03-15','YYYY-MM-DD'), 1682.00, 'MOBILE_WALLET', 'JC-2026-001',   'SUCCESS');
INSERT INTO payment VALUES (50005, 9005, TO_DATE('2026-04-15','YYYY-MM-DD'), 1779.36, 'MOBILE_WALLET', 'JC-2026-002',   'SUCCESS');
INSERT INTO payment VALUES (50006, 9007, TO_DATE('2026-03-25','YYYY-MM-DD'), 1130.00, 'CARD',          'CARD-2026-002', 'SUCCESS');
INSERT INTO payment VALUES (50007, 9008, TO_DATE('2026-04-25','YYYY-MM-DD'), 1150.34, 'CARD',          'CARD-2026-003', 'SUCCESS');
INSERT INTO payment VALUES (50008, 9010, TO_DATE('2026-03-20','YYYY-MM-DD'), 1830.60, 'CASH',          'CASH-2026-001', 'SUCCESS');
INSERT INTO payment VALUES (50009, 9011, TO_DATE('2026-04-20','YYYY-MM-DD'), 1966.20, 'CASH',          'CASH-2026-002', 'SUCCESS');
INSERT INTO payment VALUES (50010, 9013, TO_DATE('2026-04-01','YYYY-MM-DD'), 2034.00, 'BANK_TRANSFER', 'BT-2026-003',   'SUCCESS');
INSERT INTO payment VALUES (50011, 9014, TO_DATE('2026-05-01','YYYY-MM-DD'),  500.00, 'BANK_TRANSFER', 'BT-2026-004',   'SUCCESS');
INSERT INTO payment VALUES (50012, 9014, TO_DATE('2026-05-05','YYYY-MM-DD'),  500.00, 'CARD',          'CARD-2026-004', 'SUCCESS');
INSERT INTO payment VALUES (50013, 9015, TO_DATE('2026-04-05','YYYY-MM-DD'), 1130.00, 'BANK_TRANSFER', 'BT-2026-005',   'SUCCESS');
INSERT INTO payment VALUES (50014, 9016, TO_DATE('2026-05-05','YYYY-MM-DD'), 1130.00, 'BANK_TRANSFER', 'BT-2026-006',   'SUCCESS');
INSERT INTO payment VALUES (50015, 9017, TO_DATE('2026-03-12','YYYY-MM-DD'), 2034.00, 'CASH',          'CASH-2026-003', 'SUCCESS');
INSERT INTO payment VALUES (50016, 9018, TO_DATE('2026-04-13','YYYY-MM-DD'), 1977.50, 'CASH',          'CASH-2026-004', 'SUCCESS');
INSERT INTO payment VALUES (50017, 9020, TO_DATE('2026-04-18','YYYY-MM-DD'), 1808.00, 'MOBILE_WALLET', 'JC-2026-003',   'SUCCESS');
INSERT INTO payment VALUES (50018, 9022, TO_DATE('2026-04-08','YYYY-MM-DD'), 1130.00, 'BANK_TRANSFER', 'BT-2026-007',   'SUCCESS');
INSERT INTO payment VALUES (50019, 9023, TO_DATE('2026-05-09','YYYY-MM-DD'),  500.00, 'BANK_TRANSFER', 'BT-2026-008',   'SUCCESS');
INSERT INTO payment VALUES (50020, 9024, TO_DATE('2026-03-23','YYYY-MM-DD'), 2011.40, 'CARD',          'CARD-2026-005', 'SUCCESS');
-- A failed and a pending payment for completeness
INSERT INTO payment VALUES (50021, 9006, TO_DATE('2026-05-10','YYYY-MM-DD'), 2116.50, 'CARD',          'CARD-2026-FAIL01', 'FAILED');
INSERT INTO payment VALUES (50022, 9009, TO_DATE('2026-05-20','YYYY-MM-DD'), 1000.00, 'MOBILE_WALLET', 'JC-2026-PEND01',   'PENDING');
-- A second successful partial payment to make 9023 closer to paid
INSERT INTO payment VALUES (50023, 9023, TO_DATE('2026-05-12','YYYY-MM-DD'),  300.00, 'CASH',          'CASH-2026-005', 'SUCCESS');
-- Cash payment for an old invoice
INSERT INTO payment VALUES (50024, 9001, TO_DATE('2026-03-08','YYYY-MM-DD'),    0.01, 'CASH',          'ROUNDING-01',   'SUCCESS');
-- Mobile wallet for partial that already had a card payment
INSERT INTO payment VALUES (50025, 9003, TO_DATE('2026-05-14','YYYY-MM-DD'),  500.00, 'MOBILE_WALLET', 'JC-2026-004',   'SUCCESS');

-- =====================================================================
-- COMMIT  =  make all the inserted rows visible to other sessions
-- =====================================================================
COMMIT;
