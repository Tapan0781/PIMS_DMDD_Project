-- Step 1: Set session client identifier
BEGIN
  DBMS_SESSION.SET_IDENTIFIER('1');  -- Set to current user ID
END;
/

-- Step 2: Call the insert procedure
BEGIN
  APP_ADMIN.APP_TRANSACTIONS.insert_patient(
    p_first_name     => 'Reet',
    p_last_name      => 'Kapoor',
    p_contact_number => '9876543210',
    p_email          => 'reet@example.com',
    p_street         => '123 Maple Ave',
    p_city           => 'Boston',
    p_state          => 'MA',
    p_zipcode        => 02115,
    p_created_by     => 1
  );
END;
/
COMMIT;