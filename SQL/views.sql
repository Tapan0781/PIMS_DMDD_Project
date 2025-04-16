-- Pharmaceutical Inventory Management System - Views
-- ================================================

-- 1. View: Current Inventory Status
-- Shows each drug with current stock and threshold alert
CREATE OR REPLACE VIEW Current_Inventory_Status AS
SELECT
    d.Drug_ID,
    d.Drug_Name,
    d.Stock_Quantity,
    d.MRP,
    d.Price,
    CASE 
        WHEN d.Stock_Quantity < 10 THEN 'LOW STOCK'
        ELSE 'SUFFICIENT'
    END AS Stock_Status
FROM Drugs d;


-- 2. View: Drug Price Audit History (requires logs if implemented)
-- Placeholder for future trigger-based price logging
-- CREATE OR REPLACE VIEW Product_Wise_Price_Changes AS ...


-- 3. View: Total Sales Region-wise
-- Aggregates total sales by supplier region (city + state)
CREATE OR REPLACE VIEW Total_Sales_Region_Wise AS
SELECT
    s.Supplier_City,
    s.Supplier_State,
    SUM(st.Total_Price) AS Total_Sales_Amount,
    COUNT(st.Transaction_ID) AS Total_Transactions
FROM Sales_Transactions st
JOIN Drugs d ON st.Drugs_Drug_ID = d.Drug_ID
JOIN Suppliers s ON d.Suppliers_Supplier_ID = s.Supplier_ID
GROUP BY s.Supplier_City, s.Supplier_State;


-- 4. View: Weekly Sales Report
-- Aggregates sales data week-wise using TRUNC and NEXT_DAY
CREATE OR REPLACE VIEW Week_Wise_Sales AS
SELECT
    TRUNC(Date_Timestamp, 'IW') AS Week_Start_Date,
    COUNT(*) AS Transactions_Count,
    SUM(Quantity_Sold) AS Total_Quantity,
    SUM(Total_Price) AS Total_Revenue
FROM Sales_Transactions
GROUP BY TRUNC(Date_Timestamp, 'IW')
ORDER BY Week_Start_Date DESC;


-- 5. View: Doctor-wise Prescription Count
CREATE OR REPLACE VIEW Doctor_Prescription_Count AS
SELECT
    d.Doctor_ID,
    d.Doctor_First_Name || ' ' || d.Doctor_Last_Name AS Doctor_Name,
    COUNT(p.Prescription_ID) AS Total_Prescriptions
FROM Doctors d
LEFT JOIN Prescriptions p ON d.Doctor_ID = p.Doctors_Doctor_ID
GROUP BY d.Doctor_ID, d.Doctor_First_Name, d.Doctor_Last_Name;


-- 6. View: Top-Selling Drugs
CREATE OR REPLACE VIEW Top_Selling_Drugs AS
SELECT
    d.Drug_ID,
    d.Drug_Name,
    SUM(st.Quantity_Sold) AS Total_Units_Sold,
    SUM(st.Total_Price) AS Total_Sales_Amount
FROM Sales_Transactions st
JOIN Drugs d ON st.Drugs_Drug_ID = d.Drug_ID
GROUP BY d.Drug_ID, d.Drug_Name
ORDER BY Total_Units_Sold DESC;


-- 7. View: Prescriptions Summary (with patient + doctor info)
CREATE OR REPLACE VIEW Prescription_Summary AS
SELECT
    pr.Prescription_ID,
    pr.Date_Issue,
    d.Doctor_First_Name || ' ' || d.Doctor_Last_Name AS Doctor_Name,
    pt.Patient_First_Name || ' ' || pt.Patient_Last_Name AS Patient_Name,
    pr.Status
FROM Prescriptions pr
JOIN Doctors d ON pr.Doctors_Doctor_ID = d.Doctor_ID
JOIN Patients pt ON pr.Patients_Patient_ID = pt.Patient_ID;


