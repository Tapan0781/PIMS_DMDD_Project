-- Enable output
SET SERVEROUTPUT ON;

-- Select data from the Monthly Sales Report view
SELECT 
  TO_CHAR(Sales_Month, 'Mon YYYY') AS "Month",
  Total_Sales_Amount,
  Total_Transactions
FROM APP_ADMIN.Monthly_Sales_Report
ORDER BY Sales_Month DESC;
