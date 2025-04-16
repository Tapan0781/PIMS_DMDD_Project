CREATE OR REPLACE PROCEDURE delete_prescription (
  p_prescription_id IN NUMBER
) AS
  v_exists NUMBER;
BEGIN
  -- Check if prescription exists
  SELECT COUNT(*) INTO v_exists 
  FROM PRESCRIPTIONS 
  WHERE PRESCRIPTION_ID = p_prescription_id;

  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Prescription ID does not exist.');
  END IF;

  -- First delete from PRESCRIPTION_DRUGS (child table)
  DELETE FROM PRESCRIPTION_DRUGS 
  WHERE PRESCRIPTIONS_PRESCRIPTION_ID = p_prescription_id;

  -- Then delete from PRESCRIPTIONS
  DELETE FROM PRESCRIPTIONS 
  WHERE PRESCRIPTION_ID = p_prescription_id;

  DBMS_OUTPUT.PUT_LINE('Prescription and associated drugs deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting prescription: ' || SQLERRM);
    RAISE;
END;
/

BEGIN
  delete_prescription(p_prescription_id => 101);  -- Replace with actual ID
END;
/

-----------------------
CREATE OR REPLACE PROCEDURE delete_drug(p_drug_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  -- Step 1: Check if the Drug ID exists
  SELECT COUNT(*) INTO v_exists FROM DRUGS WHERE DRUG_ID = p_drug_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Drug ID does not exist.');
  END IF;

  -- Step 2: Delete child records from Prescription_Drugs (if any)
  DELETE FROM PRESCRIPTION_DRUGS
  WHERE DRUGS_DRUG_ID = p_drug_id;

  -- Step 3: Delete child records from Sales_Transactions (if any)
  DELETE FROM SALES_TRANSACTIONS
  WHERE DRUGS_DRUG_ID = p_drug_id;

  -- Step 4: Delete child records from Inventory_Logs (if any)
  DELETE FROM INVENTORY_LOGS
  WHERE DRUGS_DRUG_ID = p_drug_id;

  -- Step 5: Delete the drug
  DELETE FROM DRUGS
  WHERE DRUG_ID = p_drug_id;

  -- Step 6: Output success message
  DBMS_OUTPUT.PUT_LINE(' Drug with ID ' || p_drug_id || ' deleted successfully.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Error deleting drug: ' || SQLERRM);
END;
/

BEGIN
  delete_drug(100); -- Replace 100 with an actual Drug_ID
END;
/



---Delete supplier
CREATE OR REPLACE PROCEDURE delete_supplier(p_supplier_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM SUPPLIERS WHERE SUPPLIER_ID = p_supplier_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Supplier ID does not exist.');
  END IF;

  -- Delete dependent drugs
  DELETE FROM DRUGS WHERE SUPPLIERS_SUPPLIER_ID = p_supplier_id;

  -- Delete the supplier
  DELETE FROM SUPPLIERS WHERE SUPPLIER_ID = p_supplier_id;

  DBMS_OUTPUT.PUT_LINE(' Supplier with ID ' || p_supplier_id || ' deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Error deleting supplier: ' || SQLERRM);
END;
/






---Delete doctor

CREATE OR REPLACE PROCEDURE delete_doctor(p_doctor_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM DOCTORS WHERE DOCTOR_ID = p_doctor_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Doctor ID does not exist.');
  END IF;

  -- Delete dependent prescriptions
  DELETE FROM PRESCRIPTIONS WHERE DOCTORS_DOCTOR_ID = p_doctor_id;

  -- Delete the doctor
  DELETE FROM DOCTORS WHERE DOCTOR_ID = p_doctor_id;

  DBMS_OUTPUT.PUT_LINE(' Doctor with ID ' || p_doctor_id || ' deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Error deleting doctor: ' || SQLERRM);
END;
/



--Delete Patients
CREATE OR REPLACE PROCEDURE delete_patient(p_patient_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM PATIENTS WHERE PATIENT_ID = p_patient_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Patient ID does not exist.');
  END IF;

  -- Delete dependent prescriptions
  DELETE FROM PRESCRIPTIONS WHERE PATIENTS_PATIENT_ID = p_patient_id;

  -- Delete the patient
  DELETE FROM PATIENTS WHERE PATIENT_ID = p_patient_id;

  DBMS_OUTPUT.PUT_LINE(' Patient with ID ' || p_patient_id || ' deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(' Error deleting patient: ' || SQLERRM);
END;
/



---Delete catagory

CREATE OR REPLACE PROCEDURE delete_catagory(p_catagory_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM CATAGORY WHERE CATAGORY_ID = p_catagory_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Category ID does not exist.');
  END IF;

  DELETE FROM CATAGORY WHERE CATAGORY_ID = p_catagory_id;
  DBMS_OUTPUT.PUT_LINE('Category deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting category: ' || SQLERRM);
END;
/




--Delete Inventory logs
CREATE OR REPLACE PROCEDURE delete_inventory_log(p_log_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM INVENTORY_LOGS WHERE LOG_ID = p_log_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Inventory Log ID does not exist.');
  END IF;

  DELETE FROM INVENTORY_LOGS WHERE LOG_ID = p_log_id;
  DBMS_OUTPUT.PUT_LINE('Inventory log deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting inventory log: ' || SQLERRM);
END;
/


--Delete Sales_Transaction

CREATE OR REPLACE PROCEDURE delete_sales_transaction(p_transaction_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM SALES_TRANSACTIONS WHERE TRANSACTION_ID = p_transaction_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Transaction ID does not exist.');
  END IF;

  DELETE FROM SALES_TRANSACTIONS WHERE TRANSACTION_ID = p_transaction_id;
  DBMS_OUTPUT.PUT_LINE('Sales transaction deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting sales transaction: ' || SQLERRM);
END;
/


---Delete DELETE_PRESCRIPTION_DRUG
CREATE OR REPLACE PROCEDURE delete_prescription_drug (
  p_prescription_drug_id IN NUMBER
) AS
  v_exists NUMBER;
BEGIN
  -- Check if the prescription drug record exists
  SELECT COUNT(*) INTO v_exists
  FROM PRESCRIPTION_DRUGS
  WHERE PRESCRIPTION_DRUGS_ID = p_prescription_drug_id;

  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Prescription drug ID does not exist.');
  END IF;

  -- Perform deletion
  DELETE FROM PRESCRIPTION_DRUGS
  WHERE PRESCRIPTION_DRUGS_ID = p_prescription_drug_id;

  DBMS_OUTPUT.PUT_LINE('Prescription drug deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting prescription drug: ' || SQLERRM);
END;
/


-- Delete Payment Method

CREATE OR REPLACE PROCEDURE delete_payment_method(p_payment_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM PAYMENT_METHOD WHERE PAYMENT_ID = p_payment_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Payment Method ID does not exist.');
  END IF;

  DELETE FROM PAYMENT_METHOD WHERE PAYMENT_ID = p_payment_id;
  DBMS_OUTPUT.PUT_LINE('Payment method deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting payment method: ' || SQLERRM);
END;
/


-- Delete Users

CREATE OR REPLACE PROCEDURE delete_user(p_user_id IN NUMBER) IS
  v_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_exists FROM USERS WHERE USER_ID = p_user_id;
  IF v_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'User ID does not exist.');
  END IF;

  DELETE FROM USERS WHERE USER_ID = p_user_id;
  DBMS_OUTPUT.PUT_LINE('User deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error deleting user: ' || SQLERRM);
END;
/

