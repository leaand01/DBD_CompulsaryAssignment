**Setting up the project**

Open SQL Server Management Studio (ssms). 

To setup the entire schema run file "000_All_schema_migrations.sql" in ssms. Note, you need to run the file in SQLCMD Mode - at the top of the file are instructions on how to do this.

If you do not want to setup the entire schema at once just outcomment the lines (corresponding to migrations) in above files that you do not wish to run.


**The Migrations**

The migrations are seperated into smaller parts and enumerated in order of creation:

- 001_create_local_db_e-commerce.sql
- 002_create_table_products.sql
- 003_create_table_categories.sql
- 004_migration_add_categoryid_column_to_products_table_as_fk.sql
- 005_migration_add_null_constraint_to_categoryid_column_in_products_table_as_is_a_fk.sql
- 006_create_table_productRatings.sql

Above are the migrations that are all collected in file "000_All_schema_migrations.sql".


**Rollback plan**

**How to execute the rollback plan for tables Products, Categories and ProductRatings.**

Since the tables were created in the order: 
1. Products
2. Categories, + added Category_Id column to Products table as fk 
3. ProductRatings

the rollback plan deletes the tables and actions in reverse order:
1. Delete table ProductRatings
2. Delete the fk reference between table Categories and Products, and removes Category_Id column from Products table
3. Delete table Categories
5. Delete table Products


Note: Due to the fk reference between the Products and Categories table, on the Category_Id column, the fk constraint must be deleted before the Categories table can be deleted. We only need to do this because we want to delete the Categories table before the Products table.

Above rollback plan is specified in script: rollback_plan_for_migrations_006_to_002.sql

To execute the rollback plan just open the script in SSMS, go to Query in the menu and select SQLCMD Mode (when selected lines starting with :r in the script are highlighted), and then press F5 to execute it.

In other words, you ONLY run file "rollback_plan_for_migrations_006_to_002.sql" to execute rollbacks on the e-commerce db, and not any of the other scripts starting with "rollback...".

**Example**

 If you only want to rollback to migration 003, i.e. where the Products and Categories table are created but the FK constraint i not yet made, then you just need to outcomment the lines in script "rollback_plan_for_migrations_006_to_002.sql" that you do NOT want to rollback, in this case outcomment the following lines:

-- Rollback 003, drop table Categories
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_003_create_table_categories.sql"
go

-- Rollback 002, drop table Products
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_002_create_table_products.sql"
go
