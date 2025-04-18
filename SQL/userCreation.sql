-- Enable output
SET SERVEROUTPUT ON;

-- 1. Attempt to drop PHARMACIST_USER if it exists
BEGIN
   -- Check if it's a user
   FOR u IN (SELECT username FROM all_users WHERE username = 'PHARMACIST_USER') LOOP
      EXECUTE IMMEDIATE 'DROP USER PHARMACIST_USER CASCADE';
      DBMS_OUTPUT.PUT_LINE('Dropped user PHARMACIST_USER.');
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Could not drop PHARMACIST_USER (maybe it is a role or connected): ' || SQLERRM);
END;
/

-- 2. Now safely create the user and assign privileges
BEGIN
    -- Create user
    EXECUTE IMMEDIATE 'CREATE USER PHARMACIST_USER IDENTIFIED BY "NeuBoston2024#"';
    EXECUTE IMMEDIATE 'ALTER USER PHARMACIST_USER QUOTA UNLIMITED ON DATA';
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO PHARMACIST_USER';

    -- Read/write access to transactional tables
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON APP_ADMIN.PATIENTS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON APP_ADMIN.PRESCRIPTIONS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON APP_ADMIN.PRESCRIPTION_DRUGS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON APP_ADMIN.SALES_TRANSACTIONS TO PHARMACIST_USER';

    -- Read-only access to master data
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.CATAGORY TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.DRUGS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.SUPPLIERS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.DOCTORS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.USERS TO PHARMACIST_USER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.PAYMENT_METHOD TO PHARMACIST_USER';

    -- Insert-only access to inventory logs
    EXECUTE IMMEDIATE 'GRANT INSERT ON APP_ADMIN.INVENTORY_LOGS TO PHARMACIST_USER';

    -- View access (wrapped in TRY block to skip if view doesn't exist)
    FOR vname IN (
        SELECT 'APP_ADMIN.' || column_value AS full_view
        FROM TABLE(SYS.ODCIVARCHAR2LIST(
            'CURRENT_INVENTORY_STATUS',
            'TOTAL_SALES_REGION_WISE',
            'WEEK_WISE_SALES',
            'DOCTOR_PRESCRIPTION_COUNT',
            'TOP_SELLING_DRUGS',
            'PRESCRIPTION_SUMMARY',
            'DRUGS_NEAR_EXPIRY'
        ))
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'GRANT SELECT ON ' || vname.full_view || ' TO PHARMACIST_USER';
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('View skipped (not found or not accessible): ' || vname.full_view);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('PHARMACIST_USER created and all required privileges granted.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error creating PHARMACIST_USER: ' || SQLERRM);
END;
/
