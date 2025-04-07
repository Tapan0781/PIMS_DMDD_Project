
CREATE OR REPLACE PROCEDURE Insert_Patient (
    p_Patient_ID IN NUMBER,
    p_First_Name IN VARCHAR2,
    p_Last_Name IN VARCHAR2,
    p_Contact IN VARCHAR2,
    p_Email IN VARCHAR2,
    p_Street IN VARCHAR2,
    p_City IN VARCHAR2,
    p_State IN VARCHAR2,
    p_Zipcode IN NUMBER,
    p_Created_By IN NUMBER
)
AS
BEGIN
    INSERT INTO APP_ADMIN.Patients (
        Patient_ID, Patient_First_Name, Patient_Last_Name,
        Patient_Contact_Number, Patient_Email, Patient_street,
        Patient_city, Patient_state, Patient_zipcode,
        Created_On, Created_By
    ) VALUES (
        p_Patient_ID, p_First_Name, p_Last_Name,
        p_Contact, p_Email, p_Street,
        p_City, p_State, p_Zipcode,
        SYSDATE, p_Created_By
    );
    DBMS_OUTPUT.PUT_LINE('Patient inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting patient: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE Insert_Prescription (
    p_Prescription_ID IN NUMBER,
    p_Date_Issue IN DATE,
    p_Status IN VARCHAR2,
    p_Doctor_ID IN NUMBER,
    p_Patient_ID IN NUMBER,
    p_Created_By IN NUMBER
)
AS
BEGIN
    INSERT INTO APP_ADMIN.Prescriptions (
        Prescription_ID, Date_Issue, Status,
        Doctors_Doctor_ID, Patients_Patient_ID,
        Created_On, Created_By
    ) VALUES (
        p_Prescription_ID, p_Date_Issue, p_Status,
        p_Doctor_ID, p_Patient_ID,
        SYSDATE, p_Created_By
    );
    DBMS_OUTPUT.PUT_LINE('Prescription inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting prescription: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE Insert_Prescription_Drug (
    p_Prescription_Drug_ID IN NUMBER,
    p_Quantity IN NUMBER,
    p_Drug_ID IN NUMBER,
    p_Prescription_ID IN NUMBER
)
AS
BEGIN
    INSERT INTO APP_ADMIN.Prescription_Drugs (
        Prescription_Drugs_ID, Quantity,
        Drugs_Drug_ID, Prescriptions_Prescription_ID
    ) VALUES (
        p_Prescription_Drug_ID, p_Quantity,
        p_Drug_ID, p_Prescription_ID
    );
    DBMS_OUTPUT.PUT_LINE('Prescription drug inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting prescription drug: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE Insert_Sales_Transaction (
    p_Transaction_ID IN NUMBER,
    p_Payment_ID IN NUMBER,
    p_Quantity_Sold IN NUMBER,
    p_Total_Price IN NUMBER,
    p_Drug_ID IN NUMBER,
    p_User_ID IN NUMBER,
    p_Created_By IN NUMBER
)
AS
BEGIN
    INSERT INTO APP_ADMIN.Sales_Transactions (
        Transaction_ID, Payment_ID, Date_Timestamp,
        Quantity_Sold, Total_Price, Drugs_Drug_ID,
        Users_User_ID, Created_On, Created_By
    ) VALUES (
        p_Transaction_ID, p_Payment_ID, SYSDATE,
        p_Quantity_Sold, p_Total_Price, p_Drug_ID,
        p_User_ID, SYSDATE, p_Created_By
    );
    DBMS_OUTPUT.PUT_LINE('Sales transaction inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting sales transaction: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE Insert_Inventory_Log (
    p_Log_ID IN NUMBER,
    p_Change_Type IN VARCHAR2,
    p_Change_Amount IN NUMBER,
    p_Drug_ID IN NUMBER,
    p_User_ID IN NUMBER
)
AS
BEGIN
    INSERT INTO APP_ADMIN.Inventory_Logs (
        Log_ID, Change_Type, Change_Amount,
        Change_Date, Drugs_Drug_ID, Users_User_ID
    ) VALUES (
        p_Log_ID, p_Change_Type, p_Change_Amount,
        SYSDATE, p_Drug_ID, p_User_ID
    );
    DBMS_OUTPUT.PUT_LINE('Inventory log inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting inventory log: ' || SQLERRM);
END;
/
