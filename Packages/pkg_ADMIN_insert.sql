CREATE OR REPLACE PACKAGE APP_ADMIN AS
  -- Package constants
  c_email_regex CONSTANT VARCHAR2(100) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
  c_phone_regex CONSTANT VARCHAR2(50) := '^\d{10,15}$';  -- Allows 10-15 digit phone numbers

  -- Procedure declarations
  PROCEDURE insert_user (
    p_user_name           IN VARCHAR2,
    p_role                IN VARCHAR2,
    p_user_contact_number IN VARCHAR2,
    p_user_email          IN VARCHAR2,
    p_user_password       IN VARCHAR2,
    p_created_by          IN NUMBER
  );

  PROCEDURE insert_supplier (
    p_supplier_name           IN VARCHAR2,
    p_supplier_contact_number IN VARCHAR2,
    p_supplier_email          IN VARCHAR2,
    p_supplier_street         IN VARCHAR2,
    p_supplier_state          IN VARCHAR2,
    p_supplier_zipcode        IN NUMBER,
    p_supplier_city           IN VARCHAR2,
    p_created_by              IN NUMBER
  );

  PROCEDURE insert_catagory (
    p_catagory_name IN VARCHAR2,
    p_created_by    IN NUMBER
  );

  PROCEDURE insert_doctor (
    p_doctor_first_name     IN VARCHAR2,
    p_doctor_last_name      IN VARCHAR2,
    p_specialization        IN VARCHAR2,
    p_doctor_contact_number IN VARCHAR2,
    p_doctor_email          IN VARCHAR2,
    p_created_by            IN NUMBER
  );

  PROCEDURE insert_payment_method (
    p_payment_type IN VARCHAR2
  );

  PROCEDURE insert_drug (
    p_drug_name             IN VARCHAR2,
    p_expiry_date           IN DATE,
    p_mrp                   IN NUMBER,
    p_price                 IN NUMBER,
    p_stock_quantity        IN NUMBER,
    p_suppliers_supplier_id IN NUMBER,
    p_catagory_catagory_id  IN NUMBER,
    p_created_by            IN NUMBER
  );

  -- Helper functions
  FUNCTION validate_email(p_email IN VARCHAR2) RETURN BOOLEAN;
  FUNCTION validate_phone(p_phone IN VARCHAR2) RETURN BOOLEAN;
END APP_ADMIN;
/