-- 8. View: Drugs Near Expiry (next 30 days)
CREATE OR REPLACE VIEW Drugs_Near_Expiry AS
SELECT
    Drug_ID,
    Drug_Name,
    Expiry_Date,
    Stock_Quantity
FROM Drugs
WHERE Expiry_Date BETWEEN SYSDATE AND SYSDATE + 30
ORDER BY Expiry_Date;

--9. View: Monthly Sales Report
CREATE OR REPLACE VIEW Monthly_Sales_Report AS
SELECT
    TRUNC(st.DATE_TIMESTAMP, 'MONTH') AS Sales_Month,  -- Corrected column name
    SUM(st.TOTAL_PRICE) AS Total_Sales_Amount,
    COUNT(st.TRANSACTION_ID) AS Total_Transactions
FROM Sales_Transactions st
GROUP BY TRUNC(st.DATE_TIMESTAMP, 'MONTH')
ORDER BY Sales_Month DESC;

--10. low stock view
CREATE OR REPLACE VIEW low_stock_drugs AS
SELECT 
  TO_CHAR(drug_id) AS drug_id,
  drug_name,
  stock_quantity,
  expiry_date
FROM drugs
WHERE stock_quantity < 10

UNION ALL

SELECT 
  'N/A' AS drug_id,
  'No drugs below low stock' AS drug_name,
  NULL AS stock_quantity,
  NULL AS expiry_date
FROM dual
WHERE NOT EXISTS (
  SELECT 1 FROM drugs WHERE stock_quantity < 10
);

--10. Monthly Report
CREATE OR REPLACE VIEW APP_ADMIN.MONTHLY_SALES_REPORT AS
SELECT
  TRUNC(st.DATE_TIMESTAMP, 'MONTH') AS sales_month,
  SUM(st.TOTAL_PRICE) AS total_sales_amount,
  COUNT(st.TRANSACTION_ID) AS total_transactions
FROM SALES_TRANSACTIONS st
GROUP BY TRUNC(st.DATE_TIMESTAMP, 'MONTH')
ORDER BY sales_month DESC;

--11. Drug wise sales
CREATE OR REPLACE VIEW Drug_Wise_Sales_Summary AS
SELECT
    d.Drug_ID,
    d.Drug_Name,
    SUM(st.Quantity_Sold) AS Total_Quantity_Sold,
    SUM(st.Total_Price) AS Total_Sales_Amount
FROM
    Drugs d
JOIN
    Sales_Transactions st ON d.Drug_ID = st.Drugs_Drug_ID
GROUP BY
    d.Drug_ID, d.Drug_Name
ORDER BY
    Total_Quantity_Sold DESC;


-- 1. Check Current Inventory Status
SELECT * FROM Current_Inventory_Status;
-- Expect: List of all drugs with stock status ('LOW STOCK' or 'SUFFICIENT')

-- 2. Skip View 2 (Placeholder for Product_Wise_Price_Changes)

-- 3. Total Sales Region-wise
SELECT * FROM Total_Sales_Region_Wise;
-- Expect: Supplier city/state with aggregated sales and transaction counts

-- 4. Weekly Sales Report
SELECT * FROM Week_Wise_Sales;
-- Expect: Sales grouped by week start date

-- 5. Doctor-wise Prescription Count
SELECT * FROM Doctor_Prescription_Count;
-- Expect: List of doctors and how many prescriptions each issued

-- 6. Top-Selling Drugs
SELECT * FROM Top_Selling_Drugs;
-- Expect: Drugs sorted by units sold

-- 7. Prescription Summary
SELECT * FROM Prescription_Summary;
-- Expect: Each prescription with doctor and patient names, and status

-- 8. Drugs Near Expiry
SELECT * FROM Drugs_Near_Expiry;
-- Expect: Drugs that are expiring within the next 30 days

-- 9. Monthly Sales Report
SELECT * FROM Monthly_Sales_Report;
-- Expect: Sales grouped by month

-- 10. Low Stock View
SELECT * FROM low_stock_drugs;
-- Expect: Drugs with quantity < 10 OR message "No drugs below low stock"
