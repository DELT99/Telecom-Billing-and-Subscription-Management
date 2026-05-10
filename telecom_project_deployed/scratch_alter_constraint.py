import db
conn = db.get_connection()
cursor = conn.cursor()
try:
    cursor.execute("ALTER TABLE complaint DROP CONSTRAINT ck_complaint_status")
except Exception as e:
    print("Drop constraint failed:", e)

try:
    cursor.execute("ALTER TABLE complaint ADD CONSTRAINT ck_complaint_status CHECK (status IN ('PENDING','IN_PROGRESS','RESOLVED','CLOSED','REJECTED'))")
    print("Constraint updated successfully")
except Exception as e:
    print("Add constraint failed:", e)

conn.commit()
