-- ✅ Safe Drop & Recreate for PIMS Indexes
-- Uses anonymous PL/SQL blocks to avoid ORA-1418 errors if index doesn't exist

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_drugs_name_batch';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE UNIQUE INDEX idx_drugs_name_batch ON drugs (UPPER(drug_name), UPPER(batch_number));

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_drugs_supplier_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_drugs_supplier_id ON drugs (suppliers_supplier_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_drugs_category_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_drugs_category_id ON drugs (catagory_catagory_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_patients_name';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_patients_name ON patients (patient_first_name, patient_last_name);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_prescriptions_patient_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_prescriptions_patient_id ON prescriptions (patients_patient_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_prescriptions_doctor_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_prescriptions_doctor_id ON prescriptions (doctors_doctor_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_presc_drugs_prescription_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_presc_drugs_prescription_id ON prescription_drugs (prescriptions_prescription_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_presc_drugs_drug_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_presc_drugs_drug_id ON prescription_drugs (drugs_drug_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_sales_transactions_payment_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_sales_transactions_payment_id ON sales_transactions (payment_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_sales_transactions_user_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_sales_transactions_user_id ON sales_transactions (users_user_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_sales_transactions_drug_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_sales_transactions_drug_id ON sales_transactions (drugs_drug_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_inventory_logs_drug_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_inventory_logs_drug_id ON inventory_logs (drugs_drug_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_inventory_logs_user_id';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_inventory_logs_user_id ON inventory_logs (users_user_id);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_suppliers_city_state';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_suppliers_city_state ON suppliers (supplier_city, supplier_state);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_doctors_specialization';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_doctors_specialization ON doctors (specialization);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_users_role';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE INDEX idx_users_role ON users (role);

BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX idx_payment_method_type';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -1418 THEN RAISE; END IF;
END;
/
CREATE UNIQUE INDEX idx_payment_method_type ON payment_method (payment_type);