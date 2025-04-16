-- PACKAGE SPEC
CREATE OR REPLACE PACKAGE pkg_sales_mgmt IS
    PROCEDURE insert_sales_transaction(
        p_transaction_id IN NUMBER,
        p_payment_id     IN NUMBER,
        p_date_timestamp IN TIMESTAMP,
        p_quantity_sold  IN NUMBER,
        p_total_price    IN NUMBER,
        p_drug_id        IN NUMBER,
        p_user_id        IN NUMBER,
        p_created_by     IN NUMBER
    );

    FUNCTION calculate_total_price(
        p_drug_id IN NUMBER,
        p_quantity IN NUMBER
    ) RETURN NUMBER;

    PROCEDURE get_sales_summary_by_date(
        p_start_date IN DATE,
        p_end_date   IN DATE
    );
END pkg_sales_mgmt;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_sales_mgmt IS

    FUNCTION calculate_total_price(
        p_drug_id IN NUMBER,
        p_quantity IN NUMBER
    ) RETURN NUMBER IS
        v_price NUMBER;
    BEGIN
        IF p_quantity <= 0 THEN
            RAISE_APPLICATION_ERROR(-20101, 'Quantity must be greater than 0.');
        END IF;

        SELECT Price INTO v_price FROM Drugs WHERE Drug_ID = p_drug_id;
        RETURN v_price * p_quantity;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Drug ID not found.');
    END;

    PROCEDURE insert_sales_transaction(
        p_transaction_id IN NUMBER,
        p_payment_id     IN NUMBER,
        p_date_timestamp IN TIMESTAMP,
        p_quantity_sold  IN NUMBER,
        p_total_price    IN NUMBER,
        p_drug_id        IN NUMBER,
        p_user_id        IN NUMBER,
        p_created_by     IN NUMBER
    ) IS
        v_exists NUMBER;
    BEGIN
        -- Validate quantity
        IF p_quantity_sold <= 0 THEN
            RAISE_APPLICATION_ERROR(-20103, 'Quantity sold must be greater than 0.');
        END IF;

        -- Validate total price
        IF p_total_price <= 0 THEN
            RAISE_APPLICATION_ERROR(-20104, 'Total price must be greater than 0.');
        END IF;

        -- Validate foreign keys
        SELECT COUNT(*) INTO v_exists FROM Drugs WHERE Drug_ID = p_drug_id;
        IF v_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20105, 'Invalid drug ID.');
        END IF;

        SELECT COUNT(*) INTO v_exists FROM Users WHERE User_ID = p_user_id;
        IF v_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20106, 'Invalid user ID.');
        END IF;

        SELECT COUNT(*) INTO v_exists FROM Payment_Method WHERE Payment_ID = p_payment_id;
        IF v_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20107, 'Invalid payment method ID.');
        END IF;

        -- Insert record
        INSERT INTO Sales_Transactions (
            Transaction_ID, Payment_ID, Date_Timestamp, Quantity_Sold,
            Total_Price, Drugs_Drug_ID, Users_User_ID,
            Created_On, Created_By
        ) VALUES (
            p_transaction_id, p_payment_id, p_date_timestamp, p_quantity_sold,
            p_total_price, p_drug_id, p_user_id,
            SYSDATE, p_created_by
        );

        DBMS_OUTPUT.PUT_LINE('Transaction successfully inserted.');

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20108, 'Transaction ID already exists.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20109, 'Unexpected error: ' || SQLERRM);
    END insert_sales_transaction;

    PROCEDURE get_sales_summary_by_date(
        p_start_date IN DATE,
        p_end_date   IN DATE
    ) IS
        CURSOR sales_cur IS
            SELECT Transaction_ID, Drugs_Drug_ID, Quantity_Sold, Total_Price, Date_Timestamp
            FROM Sales_Transactions
            WHERE TRUNC(Date_Timestamp) BETWEEN p_start_date AND p_end_date
            ORDER BY Date_Timestamp;

        v_record sales_cur%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Sales Summary from ' || TO_CHAR(p_start_date) || ' to ' || TO_CHAR(p_end_date));
        FOR v_record IN sales_cur LOOP
            DBMS_OUTPUT.PUT_LINE('Txn ID: ' || v_record.Transaction_ID ||
                                 ', Drug ID: ' || v_record.Drugs_Drug_ID ||
                                 ', Qty: ' || v_record.Quantity_Sold ||
                                 ', Total: ' || v_record.Total_Price ||
                                 ', Date: ' || TO_CHAR(v_record.Date_Timestamp, 'YYYY-MM-DD HH24:MI'));
        END LOOP;
    END get_sales_summary_by_date;

END pkg_sales_mgmt;
/

-- Show compilation errors
SHOW ERRORS PACKAGE pkg_sales_mgmt;
SHOW ERRORS PACKAGE BODY pkg_sales_mgmt;

BEGIN
  PKG_SALES_MGMT.insert_sales_transaction(
    p_transaction_id     => 1001,
    p_payment_id         => 1,
    p_date_timestamp     => SYSTIMESTAMP,
    p_quantity_sold      => 2,
    p_total_price        => 40.00,
    p_drug_id            => 1,
    p_user_id            => 2,
    p_created_by         => 1
  );
END;
/




BEGIN
  PKG_SALES_MGMT.get_sales_summary_by_date(
    p_start_date => TO_DATE('2024-01-01', 'YYYY-MM-DD'),
    p_end_date   => SYSDATE
  );
END;
/



