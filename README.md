manual/rollback-plan

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
