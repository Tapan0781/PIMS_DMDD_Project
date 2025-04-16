CREATE OR REPLACE FUNCTION fn_get_drug_details (
  p_drug_id IN NUMBER
) RETURN VARCHAR2 IS
  v_drug_name VARCHAR2(255);
  v_qty       NUMBER;
  v_output    VARCHAR2(500);
BEGIN
  SELECT drug_name, stock_quantity
  INTO v_drug_name, v_qty
  FROM drugs
  WHERE drug_id = p_drug_id;

  v_output := 'Drug ID: ' || p_drug_id || 
              ', Name: ' || v_drug_name || 
              ', Available Qty: ' || v_qty;

  RETURN v_output;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'Drug ID ' || p_drug_id || ' not found.';
  WHEN OTHERS THEN
    RETURN 'Unexpected error: ' || SQLERRM;
END;
/


-- Assume drug_id 101 exists
SELECT fn_get_drug_details(120) AS available_quantity FROM dual;


CREATE OR REPLACE FUNCTION fn_get_sales_report (
  p_drug_id    IN NUMBER,
  p_start_date IN DATE,
  p_end_date   IN DATE
) RETURN VARCHAR2 IS
  v_total_qty   NUMBER := 0;
  v_total_value NUMBER := 0;
  v_result      VARCHAR2(500);
BEGIN
  SELECT
    NVL(SUM(quantity_sold), 0),
    NVL(SUM(total_price), 0)
  INTO
    v_total_qty,
    v_total_value
  FROM
    sales_transactions
  WHERE
    drugs_drug_id = p_drug_id
    AND date_timestamp BETWEEN p_start_date AND p_end_date;

  v_result := 'Drug ID: ' || p_drug_id ||
              ', Total Qty Sold: ' || v_total_qty ||
              ', Total Sales: $' || TO_CHAR(v_total_value, '99990.00');

  RETURN v_result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No sales found for Drug ID ' || p_drug_id;
  WHEN OTHERS THEN
    RETURN 'Error: ' || SQLERRM;
END;
/




--INSERT INTO sales_transactions (
--  transaction_id,
--  payment_id,
--  date_timestamp,
--  quantity_sold,
--  total_price,
--  drugs_drug_id,
--  users_user_id,
--  created_on,
--  created_by
--) VALUES (
--  SALES_TRANSACTIONS_SEQ.NEXTVAL, -- Auto-generated
--  1,                              -- Payment method ID
--  SYSTIMESTAMP,                   -- Current time
--  10,                             -- Quantity sold
--  150.00,                         -- Total price in USD
--  101,                            -- Drug ID
--  1,                              -- User ID
--  SYSTIMESTAMP,
--  1
--);
--
--
--commit;
--
--
--SELECT fn_get_sales_report(
--  101,
--  TO_DATE('2024-01-01', 'YYYY-MM-DD'),
--  TO_DATE('2025-12-31', 'YYYY-MM-DD')
--) AS report
--FROM dual;
--
--select * from drugs where drug_id = 101;
--
--
--INSERT INTO sales_transactions (
--  transaction_id,
--  payment_id,
--  date_timestamp,
--  quantity_sold,
--  total_price,
--  drugs_drug_id,
--  users_user_id,
--  created_on,
--  created_by
--) VALUES (
--  SALES_TRANSACTIONS_SEQ.NEXTVAL, -- Auto-generated
--  1,                              -- Payment method ID
--  SYSTIMESTAMP,                   -- Current time
--  10,                             -- Quantity sold
--  150.00,                         -- Total price in USD
--  101,                            -- Drug ID
--  1,                              -- User ID
--  SYSTIMESTAMP,
--  1
--);
--
--commit;


---Top Selling Drug
CREATE OR REPLACE FUNCTION fn_top_selling_drug_info
RETURN VARCHAR2 IS
  v_drug_id   NUMBER;
  v_drug_name VARCHAR2(255);
  v_total_qty NUMBER;
  v_result    VARCHAR2(500);
BEGIN
  -- Get top-selling drug ID and quantity sold
  SELECT drugs_drug_id, SUM(quantity_sold)
  INTO v_drug_id, v_total_qty
  FROM sales_transactions
  GROUP BY drugs_drug_id
  ORDER BY SUM(quantity_sold) DESC
  FETCH FIRST 1 ROWS ONLY;

  -- Get the drug name using the ID
  SELECT drug_name INTO v_drug_name FROM drugs WHERE drug_id = v_drug_id;

  -- Compose final output string
  v_result := 'Drug ID: ' || v_drug_id ||
              ', Name: ' || v_drug_name ||
              ', Total Qty Sold: ' || v_total_qty;

  RETURN v_result;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'No sales data available.';
  WHEN OTHERS THEN
    RETURN 'Error: ' || SQLERRM;
END;
/

SELECT fn_top_selling_drug_info() AS top_seller_id FROM dual;





----------------
---Monthly Sales Report

CREATE OR REPLACE FUNCTION get_monthly_sales_report(p_month IN VARCHAR2)
RETURN SYS_REFCURSOR
IS
  v_month_start DATE;
  v_month_end   DATE;
  sales_cursor  SYS_REFCURSOR;
BEGIN
  -- Convert input to first day of month
  v_month_start := TO_DATE(p_month, 'YYYY-MM');
  -- Get last day of the month
  v_month_end := LAST_DAY(v_month_start);

  OPEN sales_cursor FOR
    SELECT 
      TRUNC(DATE_TIMESTAMP, 'MONTH') AS Sales_Month,
      SUM(TOTAL_PRICE) AS Total_Sales_Amount,
      COUNT(TRANSACTION_ID) AS Total_Transactions
    FROM SALES_TRANSACTIONS
    WHERE DATE_TIMESTAMP BETWEEN v_month_start AND v_month_end
    GROUP BY TRUNC(DATE_TIMESTAMP, 'MONTH');

  RETURN sales_cursor;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in get_monthly_sales_report: ' || SQLERRM);
    RETURN NULL;
END;
/




--Ex
SET SERVEROUTPUT ON;
DECLARE
  cur SYS_REFCURSOR;
  v_month DATE;
  v_sales_amt NUMBER;
  v_txns NUMBER;
  v_found BOOLEAN := FALSE;
BEGIN
  -- Call the function with month input in 'YYYY-MM' format
  cur := get_monthly_sales_report('2025-03');

  LOOP
    FETCH cur INTO v_month, v_sales_amt, v_txns;
    EXIT WHEN cur%NOTFOUND;

    -- Set flag to true if any data is returned
    v_found := TRUE;

    DBMS_OUTPUT.PUT_LINE('Month: ' || TO_CHAR(v_month, 'Month YYYY') ||
                         ' | Total Sales: ' || v_sales_amt || 
                         ' | Transactions: ' || v_txns);
  END LOOP;

  IF NOT v_found THEN
    DBMS_OUTPUT.PUT_LINE('No data found for the selected month.');
  END IF;

  CLOSE cur;
END;
/
