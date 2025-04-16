-- PIMS TEST CASES SCRIPT
-- Covers insert, update, delete, and error-handling scenarios
-- Each block is runnable and follows business rules

-- 1. Insert new patient (valid email)
BEGIN
  APP_TRANSACTIONS.insert_patient(
    p_first_name     => 'Neha',
    p_last_name      => 'Sharma',
    p_contact_number => '9876543210',
    p_email          => 'neha.sharma@example.com',
    p_street         => '12 Green Lane',
    p_city           => 'Mumbai',
    p_state          => 'MH',
    p_zipcode        => 400001,
    p_created_by     => 1
  );
END;
/

-- 2. Insert patient (invalid email)
BEGIN
  APP_TRANSACTIONS.insert_patient(
    p_first_name     => 'Invalid',
    p_last_name      => 'Email',
    p_contact_number => '9876543210',
    p_email          => 'wrong-format',
    p_street         => '404 Nowhere',
    p_city           => 'GhostTown',
    p_state          => 'ZZ',
    p_zipcode        => 999999,
    p_created_by     => 1
  );
END;
/
-- Expected: ORA-20010 (Invalid email format)
DECLARE
  v_prescription_id NUMBER;
BEGIN
  APP_TRANSACTIONS.insert_prescription(
    p_patient_id      => 101,
    p_doctor_id       => 1,
    p_date_issue      => SYSDATE,
    p_status          => 'Active',
    p_created_by      => 1,
    p_prescription_id => v_prescription_id
  );

  APP_TRANSACTIONS.insert_prescription_drug(
    p_prescription_id => v_prescription_id,
    p_drug_id         => 103,  -- must be expired
    p_quantity        => 5
  );
END;
/

-- 4. Insert sales transaction with mismatched total price
BEGIN
  APP_TRANSACTIONS.insert_sales_transaction(
    p_payment_id     => 1,
    p_date_sold      => SYSTIMESTAMP,
    p_quantity_sold  => 10,
    p_total_price    => 100,  -- incorrect (price * quantity mismatch)
    p_drug_id        => 101,
    p_user_id        => 2,
    p_created_by     => 1
  );
END;
/
-- Expected: ORA-20004 (Total price mismatch)

-- 5. Insert valid inventory log (ADD)
BEGIN
  APP_TRANSACTIONS.insert_inventory_log(
    p_change_type   => 'ADD',
    p_change_amount => 20,
    p_drug_id       => 101,
    p_user_id       => 2
  );
END;
/
-- Expected: Insert successful, stock updated

-- 6. Insert valid inventory log (REMOVE)
BEGIN
  APP_TRANSACTIONS.insert_inventory_log(
    p_change_type   => 'REMOVE',
    p_change_amount => 5,
    p_drug_id       => 101,
    p_user_id       => 2
  );
END;
/
-- Expected: Insert successful, stock reduced

-- 7. Insert inventory log with invalid change type
BEGIN
  APP_TRANSACTIONS.insert_inventory_log(
    p_change_type   => 'RETURN',
    p_change_amount => 5,
    p_drug_id       => 101,
    p_user_id       => 2
  );
END;
/
-- Expected: ORA-20003 (Invalid CHANGE_TYPE. Only 'ADD' and 'REMOVE' are allowed.)

-- 8. Check available quantity (function)
SELECT fn_get_drug_details(101) AS available_qty FROM dual;

-- 9. Top selling drug
SELECT fn_top_selling_drug_info() AS top_seller_id FROM dual;

-- 10. Total sales in date range
SELECT fn_get_sales_report(
  101,
  TO_DATE('2024-01-01', 'YYYY-MM-DD'),
  TO_DATE('2025-12-31', 'YYYY-MM-DD')
) AS report
FROM dual;
-- 11. Update drug info (test audit trigger)
SET SERVEROUTPUT ON

BEGIN
  DBMS_SESSION.SET_IDENTIFIER('2');
  UPDATE drugs
  SET price = price + 5
  WHERE drug_id = 10 AND price + 5 <= mrp;
END;
/
