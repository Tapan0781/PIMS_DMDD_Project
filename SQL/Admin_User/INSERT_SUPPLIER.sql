BEGIN
  APP_ADMIN.insert_supplier(
    p_supplier_name           => 'Global Pharma Supplies',
    p_supplier_contact_number => '9876543210',
    p_supplier_email          => 'contact@globalpharma.com',
    p_supplier_street         => '123 Medway Blvd',
    p_supplier_state          => 'Massachusetts',
    p_supplier_zipcode        => 02120,
    p_supplier_city           => 'Boston',
    p_created_by              => 1  
  );
END;
/

COMMIT;



SELECT * 
FROM SUPPLIERS
WHERE SUPPLIER_EMAIL = 'contact@globalpharma.com';
