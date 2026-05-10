-- Create complaints table for the telecom billing system
CREATE TABLE complaint (
    complaint_id        NUMBER(10)      NOT NULL,
    customer_id         NUMBER(10)      NOT NULL,
    complaint_type      VARCHAR2(20)    NOT NULL,
    description         VARCHAR2(500)   NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'PENDING' NOT NULL,
    priority            VARCHAR2(10)    DEFAULT 'MEDIUM' NOT NULL,
    submitted_date      DATE            DEFAULT SYSDATE NOT NULL,
    resolved_date       DATE,
    assigned_to         VARCHAR2(50),
    resolution_notes    VARCHAR2(500),

    CONSTRAINT pk_complaint PRIMARY KEY (complaint_id),
    CONSTRAINT fk_complaint_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
    CONSTRAINT ck_complaint_type CHECK (complaint_type IN ('BILLING','SERVICE','TECHNICAL','OTHER')),
    CONSTRAINT ck_complaint_status CHECK (status IN ('PENDING','IN_PROGRESS','RESOLVED','CLOSED')),
    CONSTRAINT ck_complaint_priority CHECK (priority IN ('LOW','MEDIUM','HIGH','URGENT'))
);

-- Create sequence for complaint_id
CREATE SEQUENCE seq_complaint_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Insert some sample complaints
INSERT INTO complaint VALUES (seq_complaint_id.NEXTVAL, 1001, 'BILLING', 'Incorrect charges on my bill', 'PENDING', 'MEDIUM', TO_DATE('2026-04-15','YYYY-MM-DD'), NULL, NULL, NULL);
INSERT INTO complaint VALUES (seq_complaint_id.NEXTVAL, 1011, 'SERVICE', 'Poor network coverage in my area', 'IN_PROGRESS', 'HIGH', TO_DATE('2026-04-20','YYYY-MM-DD'), NULL, 'Technical Team', NULL);
INSERT INTO complaint VALUES (seq_complaint_id.NEXTVAL, 1005, 'TECHNICAL', 'Unable to connect to internet', 'RESOLVED', 'HIGH', TO_DATE('2026-04-10','YYYY-MM-DD'), TO_DATE('2026-04-12','YYYY-MM-DD'), 'Support Team', 'Router configuration issue resolved');
INSERT INTO complaint VALUES (seq_complaint_id.NEXTVAL, 1015, 'OTHER', 'Request for plan change', 'PENDING', 'LOW', TO_DATE('2026-05-01','YYYY-MM-DD'), NULL, NULL, NULL);

COMMIT;</content>
<parameter name="filePath">c:\Users\asd\Desktop\24F0793_24F0812_Telecom Billing & Subscription Management System\create_complaints.sql