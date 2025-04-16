BEGIN
  APP_ADMIN.insert_drug(
    p_drug_name             => 'Paracetamol 500mg',   -- must match an existing name
    p_expiry_date           => TO_DATE('2026-12-31', 'YYYY-MM-DD'),
    p_mrp                   => 65,
    p_price                 => 60,
    p_stock_quantity        => 200,
    p_suppliers_supplier_id => 4,  -- existing supplier ID
    p_catagory_catagory_id  => 3,   -- existing category ID
    p_created_by            => 1      -- user performing the update
  );
END;
/

