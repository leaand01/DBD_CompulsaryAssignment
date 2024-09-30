-- Shema Migrations in 001 - 006 in db e-commerce
-- Important before able to run this script: go to Query in menu and select SQLCMD Mode in order to be able to execute lines starting with :r (when selected lines starting with :r are highlighted)

-- create e-commerce db if do not exist
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\001_create_local_db_e-commerce.sql"
go

use [e-commerce];
go

-- create table Products
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\002_create_table_products.sql"
go

-- create table Categories
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\003_create_table_categories.sql"
go

-- add column Category_Id to table Products as a foreign key
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\004_migration_add_categoryid_column_to_products_table_as_fk.sql"
go

-- set Category_Id to not null in table Products
-- Note, this constraint is only possible if have specified values to column Category_Id in all rows in table Products
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\005_migration_add_null_constraint_to_categoryid_column_in_products_table_as_is_a_fk.sql"
go

-- create table ProductRatings
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\006_create_table_productRatings.sql"
go