-- Completed PACKAGE BODY for APP_ADMIN
CREATE OR REPLACE PACKAGE BODY APP_ADMIN AS

  FUNCTION validate_email(p_email IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN p_email IS NULL OR REGEXP_LIKE(p_email, c_email_regex);
  END validate_email;

  FUNCTION validate_phone(p_phone IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN p_phone IS NULL OR REGEXP_LIKE(p_phone, c_phone_regex);
  END validate_phone;

  PROCEDURE insert_user (
    p_user_name           IN VARCHAR2,
    p_role                IN VARCHAR2,
    p_user_contact_number IN VARCHAR2,
    p_user_email          IN VARCHAR2,
    p_user_password       IN VARCHAR2,
    p_created_by          IN NUMBER
  ) IS
  BEGIN
    IF p_user_name IS NULL OR p_role IS NULL OR
       p_user_email IS NULL OR p_user_password IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Required field cannot be null');
    END IF;

    IF NOT validate_email(p_user_email) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid email format');
    END IF;

    IF p_user_contact_number IS NOT NULL AND NOT validate_phone(p_user_contact_number) THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid phone format');
    END IF;

    INSERT INTO USERS (
      USER_NAME, ROLE, USER_CONTACT_NUMBER,
      USER_EMAIL, USER_PASSWORD, CREATED_ON, CREATED_BY
    ) VALUES (
      p_user_name, p_role, p_user_contact_number,
      p_user_email, p_user_password, SYSTIMESTAMP, p_created_by
    );

    DBMS_OUTPUT.PUT_LINE('User inserted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inserting user: ' || SQLERRM);
  END insert_user;

  PROCEDURE insert_supplier (
    p_supplier_name           IN VARCHAR2,
    p_supplier_contact_number IN VARCHAR2,
    p_supplier_email          IN VARCHAR2,
    p_supplier_street         IN VARCHAR2,
    p_supplier_state          IN VARCHAR2,
    p_supplier_zipcode        IN NUMBER,
    p_supplier_city           IN VARCHAR2,
    p_created_by              IN NUMBER
  ) IS
  BEGIN
    IF p_supplier_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Supplier Name cannot be null');
    END IF;

    IF p_supplier_email IS NOT NULL AND NOT validate_email(p_supplier_email) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid email format');
    END IF;

    IF p_supplier_contact_number IS NOT NULL AND NOT validate_phone(p_supplier_contact_number) THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid phone number format');
    END IF;

    INSERT INTO SUPPLIERS (
      SUPPLIER_NAME, SUPPLIER_CONTACT_NUMBER,
      SUPPLIER_EMAIL, SUPPLIER_STREET, SUPPLIER_STATE, SUPPLIER_ZIPCODE,
      SUPPLIER_CITY, CREATED_ON, CREATED_BY
    ) VALUES (
      p_supplier_name, p_supplier_contact_number,
      p_supplier_email, p_supplier_street, p_supplier_state,
      p_supplier_zipcode, p_supplier_city, SYSTIMESTAMP, p_created_by
    );

    DBMS_OUTPUT.PUT_LINE('Supplier inserted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inserting supplier: ' || SQLERRM);
  END insert_supplier;

  PROCEDURE insert_catagory (
  p_catagory_name IN VARCHAR2,
  p_created_by    IN NUMBER
) IS
  v_exists NUMBER;
BEGIN
  IF p_catagory_name IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Category Name cannot be null');
  END IF;

  -- Check if category already exists (case-insensitive)
  SELECT COUNT(*)
  INTO v_exists
  FROM CATAGORY
  WHERE UPPER(CATAGORY_NAME) = UPPER(p_catagory_name);

  IF v_exists > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Category "' || p_catagory_name || '" already exists.');
    RETURN;
  END IF;

  -- Insert new category
  INSERT INTO CATAGORY (
    CATAGORY_NAME, CREATED_ON, CREATED_BY
  ) VALUES (
    p_catagory_name, SYSTIMESTAMP, p_created_by
  );

  DBMS_OUTPUT.PUT_LINE('Category "' || p_catagory_name || '" inserted successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error inserting category: ' || SQLERRM);
END insert_catagory;

  PROCEDURE insert_doctor (
    p_doctor_first_name     IN VARCHAR2,
    p_doctor_last_name      IN VARCHAR2,
    p_specialization        IN VARCHAR2,
    p_doctor_contact_number IN VARCHAR2,
    p_doctor_email          IN VARCHAR2,
    p_created_by            IN NUMBER
  ) IS
  BEGIN
    IF p_doctor_first_name IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Doctor First Name cannot be null');
    END IF;

    IF p_doctor_email IS NOT NULL AND NOT validate_email(p_doctor_email) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid email format');
    END IF;

    IF p_doctor_contact_number IS NOT NULL AND NOT validate_phone(p_doctor_contact_number) THEN
      RAISE_APPLICATION_ERROR(-20003, 'Invalid phone number format');
    END IF;

    INSERT INTO DOCTORS (
      DOCTOR_FIRST_NAME, DOCTOR_LAST_NAME, SPECIALIZATION,
      DOCTOR_CONTACT_NUMBER, DOCTOR_EMAIL, CREATED_ON, CREATED_BY
    ) VALUES (
      p_doctor_first_name, p_doctor_last_name, p_specialization,
      p_doctor_contact_number, p_doctor_email, SYSTIMESTAMP, p_created_by
    );

    DBMS_OUTPUT.PUT_LINE('Doctor inserted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inserting doctor: ' || SQLERRM);
  END insert_doctor;

  PROCEDURE insert_payment_method (
    p_payment_type IN VARCHAR2
  ) IS
  BEGIN
    IF p_payment_type IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Payment Type cannot be null');
    END IF;

    INSERT INTO PAYMENT_METHOD (
      PAYMENT_TYPE
    ) VALUES (
      p_payment_type
    );

    DBMS_OUTPUT.PUT_LINE('Payment method inserted successfully');
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error inserting payment method: ' || SQLERRM);
  END insert_payment_method;

  PROCEDURE insert_drug (
    p_drug_name             IN VARCHAR2,
    p_expiry_date           IN DATE,
    p_mrp                   IN NUMBER,
    p_price                 IN NUMBER,
    p_stock_quantity        IN NUMBER,
    p_suppliers_supplier_id IN NUMBER,
    p_catagory_catagory_id  IN NUMBER,
    p_created_by            IN NUMBER
) IS
    v_supplier_exists   NUMBER;
    v_catagory_exists   NUMBER;
    v_existing_drug_id  NUMBER;
    v_new_batch_number  VARCHAR2(50);
BEGIN
    -- Validate mandatory inputs
    IF p_drug_name IS NULL OR
       p_expiry_date IS NULL OR
       p_mrp IS NULL OR
       p_price IS NULL OR
       p_stock_quantity IS NULL OR
       p_suppliers_supplier_id IS NULL OR
       p_catagory_catagory_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Required fields cannot be null');
    END IF;

    -- Validate expiry
    IF p_expiry_date <= SYSDATE THEN
      RAISE_APPLICATION_ERROR(-20006, 'Expiry date must be in the future');
    END IF;

    -- Validate numeric values
    IF p_mrp <= 0 OR p_price <= 0 OR p_stock_quantity < 0 THEN
      RAISE_APPLICATION_ERROR(-20007, 'Invalid MRP, price or stock values');
    END IF;

    -- Validate foreign keys
    SELECT COUNT(*) INTO v_supplier_exists FROM SUPPLIERS WHERE SUPPLIER_ID = p_suppliers_supplier_id;
    IF v_supplier_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20008, 'Supplier ID does not exist');
    END IF;

    SELECT COUNT(*) INTO v_catagory_exists FROM CATAGORY WHERE CATAGORY_ID = p_catagory_catagory_id;
    IF v_catagory_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20009, 'Category ID does not exist');
    END IF;

    -- Check if drug name already exists
    BEGIN
      SELECT DRUG_ID INTO v_existing_drug_id
      FROM DRUGS
      WHERE UPPER(DRUG_NAME) = UPPER(p_drug_name);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_existing_drug_id := NULL;
    END;

    IF v_existing_drug_id IS NOT NULL THEN
      -- Drug exists — perform UPDATE
      UPDATE DRUGS
      SET
        EXPIRY_DATE           = p_expiry_date,
        MRP                   = p_mrp,
        PRICE                 = p_price,
        STOCK_QUANTITY        = p_stock_quantity,
        SUPPLIERS_SUPPLIER_ID = p_suppliers_supplier_id,
        CATAGORY_CATAGORY_ID  = p_catagory_catagory_id,
        UPDATED_ON            = SYSTIMESTAMP,
        UPDATED_BY            = TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
      WHERE DRUG_ID = v_existing_drug_id;

      DBMS_OUTPUT.PUT_LINE('Drug "' || p_drug_name || '" updated successfully.');
    ELSE
      -- Drug does not exist — perform INSERT
      -- Auto-generate batch number as: DRUG_<timestamp>
      v_new_batch_number := 'BATCH_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

      INSERT INTO DRUGS (
        DRUG_NAME, BATCH_NUMBER, EXPIRY_DATE, MRP, PRICE,
        STOCK_QUANTITY, SUPPLIERS_SUPPLIER_ID, CATAGORY_CATAGORY_ID,
        CREATED_ON, CREATED_BY
      ) VALUES (
        p_drug_name, v_new_batch_number, p_expiry_date, p_mrp, p_price,
        p_stock_quantity, p_suppliers_supplier_id, p_catagory_catagory_id,
        SYSTIMESTAMP, p_created_by
      );

      DBMS_OUTPUT.PUT_LINE('Drug "' || p_drug_name || '" inserted with Batch: ' || v_new_batch_number);
    END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in insert_drug: ' || SQLERRM);
