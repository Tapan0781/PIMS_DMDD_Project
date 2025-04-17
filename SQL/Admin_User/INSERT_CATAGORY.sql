BEGIN
  APP_ADMIN.insert_catagory(
    p_catagory_name => 'Antifungul',
    p_created_by    => 1  -- User ID of the admin/pharmacist creating it
  );
END;
/
COMMIT;

--gives error when you add existing catagory 
SELECT * FROM CATAGORY;