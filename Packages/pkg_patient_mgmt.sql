CREATE OR REPLACE PACKAGE pkg_patient_mgmt AS
    PROCEDURE insert_patient(
        p_patient_id     IN Patients.Patient_ID%TYPE,
        p_first_name     IN Patients.Patient_First_Name%TYPE,
        p_last_name      IN Patients.Patient_Last_Name%TYPE,
        p_contact_number IN Patients.Patient_Contact_Number%TYPE,
        p_email          IN Patients.Patient_Email%TYPE,
        p_street         IN Patients.Patient_street%TYPE,
        p_city           IN Patients.Patient_city%TYPE,
        p_state          IN Patients.Patient_state%TYPE,
        p_zipcode        IN Patients.Patient_zipcode%TYPE,
        p_created_by     IN Patients.Created_By%TYPE
    );
END pkg_patient_mgmt;




CREATE OR REPLACE PACKAGE BODY pkg_patient_mgmt AS
    PROCEDURE insert_patient (
        p_patient_id     IN Patients.Patient_ID%TYPE,
        p_first_name     IN Patients.Patient_First_Name%TYPE,
        p_last_name      IN Patients.Patient_Last_Name%TYPE,
        p_contact_number IN Patients.Patient_Contact_Number%TYPE,
        p_email          IN Patients.Patient_Email%TYPE,
        p_street         IN Patients.Patient_street%TYPE,
        p_city           IN Patients.Patient_city%TYPE,
        p_state          IN Patients.Patient_state%TYPE,
        p_zipcode        IN Patients.Patient_zipcode%TYPE,
        p_created_by     IN Patients.Created_By%TYPE
    ) IS
    BEGIN
        INSERT INTO Patients (
            Patient_ID, Patient_First_Name, Patient_Last_Name,
            Patient_Contact_Number, Patient_Email, Patient_street,
            Patient_city, Patient_state, Patient_zipcode,
            Created_On, Created_By
        ) VALUES (
            p_patient_id, p_first_name, p_last_name,
            p_contact_number, p_email, p_street,
            p_city, p_state, p_zipcode,
            SYSDATE, p_created_by
        );
        DBMS_OUTPUT.PUT_LINE('Patient inserted successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error inserting patient: ' || SQLERRM);
    END insert_patient;
END pkg_patient_mgmt;




BEGIN
    pkg_patient_mgmt.Insert_Patient(
        1001, 'Asha', 'Verma', '9876543210', 'asha@xyz.com',
        'MG Road', 'Mumbai', 'Maharashtra', 400001, 1
    );
END;
/
