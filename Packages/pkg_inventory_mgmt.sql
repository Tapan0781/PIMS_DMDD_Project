BEGIN
   EXECUTE IMMEDIATE 'CREATE SEQUENCE INVENTORY_LOGS_SEQ START WITH 1 INCREMENT BY 1 NOCACHE';
   DBMS_OUTPUT.PUT_LINE('Sequence INVENTORY_LOGS_SEQ created.');
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
         DBMS_OUTPUT.PUT_LINE('Sequence INVENTORY_LOGS_SEQ already exists.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
      END IF;
END;
/



CREATE OR REPLACE PACKAGE pkg_inventory_management IS
    PROCEDURE insert_drug(
        p_drug_id        IN NUMBER,
        p_drug_name      IN VARCHAR2,
        p_batch_number   IN VARCHAR2,
        p_expiry_date    IN DATE,
        p_mrp            IN NUMBER,
        p_price          IN NUMBER,
        p_stock_quantity IN NUMBER,
        p_supplier_id    IN NUMBER,
        p_category_id    IN NUMBER,
        p_created_by     IN NUMBER
    );

    PROCEDURE update_drug_stock(
        p_drug_id      IN NUMBER,
        p_new_quantity IN NUMBER,
        p_user_id      IN NUMBER
    );

    PROCEDURE update_drug_price(
        p_drug_id     IN NUMBER,
        p_new_price   IN NUMBER
    );

    PROCEDURE check_low_stock(
        p_drug_id IN NUMBER
    );
END pkg_inventory_management;
/

CREATE OR REPLACE PACKAGE BODY pkg_inventory_management IS

    -- Reusable dynamic existence check
    FUNCTION id_exists(p_id IN NUMBER, p_table IN VARCHAR2, p_column IN VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 
            'SELECT COUNT(*) FROM ' || p_table || ' WHERE ' || p_column || ' = :1'
            INTO v_count USING p_id;
        RETURN v_count > 0;
    END;

    -- Insert a new drug
    PROCEDURE insert_drug(
        p_drug_id        IN NUMBER,
        p_drug_name      IN VARCHAR2,
        p_batch_number   IN VARCHAR2,
        p_expiry_date    IN DATE,
        p_mrp            IN NUMBER,
        p_price          IN NUMBER,
        p_stock_quantity IN NUMBER,
        p_supplier_id    IN NUMBER,
        p_category_id    IN NUMBER,
        p_created_by     IN NUMBER
    ) IS
    BEGIN
        IF p_drug_id < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Drug ID must be positive.');
        END IF;

        IF p_price <= 0 OR p_mrp <= 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Price and MRP must be positive.');
        ELSIF p_price > p_mrp THEN
            RAISE_APPLICATION_ERROR(-20003, 'Price cannot exceed MRP.');
        END IF;

        IF p_stock_quantity < 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Stock quantity must be >= 0.');
        END IF;

        IF p_drug_name IS NULL OR TRIM(p_drug_name) = '' THEN
            RAISE_APPLICATION_ERROR(-20005, 'Drug name cannot be empty.');
        END IF;

        IF NOT id_exists(p_supplier_id, 'SUPPLIERS', 'SUPPLIER_ID') THEN
            RAISE_APPLICATION_ERROR(-20006, 'Supplier ID does not exist.');
        END IF;

        IF NOT id_exists(p_category_id, 'CATAGORY', 'CATAGORY_ID') THEN
            RAISE_APPLICATION_ERROR(-20007, 'Category ID does not exist.');
        END IF;

        INSERT INTO DRUGS (
            DRUG_ID, DRUG_NAME, BATCH_NUMBER, EXPIRY_DATE,
            MRP, PRICE, STOCK_QUANTITY,
            SUPPLIERS_SUPPLIER_ID, CATAGORY_CATAGORY_ID,
            CREATED_ON, CREATED_BY
        ) VALUES (
            p_drug_id, p_drug_name, p_batch_number, p_expiry_date,
            p_mrp, p_price, p_stock_quantity,
            p_supplier_id, p_category_id,
            SYSDATE, p_created_by
        );

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20008, 'Drug ID already exists.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20009, 'Unexpected error: ' || SQLERRM);
    END insert_drug;

    -- Update stock quantity and log it
    PROCEDURE update_drug_stock(
        p_drug_id      IN NUMBER,
        p_new_quantity IN NUMBER,
        p_user_id      IN NUMBER
    ) IS
        v_old_quantity NUMBER;
        v_change       NUMBER;
    BEGIN
        SELECT STOCK_QUANTITY INTO v_old_quantity
        FROM DRUGS WHERE DRUG_ID = p_drug_id;

        UPDATE DRUGS
        SET STOCK_QUANTITY = p_new_quantity,
            UPDATED_ON = SYSDATE,
            UPDATED_BY = p_user_id
        WHERE DRUG_ID = p_drug_id;

        v_change := p_new_quantity - v_old_quantity;

        INSERT INTO INVENTORY_LOGS (
            LOG_ID, CHANGE_TYPE, CHANGE_AMOUNT, CHANGE_DATE,
            DRUGS_DRUG_ID, USERS_USER_ID
        ) VALUES (
            INVENTORY_LOGS_SEQ.NEXTVAL,
            CASE WHEN v_change >= 0 THEN 'INCREASE' ELSE 'DECREASE' END,
            ABS(v_change), SYSDATE,
            p_drug_id, p_user_id
        );
    END update_drug_stock;

    -- Update price
    PROCEDURE update_drug_price(
        p_drug_id   IN NUMBER,
        p_new_price IN NUMBER
    ) IS
        v_old_price NUMBER;
    BEGIN
        IF p_new_price <= 0 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Price must be greater than zero.');
        END IF;

        SELECT PRICE INTO v_old_price FROM DRUGS WHERE DRUG_ID = p_drug_id;

        UPDATE DRUGS
        SET PRICE = p_new_price,
            UPDATED_ON = SYSDATE
        WHERE DRUG_ID = p_drug_id;
    END update_drug_price;

    -- Check low stock
    PROCEDURE check_low_stock(p_drug_id IN NUMBER) IS
        v_stock NUMBER;
    BEGIN
        SELECT STOCK_QUANTITY INTO v_stock
        FROM DRUGS WHERE DRUG_ID = p_drug_id;

        IF v_stock < 10 THEN
            DBMS_OUTPUT.PUT_LINE('LOW STOCK: Drug ID ' || p_drug_id || ' has only ' || v_stock || ' units.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Stock OK: Drug ID ' || p_drug_id || ' has ' || v_stock || ' units.');
        END IF;
    END check_low_stock;

END pkg_inventory_management;
/

BEGIN
  APP_ADMIN.PKG_INVENTORY_MANAGEMENT.update_drug_stock(
    p_drug_id => 1,
    p_new_quantity => 75,
    p_user_id => 2
  );
END;
/




BEGIN
  pkg_inventory_management.insert_drug(
    p_drug_id        => 101,
    p_drug_name      => 'Dolo 650',
    p_batch_number   => 'DL650B001',
    p_expiry_date    => TO_DATE('2025-12-31', 'YYYY-MM-DD'),
    p_mrp            => 30,
    p_price          => 25,
    p_stock_quantity => 100,
    p_supplier_id    => 1,
    p_category_id    => 1,
    p_created_by     => 1
  );
END;
/

BEGIN
  pkg_inventory_management.update_drug_stock(
    p_drug_id      => 101,
    p_new_quantity => 150,
    p_user_id      => 2
  );
END;
/

BEGIN
  pkg_inventory_management.update_drug_price(
    p_drug_id   => 101,
    p_new_price => 28
  );
END;
/


BEGIN
  pkg_inventory_management.check_low_stock(101);
END;
/
