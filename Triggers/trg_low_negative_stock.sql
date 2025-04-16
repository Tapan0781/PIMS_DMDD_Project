
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER trg_low_stock_alert
AFTER UPDATE OF stock_quantity ON drugs
FOR EACH ROW
DECLARE
  v_min_threshold NUMBER := 10; -- Set your desired minimum threshold
BEGIN
  IF :NEW.stock_quantity < v_min_threshold THEN
    DBMS_OUTPUT.PUT_LINE('Low stock alert: Drug ID ' || :NEW.drug_id || ' has only ' || :NEW.stock_quantity || ' units remaining.');
    
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_prevent_negative_stock
BEFORE UPDATE OF stock_quantity ON drugs
FOR EACH ROW
BEGIN
  IF :NEW.stock_quantity < 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error: Stock quantity cannot be negative.');
  END IF;
END;
/


UPDATE drugs
SET stock_quantity = 5
WHERE drug_id = 1; -- Replace with an existing drug ID

select * from drugs
where drug_id = 1;