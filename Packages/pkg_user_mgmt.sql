-- PACKAGE SPEC
CREATE OR REPLACE PACKAGE pkg_user_mgmt IS
    PROCEDURE insert_user(
        p_user_id     IN NUMBER,
        p_user_name   IN VARCHAR2,
        p_role        IN VARCHAR2,
        p_contact     IN VARCHAR2,
        p_email       IN VARCHAR2,
        p_password    IN VARCHAR2,
        p_created_by  IN NUMBER
    );

    PROCEDURE update_user_contact(
        p_user_id   IN NUMBER,
        p_contact   IN VARCHAR2,
        p_email     IN VARCHAR2,
        p_updated_by IN NUMBER
    );

    PROCEDURE deactivate_user(
        p_user_id IN NUMBER
    );
END pkg_user_mgmt;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_user_mgmt IS

    -- Insert a new user
    PROCEDURE insert_user(
        p_user_id     IN NUMBER,
        p_user_name   IN VARCHAR2,
        p_role        IN VARCHAR2,
        p_contact     IN VARCHAR2,
        p_email       IN VARCHAR2,
        p_password    IN VARCHAR2,
        p_created_by  IN NUMBER
    ) IS
        v_exists NUMBER;
    BEGIN
        IF p_user_name IS NULL OR TRIM(p_user_name) = '' THEN
            RAISE_APPLICATION_ERROR(-21001, 'Username cannot be blank.');
        END IF;

        IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            RAISE_APPLICATION_ERROR(-21002, 'Invalid email format.');
        END IF;
        
        IF LOWER(TRIM(p_role)) NOT IN ('admin', 'pharmacist') THEN
            RAISE_APPLICATION_ERROR(-20205, 'Invalid role. Only "admin" and "pharmacist" are allowed.');
        END IF;
            
        IF p_password IS NULL OR LENGTH(p_password) < 6 THEN
            RAISE_APPLICATION_ERROR(-21003, 'Password must be at least 6 characters.');
        END IF;

        SELECT COUNT(*) INTO v_exists FROM Users WHERE User_ID = p_user_id;
        IF v_exists > 0 THEN
            RAISE_APPLICATION_ERROR(-21004, 'User ID already exists.');
        END IF;

        INSERT INTO Users (
            User_ID, User_Name, Role, User_Contact_Number,
            User_Email, User_Password, Created_On, Created_By
        ) VALUES (
            p_user_id, p_user_name, p_role, p_contact,
            p_email, p_password, SYSDATE, p_created_by
        );

        DBMS_OUTPUT.PUT_LINE('User inserted successfully.');
    END insert_user;

    -- Update user contact details
    PROCEDURE update_user_contact(
        p_user_id   IN NUMBER,
        p_contact   IN VARCHAR2,
        p_email     IN VARCHAR2,
        p_updated_by IN NUMBER
    ) IS
        v_exists NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_exists FROM Users WHERE User_ID = p_user_id;
        IF v_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-21005, 'User ID does not exist.');
        END IF;

        UPDATE Users
        SET User_Contact_Number = p_contact,
            User_Email = p_email,
            Updated_On = SYSDATE,
            Updated_By = p_updated_by
        WHERE User_ID = p_user_id;

        DBMS_OUTPUT.PUT_LINE('User contact updated successfully.');
    END update_user_contact;

    -- Deactivate a user by setting role to INACTIVE (soft delete)
    PROCEDURE deactivate_user(
        p_user_id IN NUMBER
    ) IS
    BEGIN
        UPDATE Users
        SET Role = 'INACTIVE',
            Updated_On = SYSDATE
        WHERE User_ID = p_user_id;

        DBMS_OUTPUT.PUT_LINE('User deactivated.');
    END deactivate_user;

END pkg_user_mgmt;
/

-- Show compilation errors
SHOW ERRORS PACKAGE pkg_user_mgmt;
SHOW ERRORS PACKAGE BODY pkg_user_mgmt;
