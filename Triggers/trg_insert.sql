SET SERVEROUTPUT ON;


CREATE OR REPLACE TRIGGER trg_patients_bi
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
  IF :NEW.patient_id IS NULL THEN
    SELECT seq_patients_id.NEXTVAL INTO :NEW.patient_id FROM dual;
  END IF;
  :NEW.created_on := SYSTIMESTAMP;
  :NEW.created_by := TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'));
END;
/



CREATE OR REPLACE TRIGGER trg_prescriptions_bi
BEFORE INSERT ON prescriptions
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_prescriptions_bi fired.');
  IF :NEW.prescription_id IS NULL THEN
    SELECT prescriptions_seq.NEXTVAL INTO :NEW.prescription_id FROM dual;
  END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_prescription_drugs_bi
BEFORE INSERT ON prescription_drugs
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_prescription_drugs_bi fired.');
  IF :NEW.prescription_drugs_id IS NULL THEN
    SELECT prescription_drugs_seq.NEXTVAL INTO :NEW.prescription_drugs_id FROM dual;
  END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_sales_transactions_bi
BEFORE INSERT ON sales_transactions
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_sales_transactions_bi fired.');
  IF :NEW.transaction_id IS NULL THEN
    SELECT sales_transactions_seq.NEXTVAL INTO :NEW.transaction_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_inventory_logs_bi
BEFORE INSERT ON inventory_logs
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_inventory_logs_bi fired.');
  IF :NEW.log_id IS NULL THEN
    SELECT inventory_logs_seq.NEXTVAL INTO :NEW.log_id FROM dual;
  END IF;
END;
/





CREATE OR REPLACE TRIGGER trg_payment_method_bi
BEFORE INSERT ON payment_method
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_payment_method_bi fired.');
  IF :NEW.payment_id IS NULL THEN
    SELECT payment_method_seq.NEXTVAL INTO :NEW.payment_id FROM dual;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_suppliers_bi
BEFORE INSERT ON suppliers
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_suppliers_bi fired.');
  IF :NEW.supplier_id IS NULL THEN
    SELECT suppliers_seq.NEXTVAL INTO :NEW.supplier_id FROM dual;
  END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_catagory_bi
BEFORE INSERT ON catagory
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_catagory_bi fired.');
  IF :NEW.catagory_id IS NULL THEN
    SELECT catagory_seq.NEXTVAL INTO :NEW.catagory_id FROM dual;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_doctors_bi
BEFORE INSERT ON doctors
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_doctors_bi fired.');
  IF :NEW.doctor_id IS NULL THEN
    SELECT doctors_seq.NEXTVAL INTO :NEW.doctor_id FROM dual;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_users_bi
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Trigger trg_users_bi fired.');
  IF :NEW.user_id IS NULL THEN
    SELECT users_seq.NEXTVAL INTO :NEW.user_id FROM dual;
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_drugs_bi
BEFORE INSERT ON drugs
FOR EACH ROW
BEGIN
  IF :NEW.drug_id IS NULL THEN
    SELECT drugs_seq.NEXTVAL INTO :NEW.drug_id FROM dual;
  END IF;
END;
/

