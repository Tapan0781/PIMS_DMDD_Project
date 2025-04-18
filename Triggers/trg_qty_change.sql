CREATE OR REPLACE TRIGGER trg_inventory_logs_ai
AFTER INSERT ON INVENTORY_LOGS
FOR EACH ROW
BEGIN
  CASE :NEW.CHANGE_TYPE
    WHEN 'ADD' THEN
      UPDATE DRUGS
      SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) + :NEW.CHANGE_AMOUNT
      WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
    WHEN 'SALE' THEN
      UPDATE DRUGS
      SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) - :NEW.CHANGE_AMOUNT
      WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
    WHEN 'EXPIRED_REMOVAL' THEN
      UPDATE DRUGS
      SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) - :NEW.CHANGE_AMOUNT
      WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
    WHEN 'RETURN' THEN
      UPDATE DRUGS
      SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) + :NEW.CHANGE_AMOUNT
      WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
    WHEN 'REMOVE' THEN
      UPDATE DRUGS
      SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) - :NEW.CHANGE_AMOUNT
      WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
    ELSE
      -- Handle unexpected CHANGE_TYPE values if necessary
      NULL;
  END CASE;
END;
/




CREATE OR REPLACE TRIGGER trg_sales_transactions_ai
AFTER INSERT ON SALES_TRANSACTIONS
FOR EACH ROW
BEGIN
  UPDATE DRUGS
  SET STOCK_QUANTITY = NVL(STOCK_QUANTITY, 0) - :NEW.QUANTITY_SOLD
  WHERE DRUG_ID = :NEW.DRUGS_DRUG_ID;
END;
/


