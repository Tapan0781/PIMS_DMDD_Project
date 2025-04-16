-- PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE APP_TRANSACTIONS AS
  PROCEDURE insert_patient (
    p_first_name     IN VARCHAR2,
    p_last_name      IN VARCHAR2,
    p_contact_number IN VARCHAR2,
    p_email          IN VARCHAR2,
    p_street         IN VARCHAR2,
    p_city           IN VARCHAR2,
    p_state          IN VARCHAR2,
    p_zipcode        IN NUMBER,
    p_created_by     IN NUMBER
  );

  PROCEDURE insert_prescription (
  p_patient_id       IN NUMBER,
  p_doctor_id        IN NUMBER,
  p_date_issue       IN DATE,
  p_status           IN VARCHAR2,
  p_created_by       IN NUMBER,
  p_prescription_id  OUT NUMBER
);

  PROCEDURE insert_prescription_drug (
    p_prescription_id  IN NUMBER,
    p_drug_id          IN NUMBER,
    p_quantity         IN NUMBER
  );

  PROCEDURE insert_sales_transaction (
    p_payment_id      IN NUMBER,
    p_date_sold       IN TIMESTAMP,
    p_quantity_sold   IN NUMBER,
    p_total_price     IN NUMBER,
    p_drug_id         IN NUMBER,
    p_user_id         IN NUMBER,
    p_created_by      IN NUMBER
  );

  PROCEDURE insert_inventory_log (
    p_change_type   IN VARCHAR2,
    p_change_amount IN NUMBER,
    p_drug_id       IN NUMBER,
    p_user_id       IN NUMBER
  );
END APP_TRANSACTIONS;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY APP_TRANSACTIONS AS

  FUNCTION is_valid_email(p_email IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  END;

  PROCEDURE insert_patient (
    p_first_name     IN VARCHAR2,
    p_last_name      IN VARCHAR2,
    p_contact_number IN VARCHAR2,
    p_email          IN VARCHAR2,
    p_street         IN VARCHAR2,
    p_city           IN VARCHAR2,
    p_state          IN VARCHAR2,
    p_zipcode        IN NUMBER,
    p_created_by     IN NUMBER
  ) IS
  BEGIN
    IF p_email IS NOT NULL AND NOT is_valid_email(p_email) THEN
      RAISE_APPLICATION_ERROR(-20010, 'Invalid email format');
    END IF;

    INSERT INTO PATIENTS (
      PATIENT_FIRST_NAME, PATIENT_LAST_NAME, PATIENT_CONTACT_NUMBER,
      PATIENT_EMAIL, PATIENT_STREET, PATIENT_CITY, PATIENT_STATE, PATIENT_ZIPCODE,
      CREATED_ON, CREATED_BY
    ) VALUES (
      p_first_name, p_last_name, p_contact_number,
      p_email, p_street, p_city, p_state, p_zipcode, SYSTIMESTAMP, p_created_by
    );

    DBMS_OUTPUT.PUT_LINE('Patient inserted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inserting patient: ' || SQLERRM);
  END insert_patient;

  PROCEDURE insert_prescription (
  p_patient_id       IN NUMBER,
  p_doctor_id        IN NUMBER,
  p_date_issue       IN DATE,
  p_status           IN VARCHAR2,
  p_created_by       IN NUMBER,
  p_prescription_id  OUT NUMBER
) IS
  v_patient_exists NUMBER;
  v_doctor_exists  NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_patient_exists FROM PATIENTS WHERE PATIENT_ID = p_patient_id;
  IF v_patient_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Patient ID does not exist');
  END IF;

  SELECT COUNT(*) INTO v_doctor_exists FROM DOCTORS WHERE DOCTOR_ID = p_doctor_id;
  IF v_doctor_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Doctor ID does not exist');
  END IF;

  -- Generate ID using sequence
  SELECT PRESCRIPTIONS_SEQ.NEXTVAL INTO p_prescription_id FROM dual;

  -- Insert new prescription
  INSERT INTO PRESCRIPTIONS (
    PRESCRIPTION_ID, PATIENTS_PATIENT_ID, DOCTORS_DOCTOR_ID, DATE_ISSUE, STATUS,
    CREATED_ON, CREATED_BY
  ) VALUES (
    p_prescription_id, p_patient_id, p_doctor_id, p_date_issue, p_status,
    SYSTIMESTAMP, p_created_by
  );

  DBMS_OUTPUT.PUT_LINE('Prescription inserted with ID: ' || p_prescription_id);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting prescription: ' || SQLERRM);
END insert_prescription;

  PROCEDURE insert_prescription_drug (
  p_prescription_id  IN NUMBER,
  p_drug_id          IN NUMBER,
  p_quantity         IN NUMBER
) IS
  v_prescription_exists NUMBER;
  v_drug_exists         NUMBER;
  v_expiry_date         DATE;
BEGIN
  -- Validate prescription
  SELECT COUNT(*) INTO v_prescription_exists
  FROM PRESCRIPTIONS
  WHERE PRESCRIPTION_ID = p_prescription_id;

  IF v_prescription_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Prescription ID does not exist');
  END IF;

  -- Validate drug
  SELECT COUNT(*) INTO v_drug_exists
  FROM DRUGS
  WHERE DRUG_ID = p_drug_id;

  IF v_drug_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Drug ID does not exist');
  END IF;

  -- 🔒 Check for expiration
  SELECT expiry_date INTO v_expiry_date
  FROM DRUGS
  WHERE DRUG_ID = p_drug_id;

  IF v_expiry_date < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20003, 'Cannot prescribe expired drug.');
  END IF;

  -- Insert valid prescription drug
  INSERT INTO PRESCRIPTION_DRUGS (
    PRESCRIPTIONS_PRESCRIPTION_ID,
    DRUGS_DRUG_ID,
    QUANTITY
  ) VALUES (
    p_prescription_id,
    p_drug_id,
    p_quantity
  );

  DBMS_OUTPUT.PUT_LINE('Prescription drug inserted successfully');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting prescription drug: ' || SQLERRM);