END insert_drug;

END APP_ADMIN;
/
--
--
--BEGIN
--  APP_ADMIN.insert_user(
--    p_user_name           => 'Aarav Patel',
--    p_role                => 'pharmacist',
--    p_user_contact_number => '9876543210',
--    p_user_email          => 'aarav.patel@example.com',
--    p_user_password       => 'Secure@123',
--    p_created_by          => 1
--  );
--END;
--/
--
--
--
--BEGIN
--  APP_ADMIN.insert_user(
--    p_user_id             => 999,
--    p_user_name           => 'Invalid User',
--    p_role                => 'admin',
--    p_user_contact_number => '9876543210',
--    p_user_email          => NULL,  
--    p_user_password       => 'Pass123',
--    p_created_by          => 1
--  );
--END;
--/
----  Expected Error: ORA-20001: Required field cannot be null
--
--BEGIN
--  APP_ADMIN.insert_drug(
--    p_drug_id               => 7777,
--    p_drug_name             => 'ExpiredMed',
--    p_batch_number          => 'B000X',
--    p_expiry_date           => TO_DATE('2022-01-01', 'YYYY-MM-DD'),  -- 💥 Already expired
--    p_mrp                   => 100,
--    p_price                 => 80,
--    p_stock_quantity        => 50,
--    p_suppliers_supplier_id => 2001,  -- must exist
--    p_catagory_catagory_id  => 301,   -- must exist
--    p_created_by            => 1
--  );
--END;
--/


SET SERVEROUTPUT ON;

BEGIN
  APP_ADMIN.insert_drug(
    p_drug_name             => 'Azithromycin 500mg',
    p_expiry_date           => TO_DATE('2026-12-31', 'YYYY-MM-DD'),
    p_mrp                   => 120,
    p_price                 => 100,
    p_stock_quantity        => 30,
    p_suppliers_supplier_id => 1,   -- Make sure supplier_id 1 exists
    p_catagory_catagory_id  => 1,   -- Make sure category_id 1 exists
    p_created_by            => 1
  );
END;
/


SET SERVEROUTPUT ON;

BEGIN
  APP_ADMIN.insert_drug(
    p_drug_name             => 'Montelukast 10mg',
    p_expiry_date           => TO_DATE('2026-09-15', 'YYYY-MM-DD'),
    p_mrp                   => 90,
    p_price                 => 75,
    p_stock_quantity        => 50,
    p_suppliers_supplier_id => 2,  -- Ensure this supplier exists
    p_catagory_catagory_id  => 2,  -- Ensure this category exists
    p_created_by            => 1
  );
END;
/
