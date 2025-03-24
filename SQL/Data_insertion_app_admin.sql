-- 01Insert Users (Admin + Pharmacists)
INSERT INTO APP_ADMIN.Users (
    User_ID, User_Name, Role, User_Contact_Number, User_Email, 
    User_Password, Created_On, Created_By
) VALUES 
(1, 'admin_master', 'admin', '9876543210', 'admin@app.com', 
 'Admin@123', SYSDATE, 1);

INSERT INTO APP_ADMIN.Users (
    User_ID, User_Name, Role, User_Contact_Number, User_Email, 
    User_Password, Created_On, Created_By
) VALUES 
(2, 'pharmacist_ravi', 'pharmacist', '9123456789', 'ravi@pharma.com', 
 'Pharma@123', SYSDATE, 1);

INSERT INTO APP_ADMIN.Users (
    User_ID, User_Name, Role, User_Contact_Number, User_Email, 
    User_Password, Created_On, Created_By
) VALUES 
(3, 'pharmacist_anu', 'pharmacist', '9012345678', 'anu@pharma.com', 
 'Pharma@456', SYSDATE, 1);
 
 
-- 02Doctor table
INSERT INTO APP_ADMIN.Doctors VALUES (1, 'Ravi', 'Kumar', 'Cardiology', '9123456789', 'ravi.kumar@clinic.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (2, 'Sneha', 'Rao', 'Dermatology', '9876543210', 'sneha.rao@hospital.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (3, 'Amit', 'Patel', 'Orthopedics', '8899776655', 'amit.patel@medcare.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (4, 'Priya', 'Mehra', 'Neurology', '9001122334', 'priya.mehra@healthplus.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (5, 'Karan', 'Singh', 'Pediatrics', '9988776655', 'karan.singh@clinic.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (6, 'Anjali', 'Sharma', 'Gynecology', '7778889990', 'anjali.sharma@hospital.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (7, 'Raj', 'Verma', 'ENT', '9112233445', 'raj.verma@medcity.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (8, 'Neha', 'Desai', 'Ophthalmology', '8881122334', 'neha.desai@visioncare.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (9, 'Vikram', 'Joshi', 'General Medicine', '9334455667', 'vikram.joshi@healthcare.com', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Doctors VALUES (10, 'Divya', 'Kapoor', 'Psychiatry', '9090909090', 'divya.kapoor@mindwell.com', SYSDATE, 1, NULL, NULL);


--03Supplier Table

INSERT INTO APP_ADMIN.Suppliers VALUES (1, 'MedLife Pharma', '9876543210', 'contact@medlife.com', '12 Health Park', 'Maharashtra', 400001, 'Mumbai', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (2, 'CureWell Distributors', '9123456789', 'sales@curewell.in', '45 Sector Road', 'Gujarat', 380015, 'Ahmedabad', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (3, 'PharmaPlus Ltd.', '8765432109', 'support@pharmaplus.com', '22 Green Lane', 'Karnataka', 560001, 'Bangalore', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (4, 'LifeCare Suppliers', '9988776655', 'lifecare@pharma.com', '88 City Road', 'Tamil Nadu', 600001, 'Chennai', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (5, 'HealthAid Traders', '9090909090', 'info@healthaid.com', '56 Lakeview Ave', 'Delhi', 110001, 'New Delhi', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (6, 'Sun Pharma Wholesale', '9551122334', 'orders@sunpharma.com', '9 Ring Road', 'Maharashtra', 400018, 'Pune', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (7, 'Apollo Distributors', '9812345678', 'contact@apollodistrib.com', '19 Sector-5', 'Haryana', 122001, 'Gurgaon', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (8, 'ZenoMed Pharma', '9789054321', 'sales@zenomed.in', '13 Hill Street', 'West Bengal', 700001, 'Kolkata', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (9, 'GoodHealth Drugs', '9654321098', 'contact@goodhealth.com', '35 Sunrise Blvd', 'Rajasthan', 302001, 'Jaipur', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Suppliers VALUES (10, 'Wellness Corp', '9876501234', 'admin@wellnesscorp.com', '7 Galaxy Towers', 'Punjab', 160017, 'Chandigarh', SYSDATE, 1, NULL, NULL);


---04Catagory Table

INSERT INTO APP_ADMIN.Catagory VALUES (1, 'Analgesics', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (2, 'Antibiotics', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (3, 'Antiseptics', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (4, 'Antipyretics', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (5, 'Vitamins', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (6, 'Antacids', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (7, 'Cough Suppressants', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (8, 'Antifungals', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (9, 'Antivirals', SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Catagory VALUES (10, 'Eye Drops', SYSDATE, 1, NULL, NULL);


--05Drug Table

INSERT INTO APP_ADMIN.Drugs VALUES (1, 'Paracetamol 500mg', 'B001', TO_DATE('2025-12-31', 'YYYY-MM-DD'), 25.00, 20.00, 100, 1, 1, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (2, 'Amoxicillin 250mg', 'B002', TO_DATE('2026-03-15', 'YYYY-MM-DD'), 50.00, 40.00, 80, 2, 2, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (3, 'Cetirizine 10mg', 'B003', TO_DATE('2025-08-20', 'YYYY-MM-DD'), 15.00, 12.00, 120, 1, 3, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (4, 'Ibuprofen 400mg', 'B004', TO_DATE('2026-01-10', 'YYYY-MM-DD'), 30.00, 25.00, 90, 3, 1, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (5, 'Azithromycin 500mg', 'B005', TO_DATE('2026-05-05', 'YYYY-MM-DD'), 80.00, 70.00, 75, 2, 2, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (6, 'Ranitidine 150mg', 'B006', TO_DATE('2025-11-30', 'YYYY-MM-DD'), 22.00, 18.00, 60, 4, 6, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (7, 'Loratadine 10mg', 'B007', TO_DATE('2026-02-28', 'YYYY-MM-DD'), 18.00, 14.00, 130, 1, 3, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (8, 'Metronidazole 400mg', 'B008', TO_DATE('2026-06-30', 'YYYY-MM-DD'), 40.00, 35.00, 70, 5, 8, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (9, 'Vitamin C 500mg', 'B009', TO_DATE('2025-09-15', 'YYYY-MM-DD'), 60.00, 50.00, 110, 3, 5, SYSDATE, 1, NULL, NULL);
INSERT INTO APP_ADMIN.Drugs VALUES (10, 'Salbutamol Inhaler', 'B010', TO_DATE('2026-04-10', 'YYYY-MM-DD'), 150.00, 120.00, 40, 2, 4, SYSDATE, 1, NULL, NULL);


select * from drugs;

--06 Payment Method

INSERT INTO APP_ADMIN.Payment_Method (Payment_ID, Payment_Type) VALUES (1, 'Cash');
INSERT INTO APP_ADMIN.Payment_Method (Payment_ID, Payment_Type) VALUES (2, 'Credit Card');
INSERT INTO APP_ADMIN.Payment_Method (Payment_ID, Payment_Type) VALUES (3, 'Debit Card');
INSERT INTO APP_ADMIN.Payment_Method (Payment_ID, Payment_Type) VALUES (4, 'Check');









