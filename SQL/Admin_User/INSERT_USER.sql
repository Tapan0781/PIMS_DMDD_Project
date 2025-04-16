BEGIN
  APP_ADMIN.insert_user(
    p_user_name           => 'Ahay Shah',
    p_role                => 'pharmacist',
    p_user_contact_number => '9546653210',
    p_user_email          => 'abhay.shah@pharmahub.com',
    p_user_password       => 'Pharma@123',
    p_created_by          => 1  -- Usually the admin user ID
  );
END;
/

