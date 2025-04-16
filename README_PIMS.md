# 💊 Pharmaceutical Inventory Management System (PIMS)

This project implements a role-based Pharmaceutical Inventory Management System using Oracle SQL, PL/SQL, triggers, procedures, functions, views, and packages. It provides robust inventory control, prescription tracking, sales reporting, and user-role based access with automation and validation at each stage.

---

## 📁 Folder Structure

```
/sql
  ├── app_admin_creation.sql
  ├── ddl.sql
  ├── view.sql
  ├── indexes.sql
  ├── Data_insertion_app_admin.sql
  ├── Data_insertion_pharmacist.sql
  ├── user_grants.sql
  ├── admin_user/
  └── pharmacist_user/

/packages
  ├── pkg_patient_mgmt.sql
  ├── pkg_inventory_management.sql
  └── ...

/procedures
  └── delete_procedures.sql

/sequences
  └── sequence.sql

/triggers
  └── trg_update_audit_files.sql

/functions
  └── functions.sql
```

---

## ✅ Prerequisites

- Oracle SQL Developer
- Oracle 11g/12c+ instance
- Execute as **`SYSDBA`** for user creation

---

## 🚀 Setup Instructions

### Step 1: Create `APP_ADMIN` user
1. Open `/sql/app_admin_creation.sql`
2. Run it in SQL Developer as SYSDBA to create the `APP_ADMIN` schema

---

### Step 2: Connect as `APP_ADMIN`
- Use the credentials mentioned in `app_admin_creation.sql`
- Create a **new connection** named `APP_ADMIN`

---

### Step 3: Set up tables and data
1. Run `/sql/ddl.sql` – creates all 11 required tables
2. Run `/sql/Data_insertion_app_admin.sql` – inserts base data
3. Run `/sql/Data_insertion_pharmacist.sql` – inserts pharmacist-related test data

---

### Step 4: Create Packages
- Navigate to `/packages` and run all `.sql` files to create `PKG_PATIENT_MGMT`, `PKG_PRESCRIPTION_MGMT`, etc.

---

### Step 5: Create Triggers
- Navigate to `/triggers` and run all trigger scripts (e.g., `trg_update_audit.sql`)

---

### Step 6: Create Procedures
- Open `/procedures` and run `delete_procedures.sql` and any other available files

---

### Step 7: Create Sequences
- Run `/sequences/prescription_drugs_seq_trigger.sql` to enable auto-increment logic

---

### Step 8: Create Views & Indexes
- Run `/sql/view.sql`
- Run `/sql/indexes.sql`

---

### Step 9: Create Functions
- Run any available `.sql` files from `/functions` (e.g., `monthly_sales_report_fn.sql`, `get_low_stock_fn.sql`)

---

### Step 10: Create & Grant `PHARMACIST_USER`
- Run `/sql/user_grants.sql`
- This will:
  - Create `PHARMACIST_USER`
  - Grant all required permissions
  - Grant view/function/procedure access

---

### Step 11: Test Admin Features
- While connected as `APP_ADMIN`, open `/sql/admin_user/` folder and run test scripts

---

### Step 12: Test Pharmacist Features
- Connect as `PHARMACIST_USER` using the credentials in `user_grants.sql`
- Run all files in `/sql/pharmacist_user/`

---

### 🔁 Additional Notes
- ✅ COMMIT statements may be needed after inserts/updates
- 🔐 Proper grants and roles have been enforced per the project guidelines
- 🧠 The database uses constraints, triggers, and exception-handled packages to automate business rules
- 📊 Views and functions provide reporting for automation insights

---


---
