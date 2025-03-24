
Pharmaceutical Inventory Management System (PIMS)
=================================================

📌 Project Overview
-------------------
This system manages the end-to-end flow of pharmaceutical inventory, including:
- Inventory tracking
- Patient and doctor management
- Prescription handling
- Sales transactions
- Role-based user access

Built using Oracle SQL with robust schema design, constraints, views, and role-based privileges.

🏗️ Schema Structure
--------------------
Main Tables:
| Table Name             | Description                               |
|------------------------|-------------------------------------------|
| Users                  | All system users with roles 'admin' or 'pharmacist' |
| Doctors                | Registered doctors                        |
| Patients               | Registered patients                       |
| Drugs                  | Drug inventory with batch, MRP, price     |
| Catagory               | Drug categories                           |
| Suppliers              | Drug suppliers                            |
| Prescriptions          | Prescriptions issued                      |
| Prescription_Drugs     | Drugs per prescription                    |
| Sales_Transactions     | Drug sale logs                            |
| Inventory_Logs         | Inventory change audit trail              |
| Payment_Method         | Payment types like Cash, Card, etc.       |

👥 Users & Roles
-----------------
1. APP_ADMIN
   - Superuser with DBA-level privileges
   - Can create/drop users, tables, views, sequences, triggers
   - Inserts all master data (Doctors, Drugs, Users, etc.)

2. PHARMACIST_USER
   - Operates within assigned privilege scope
   - Can insert/update in: 
     - Patients
     - Prescriptions
     - Prescription_Drugs
     - Sales_Transactions
     - Inventory_Logs
   - Has read-only access to: 
     - Drugs, Suppliers, Doctors, Catagory, Users, Payment_Method
     - Custom views like Current_Inventory_Status

🔐 Privilege Management
------------------------
- Role-based GRANT statements used to assign table and view permissions.
- Synonyms created to allow PHARMACIST_USER to access tables without prefixing APP_ADMIN.
- Foreign key constraints ensure referential integrity across all transactional tables.

📦 Data Initialization
-----------------------
Sample Data Inserted:
- Users: 2 (admin, pharmacist)
- Doctors: 10
- Patients: 10
- Drugs: 10
- Categories: 10
- Suppliers: 10
- Prescriptions: 10
- Prescription_Drugs: 10
- Sales_Transactions: 10
- Inventory_Logs: 10
- Payment Methods: 4 (Cash, Credit Card, Debit Card, Check)

📊 Views Created
-----------------
| View Name                   | Purpose                                      |
|----------------------------|----------------------------------------------|
| Current_Inventory_Status   | Show drugs and their stock status            |
| Total_Sales_Region_Wise    | Region-wise aggregated sales                 |
| Week_Wise_Sales            | Weekly revenue summary                       |
| Doctor_Prescription_Count  | Number of prescriptions issued per doctor    |
| Top_Selling_Drugs          | Top 10 drugs by units sold                   |
| Prescription_Summary       | Summary of prescriptions with patient/doctor |
| Drugs_Near_Expiry          | Drugs expiring within 30 days                |

✅ How to Run
--------------
1. Connect to Oracle DB as APP_ADMIN
2. Run the DDL script to create tables and constraints
3. Insert master data (Users, Doctors, Drugs, etc.)
4. Create views and synonyms
5. Create PHARMACIST_USER and assign privileges
6. Switch to PHARMACIST_USER and perform transaction inserts

🚨 Error Handling & Notes
--------------------------
- Ensure foreign keys (e.g., Created_By, Updated_By) match existing User_IDs.
- Use explicit column names in INSERT to avoid ORA-00947 errors.