END insert_prescription_drug;

PROCEDURE insert_sales_transaction (
  p_payment_id      IN NUMBER,
  p_date_sold       IN TIMESTAMP,
  p_quantity_sold   IN NUMBER,
  p_total_price     IN NUMBER,
  p_drug_id         IN NUMBER,
  p_user_id         IN NUMBER,
  p_created_by      IN NUMBER
) IS
  v_payment_exists  NUMBER;
  v_user_exists     NUMBER;
  v_drug_exists     NUMBER;
  v_unit_price      NUMBER;
  v_expected_total  NUMBER;
BEGIN
  -- Validate Payment
  SELECT COUNT(*) INTO v_payment_exists FROM PAYMENT_METHOD WHERE PAYMENT_ID = p_payment_id;
  IF v_payment_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Payment ID does not exist');
  END IF;

  -- Validate User
  SELECT COUNT(*) INTO v_user_exists FROM USERS WHERE USER_ID = p_user_id;
  IF v_user_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'User ID does not exist');
  END IF;

  -- Validate Drug
  SELECT COUNT(*) INTO v_drug_exists FROM DRUGS WHERE DRUG_ID = p_drug_id;
  IF v_drug_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Drug ID does not exist');
  END IF;

  -- Fetch unit price of the drug
  SELECT price INTO v_unit_price FROM DRUGS WHERE DRUG_ID = p_drug_id;
  v_expected_total := p_quantity_sold * v_unit_price;

  -- Validate total price
  IF ABS(p_total_price - v_expected_total) > 0.01 THEN
    RAISE_APPLICATION_ERROR(-20004,
      'Total price mismatch. Expected: ' || TO_CHAR(v_expected_total, '99990.00') ||
      ', Provided: ' || TO_CHAR(p_total_price, '99990.00')
    );
  END IF;

  -- Insert valid transaction
  INSERT INTO SALES_TRANSACTIONS (
    PAYMENT_ID, DATE_TIMESTAMP, QUANTITY_SOLD, TOTAL_PRICE,
    DRUGS_DRUG_ID, USERS_USER_ID, CREATED_ON, CREATED_BY
  ) VALUES (
    p_payment_id, p_date_sold, p_quantity_sold, p_total_price,
    p_drug_id, p_user_id, SYSTIMESTAMP, p_created_by
  );

  DBMS_OUTPUT.PUT_LINE('Sales transaction inserted successfully');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting sales transaction: ' || SQLERRM);
END insert_sales_transaction;

  -- Enhanced Inventory Log Procedure (with ADD/REMOVE only constraint)
