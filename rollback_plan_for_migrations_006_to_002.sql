-- Rollback plan

use [e-commerce];
go

-- Rollback plan from migrations 006 to 002

-- Rollback 006, drop table ProductRatings
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_006_create_table_productRatings.sql"
go

-- Rollback 005 - 004, drop fk constraint on Category_Id in Products table and drop column Category_Id in Products table
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_005_to_004.sql"
go

-- Rollback 003, drop table Categories
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_003_create_table_categories.sql"
go

-- Rollback 002, drop table Products
:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_002_create_table_products.sql"
go

print 'Notification: db e-commerce should now be empty / contain no tables';
