SET SERVEROUTPUT ON;

BEGIN
  APP_ADMIN.APP_TRANSACTIONS.insert_sales_transaction(
    p_payment_id     => 1,         -- existing payment method
    p_date_sold      => SYSTIMESTAMP,
    p_quantity_sold  => 10,
    p_total_price    => 120,       -- must match price * quantity
    p_drug_id        => 3,       -- existing drug
    p_user_id        => 2,         -- existing user
    p_created_by     => 2
  );
END;
/
COMMIT;