PROCEDURE insert_inventory_log (
  p_change_type   IN VARCHAR2,
  p_change_amount IN NUMBER,
  p_drug_id       IN NUMBER,
  p_user_id       IN NUMBER
) IS
  v_drug_exists    NUMBER;
  v_user_exists    NUMBER;
  v_current_stock  NUMBER;
  v_new_stock      NUMBER;
BEGIN
  -- Validate drug
  SELECT COUNT(*) INTO v_drug_exists FROM DRUGS WHERE DRUG_ID = p_drug_id;
  IF v_drug_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Drug ID does not exist');
  END IF;

  -- Validate user
  SELECT COUNT(*) INTO v_user_exists FROM USERS WHERE USER_ID = p_user_id;
  IF v_user_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'User ID does not exist');
  END IF;

  -- Enforce allowed change types
  IF UPPER(p_change_type) NOT IN ('ADD', 'REMOVE') THEN
    RAISE_APPLICATION_ERROR(-20003, 'Invalid CHANGE_TYPE. Only ''ADD'' and ''REMOVE'' are allowed.');
  END IF;

  -- Get current stock
  SELECT stock_quantity INTO v_current_stock FROM DRUGS WHERE DRUG_ID = p_drug_id;

  -- Calculate new stock
    IF UPPER(p_change_type) = 'ADD' THEN
    v_new_stock := v_current_stock + p_change_amount;
    ELSIF UPPER(p_change_type) = 'REMOVE' THEN
    v_new_stock := v_current_stock - p_change_amount;
    ELSE
    RAISE_APPLICATION_ERROR(-20003, 'Invalid CHANGE_TYPE. Only ''ADD'' and ''REMOVE'' are allowed.');
    END IF;
  -- Update stock in DRUGS table
  UPDATE DRUGS
  SET stock_quantity = v_new_stock,
      updated_on     = SYSTIMESTAMP,
      updated_by     = TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
  WHERE DRUG_ID = p_drug_id;

  -- Insert into log
  INSERT INTO INVENTORY_LOGS (
    CHANGE_TYPE, CHANGE_AMOUNT, CHANGE_DATE,
    DRUGS_DRUG_ID, USERS_USER_ID
  ) VALUES (
    UPPER(p_change_type), p_change_amount, SYSTIMESTAMP,
    p_drug_id, p_user_id
  );

  -- Alert if stock falls below threshold
  IF v_new_stock < 10 THEN
    DBMS_OUTPUT.PUT_LINE('️ Warning: Stock for Drug ID ' || p_drug_id || ' is low (' || v_new_stock || ' units).');
  END IF;

  DBMS_OUTPUT.PUT_LINE(' Inventory log inserted successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Error inserting inventory log: ' || SQLERRM);
END insert_inventory_log;

END APP_TRANSACTIONS;
/
--
--
BEGIN
  APP_TRANSACTIONS.insert_patient(
    p_first_name     => 'Invalid',
    p_last_name      => 'Email',
    p_contact_number => '9876543211',
    p_email          => 'not-an-email',  
    p_street         => '404 Error Lane',
    p_city           => 'NullCity',
    p_state          => 'Void',
    p_zipcode        => 999999,
    p_created_by     => 1
  );
END;
/
-- ️ ORA-20010: Invalid email format

--Validate Total Price Match 
BEGIN
  APP_TRANSACTIONS.insert_sales_transaction(
    p_payment_id     => 1,
    p_date_sold      => SYSTIMESTAMP,
    p_quantity_sold  => 10,
    p_total_price    => 100,  -- must equal (unit price × 10)
    p_drug_id        => 101,  -- must exist
    p_user_id        => 2,    -- must exist
    p_created_by     => 1
  );
END;
/


BEGIN
  APP_TRANSACTIONS.insert_inventory_log(
    p_change_type   => 'REMOVE',
    p_change_amount => 5,
    p_drug_id       => 101,
    p_user_id       => 1
  );
END;
/
-- Expected: Inventory log inserted successfully
-- + low stock warning if stock falls below 10


BEGIN
  APP_TRANSACTIONS.insert_inventory_log(
    p_change_type   => 'RETURN',
    p_change_amount => 5,
    p_drug_id       => 101,
    p_user_id       => 1
  );
END;
/
-- Expected: ❌ ORA-20003: Invalid CHANGE_TYPE. Only 'ADD' and 'REMOVE' are allowed.





