--01 Patients Table

INSERT INTO APP_ADMIN.Patients VALUES
(1, 'Amit', '9847254153', 'amit.sharma@example.com', '85 Main Road',
 'Sharma', 'Mumbai', 'Maharashtra', 400001, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(2, 'Neha', '9123456780', 'neha.patel@example.com', '14 Patel Street',
 'Patel', 'Ahmedabad', 'Gujarat', 380015, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(3, 'Rahul', '7894561230', 'rahul.verma@example.com', '202 Sector 5',
 'Verma', 'Delhi', 'Delhi', 110001, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(4, 'Sneha', '8001234567', 'sneha.k@example.com', 'Flat 3B MG Road',
 'Kulkarni', 'Pune', 'Maharashtra', 411001, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(5, 'Rohan', '7700987654', 'rohan.joshi@example.com', '11 Residency Lane',
 'Joshi', 'Bangalore', 'Karnataka', 560001, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(6, 'Priya', '9870011223', 'priya.mehta@example.com', '19 Sunrise Apts',
 'Mehta', 'Surat', 'Gujarat', 395003, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(7, 'Arjun', '8887766554', 'arjun.singh@example.com', '9 Tagore Marg',
 'Singh', 'Lucknow', 'Uttar Pradesh', 226001, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(8, 'Divya', '9012233445', 'divya.rao@example.com', 'Plot 22 Banjara Hills',
 'Rao', 'Hyderabad', 'Telangana', 500034, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(9, 'Karan', '9995556661', 'karan.t@example.com', '301 Lakeview Road',
 'Thakur', 'Chandigarh', 'Chandigarh', 160017, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Patients VALUES
(10, 'Anjali', '9900112233', 'anjali.desai@example.com', '5 Vasant Kunj',
 'Desai', 'Nagpur', 'Maharashtra', 440001, SYSDATE, 1, NULL, NULL);

----
--02 Prescriptions
-- Insert into Prescriptions
INSERT INTO APP_ADMIN.Prescriptions VALUES
(1, TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Issued', 1, 1, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(2, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'Issued', 2, 2, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(3, TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Dispensed', 3, 3, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(4, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Issued', 4, 4, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(5, TO_DATE('2024-02-10', 'YYYY-MM-DD'), 'Dispensed', 5, 5, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(6, TO_DATE('2024-02-12', 'YYYY-MM-DD'), 'Issued', 6, 6, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(7, TO_DATE('2024-02-20', 'YYYY-MM-DD'), 'Cancelled', 7, 7, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(8, TO_DATE('2024-03-01', 'YYYY-MM-DD'), 'Issued', 8, 8, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(9, TO_DATE('2024-03-05', 'YYYY-MM-DD'), 'Dispensed', 9, 9, SYSDATE, 1, NULL, NULL);

INSERT INTO APP_ADMIN.Prescriptions VALUES
(10, TO_DATE('2024-03-10', 'YYYY-MM-DD'), 'Issued', 10, 10, SYSDATE, 1, NULL, NULL);








-- 03Prescription-Drugs
-- Insert into Prescription_Drugs
INSERT INTO APP_ADMIN.Prescription_Drugs
(Prescription_Drugs_ID, Quantity, Drugs_Drug_ID, Prescriptions_Prescription_ID)
VALUES (1, 2, 1, 1);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (2, 1, 2, 2);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (3, 3, 3, 3);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (4, 1, 4, 4);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (5, 2, 5, 5);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (6, 1, 6, 6);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (7, 2, 7, 7);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (8, 1, 8, 8);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (9, 2, 9, 9);

INSERT INTO APP_ADMIN.Prescription_Drugs
VALUES (10, 1, 9, 10);


-- 04Sales Transaction
-- Insert 10 sample rows into Sales_Transactions
INSERT INTO APP_ADMIN.Sales_Transactions (
    Transaction_ID, Payment_ID, Date_Timestamp, Quantity_Sold,
    Total_Price, Drugs_Drug_ID, Users_User_ID, Created_On, Created_By
) VALUES
(1, 1, SYSDATE, 2, 150.00, 1, 2, SYSDATE, 2);



INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(2, 2, SYSDATE, 1, 85.00, 2, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(3, 3, SYSDATE, 3, 255.00, 3, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(4, 4, SYSDATE, 1, 95.00, 4, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(5, 2, SYSDATE, 2, 180.00, 5, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(6, 1, SYSDATE, 1, 60.00, 6, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(7, 3, SYSDATE, 2, 170.00, 7, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(8, 4, SYSDATE, 1, 100.00, 8, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(9, 2, SYSDATE, 2, 190.00, 9, 2, SYSDATE, 2, NULL, NULL);

INSERT INTO APP_ADMIN.Sales_Transactions VALUES
(10, 1, SYSDATE, 3, 270.00, 9, 2, SYSDATE, 2, NULL, NULL);


-- 05Inventory Logs

INSERT INTO APP_ADMIN.Inventory_Logs
(Log_ID, Change_Type, Change_Amount, Change_Date, Drugs_Drug_ID, Users_User_ID)
VALUES
(1, 'ADD', 50, SYSDATE, 1, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(2, 'SALE', 2, SYSDATE, 2, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(3, 'REMOVE', 5, SYSDATE, 3, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(4, 'ADD', 20, SYSDATE, 4, 1);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(5, 'SALE', 3, SYSDATE, 5, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(6, 'RETURN', 1, SYSDATE, 6, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(7, 'ADD', 30, SYSDATE, 7, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(8, 'EXPIRED_REMOVAL', 10, SYSDATE, 8, 1);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(9, 'SALE', 2, SYSDATE, 9, 2);

INSERT INTO APP_ADMIN.Inventory_Logs VALUES
(10, 'ADD', 40, SYSDATE, 9, 2);
