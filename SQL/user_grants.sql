-- Drop Admin User if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER admin_user CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN -- ORA-01918: user does not exist
            RAISE;
        END IF;
END;
/

-- Drop Pharmacist User if exists
BEGIN
    EXECUTE IMMEDIATE 'DROP USER pharmacist_user CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN
            RAISE;
        END IF;
END;
/

-- Create Admin User
CREATE USER admin_user IDENTIFIED BY NeuBoston2024#;

-- Create Pharmacist User
CREATE USER pharmacist_user IDENTIFIED BY NeuBoston2025#;

-- Grant basic access roles
GRANT CONNECT, RESOURCE TO admin_user;
GRANT CONNECT TO pharmacist_user;

-- Grant system privileges to Admin for schema creation
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE TRIGGER, CREATE PROCEDURE TO admin_user;

-- Grant minimal privileges to Pharmacist
GRANT CREATE SESSION TO pharmacist_user;


