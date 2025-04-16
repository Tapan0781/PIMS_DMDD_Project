SET SERVEROUTPUT ON;
BEGIN
  DBMS_SESSION.SET_IDENTIFIER('1'); -- Replace '1' with the desired user ID
END;
/

CREATE OR REPLACE TRIGGER trg_drugs_update_audit
BEFORE UPDATE ON drugs
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

CREATE OR REPLACE TRIGGER trg_patients_update_audit
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

CREATE OR REPLACE TRIGGER trg_doctors_update_audit
BEFORE UPDATE ON doctors
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

CREATE OR REPLACE TRIGGER trg_users_update_audit
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

CREATE OR REPLACE TRIGGER trg_suppliers_update_audit
BEFORE UPDATE ON suppliers
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

CREATE OR REPLACE TRIGGER trg_catagory_update_audit
BEFORE UPDATE ON catagory
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/


CREATE OR REPLACE TRIGGER trg_prescriptions_update_audit
BEFORE UPDATE ON prescriptions
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/


CREATE OR REPLACE TRIGGER trg_sales_transactions_update_audit
BEFORE UPDATE ON sales_transactions
FOR EACH ROW
BEGIN
  :NEW.updated_on := SYSTIMESTAMP;
  :NEW.updated_by := NVL(TO_NUMBER(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), :OLD.updated_by);
END;
/

