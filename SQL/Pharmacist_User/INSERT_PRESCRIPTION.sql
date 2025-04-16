DECLARE
  v_prescription_id NUMBER;
BEGIN
  APP_ADMIN.APP_TRANSACTIONS.insert_prescription(
    p_patient_id      => 1020,              -- must exist in PATIENTS
    p_doctor_id       => 6,              -- must exist in DOCTORS
    p_date_issue      => SYSDATE,
    p_status          => 'Issued',         -- must be a valid status
    p_created_by      => 2,                
    p_prescription_id => v_prescription_id -- OUT variable
  );

  DBMS_OUTPUT.PUT_LINE('Prescription inserted with ID: ' || v_prescription_id);
END;
/
COMMIT;
