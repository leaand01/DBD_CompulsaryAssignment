-- test Rollback plan for schema migrations from 006 - 002.
-- Important before able to run this script: go to Query in menu and select SQLCMD Mode in order to be able to execute lines starting with :r (when selected lines starting with :r are highlighted)


-- create local test db if do not exist
if not exists (select * from sys.databases where name = 'e-commerce_test')
begin
	create database [e-commerce_test];
end
go

use [e-commerce_test];
go

-- drop tables if exist to ensure empty test db (here ignore order of deletion. Delete tables first with fk constraint as then the constraints
-- are deleted also and the referenced tables can be deleted without any issues)
drop table if exists ProductRatings;
drop table if exists Products;
drop table if exists Categories;
go


-- create all migrations from 002 - 006 in correct order - if anything fails terminate run
begin try

	----------------------------------------------------------------------------------------------------------------
	-- create table Products
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\002_create_table_products.sql"
	--go -- kan ikke benytte go i 'begin try', da er en kode-batch seperator

	-- create table Categories
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\003_create_table_categories.sql"
	
	----------------------------------------------------------------------------------------------------------------

	-- insert test data
	insert into Products (Product_Id, Name, Price) values (1, 'Mug', '150');
	insert into Products (Product_Id, Name, Price) values (2, 'Iphone', '5000');
	insert into Products (Product_Id, Name, Price) values (3, 'Samsung TV', '10000');
	
	insert into Categories (Category_Id) values (1);
	insert into Categories (Category_Id) values (2);
	
	----------------------------------------------------------------------------------------------------------------

	-- add new column Category_id to Products table and specify as fk refering to Categories table
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\004_migration_add_categoryid_column_to_products_table_as_fk.sql"
	
	-- add value to new column Category_Id in table Products
	update Products set Category_Id = 1 where Product_Id =  1; -- mug (category_id 1 = kitchen)
	update Products set Category_Id = 2 where Product_Id =  2; -- Iphone (category_id 2 = electronics)
	update Products set Category_Id = 2 where Product_Id =  3; -- Samsung TV
	
	-- add null constraint to fk Category_id in Products table
	-- Note, this constraint is only possible if have specified values to column Category_Id in all rows in table Products
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\005_migration_add_null_constraint_to_categoryid_column_in_products_table_as_is_a_fk.sql"
	
	----------------------------------------------------------------------------------------------------------------

	-- create table ProductRatings
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\006_create_table_productRatings.sql"
	
	----------------------------------------------------------------------------------------------------------------

	-- insert test data
	insert into ProductRatings (Product_Id, Rating) values (1, 7);
	insert into ProductRatings (Product_Id, Rating) values (1, 5);
	insert into ProductRatings (Product_Id, Rating) values (2, 8);
	insert into ProductRatings (Product_Id, Rating) values (3, 9);

	----------------------------------------------------------------------------------------------------------------

	-- Test

	-- test tables are created
	if object_id('Products') is not null and object_id('Categories') is not null and object_id('ProductRatings') is not null
		print 'Successfull: Tables Products, Categories and ProductRatings are created successfully';
	else
		print 'Error in creation of tables';


	-- test number of columns are correct in Products table
	declare @ProductsColumnsCount int; 

	select @ProductsColumnsCount = count(*) from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = 'Products';

	if @ProductsColumnsCount = 4
		print 'Successfull: Correct number of columns in table Products';
	else
		print 'Error: incorrect number of columns in table Products';
	-- Remark, potential refactor: could make this into a function as reused


	-- test number of columns are correct in Categories table
	declare @CategoriesColumnsCount int;

	select @CategoriesColumnsCount = count(*) from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = 'Categories';

	if @CategoriesColumnsCount = 1
		print 'Successfull: Correct number of columns in table Categories';
	else
		print 'Error: incorrect number of columns in table Categories';


	-- test number of columns are correct in ProductRatings table
	declare @ProductRatingsColumnsCount int;

	select @ProductRatingsColumnsCount = count(*) from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME = 'ProductRatings';

	if @ProductRatingsColumnsCount = 4
		print 'Successfull: Correct number of columns in table ProductRatings';
	else
		print 'Error: incorrect number of columns in table ProductRatings';


	-- test inserted data is correct
	declare
		@productCount int,
		@CategoriesCount int,
		@productRatingsCount int;

	select @productCount = count(*) from Products;
	select @CategoriesCount = count(*) from Categories;
	select @productRatingsCount = count(*) from ProductRatings;

	if @productCount = 3 and @CategoriesCount = 2 and @productRatingsCount = 4
		print 'Successfull: Data inserted correctly';
	else
		print 'Error in insertion of data';


	-- test id Category_id in Products are not null
	declare @ProductCountNotNulls int;

	select @ProductCountNotNulls = count(Category_Id) from Products
	where Category_Id is not null;

	if @ProductCountNotNulls = 3
		print 'Successfull: Category_Id are all not null';
	else
		print 'Error: Category_Id can be null';


	-- test foreign key constraint in products:
	-- insertion must fail as trying to create a non-existing Category_Id
	begin try
		insert into Products (Product_Id, Name, Price, Category_Id) values (4, 'something', 1, 3);
		print 'ERROR: foreign key constraint on Category_id in table Products does not work';
	end try
	begin catch
		print 'Successfull: foreign key constraint on Category_id works. Erroneous insertion fails (insertion of incorrect int-id)';
	end catch;

	-- insertion must fail as trying to create a null-value Category_Id
	begin try
		insert into Products (Product_Id, Name, Price, Category_Id) values (4, 'something', 1, null);
		print 'ERROR: foreign key constraint on Category_id in table Products does not work';
	end try
	begin catch
		print 'Successfull: foreign key constraint on Category_Id works. Erroneous insertion fails (insertion of null)';
	end catch;


	-- test foreign key constraint in ProductRatings:
	-- insertion must fail as trying to create a non-existing Product_Id
	begin try
		insert into ProductRatings (Product_Id, Rating) values (99, 7);
		print 'ERROR: foreign key constraint on Product_Id in table ProductRatings does not work';
	end try
	begin catch
		print 'Successfull: foreign key constraint in table ProductRatings works. Erroneous insertion fails (insertion of incorrect Product_Id)';
	end catch;

	-- insertion must fail as trying to create a null-value Product_Id
	begin try
		insert into ProductRatings (Product_Id, Rating) values (null, 5);
		print 'ERROR: foreign key constraint on Product_Id in table ProductRatings does not work';
	end try
	begin catch
		print 'Successfull: foreign key constraint on Product_Id in table ProductRatings works. Erroneous insertion fails (insertion of null as Product_Id)';
	end catch;
	----------------------------------------------------------------------------------------------------------------

end try
begin catch
	print 'Error in setup of all migrations: ' + error_message();
end catch


-- Test rollback plan
begin try
	begin transaction;

	-- rollback migration 006
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_006_create_table_productRatings.sql"

	-- rollback migration 005 - 004
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_005_to_004.sql"

	-- rollback migration 003
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_003_create_table_categories.sql"

	-- rollback migration 002
	:r "C:\easv\Databases for Developers\Opgaver\DBD_CompulsaryAssignment\rollback_002_create_table_products.sql"


	-- validate all tables are deleted in test db
	declare @tableCount int;

	select @tableCount = count(*) from information_schema.tables;

	if @tableCount = 0
	begin
		print 'Successfull: all tables in db e-commerce_test are successfully deleted';
	end
	else
	begin
		print 'Error: db e-commerce_test is not empty, ' + cast(@tableCount as nvarchar(10)) + ' tables remain.';
	end

	commit transaction;
end try
begin catch
	rollback transaction;
	print 'Error in rollback plan:' + error_message();
end catch
