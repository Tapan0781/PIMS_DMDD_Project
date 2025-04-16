CREATE OR REPLACE PACKAGE pkg_prescription_mgmt AS
    PROCEDURE insert_prescription(
        p_prescription_id IN NUMBER,
        p_date_issue IN DATE,
        p_status IN VARCHAR2,
        p_doctor_id IN NUMBER,
        p_patient_id IN NUMBER,
        p_created_by IN NUMBER
    );
END pkg_prescription_mgmt;
/




CREATE OR REPLACE PACKAGE BODY pkg_prescription_mgmt AS
    PROCEDURE insert_prescription(
        p_prescription_id IN NUMBER,
        p_date_issue IN DATE,
        p_status IN VARCHAR2,
        p_doctor_id IN NUMBER,
        p_patient_id IN NUMBER,
        p_created_by IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Prescriptions (
            Prescription_ID, Date_Issue, Status, 
            Doctors_Doctor_ID, Patients_Patient_ID, 
            Created_On, Created_By
        ) VALUES (
            p_prescription_id, p_date_issue, p_status, 
            p_doctor_id, p_patient_id, 
            SYSDATE, p_created_by
        );
    END insert_prescription;
END pkg_prescription_mgmt;
/


BEGIN
  pkg_prescription_mgmt.insert_prescription(
    p_prescription_id => 2001,
    p_date_issue => TO_DATE('2024-04-10', 'YYYY-MM-DD'),
    p_status => 'Issued',
    p_doctor_id => 1,
    p_patient_id => 1001,
    p_created_by => 1
  );
END;
/





SELECT * 
FROM APP_ADMIN.Prescriptions;