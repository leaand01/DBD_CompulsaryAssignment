manual/rollback-plan

**Rollback plan**

**How to execute the rollback plan for tables Products, Categories and ProductRatings.**

Since the tables were created in the order: 
1. Products
2. Categories, + added fk constraint in Products table
3. ProductRatings

the rollback plan deletes the tables and actions in reverse order:
1. Delete table ProductRatings
2. Delete the fk reference between table Categories and Products
3. Delete table Categories
4. Delete column Category_Id from table Products
5. Delete table Products


Note: Due to the fk reference between the Products and Categories table, on the Category_Id column, the fk constraint must be deleted before the Categories table can be deleted.

Above rollback plan is specified in script: 009_rollback_plan.sql

To execute the rollback plan just open the script in SSMS and press F5 to execute it.
