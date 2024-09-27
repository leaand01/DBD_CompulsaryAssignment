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
drop table if exists ProductsRatings;
drop table if exists Products;
drop table if exists Categories;
go


-- create all migrations in correct order - if anything fails terminate run
begin try

	-- Combined copies from test scripts
	----------------------------------------------------------------------------------------------------------------
	-- create table Products
	create table Products (
		Product_Id int primary key,
		Name nvarchar(100) not null,
		Price decimal(10,2) not null
	);
	--go -- kan ikke benytte go i begin try, da er en kode-batch seperator

	-- create table Categories
	create table Categories (
		Category_Id int Primary Key,	
	);
	--go

	-- create table ProductRatings
	create table ProductRatings (
		Rating_Id int primary key identity(1,1),  --identity(1,1) ensures a Rating_id is automatically assigned (Remark: should add identity(1,1) to Products and Categories tables primary keys)
		Product_Id int not null,
		Rating int null,
		Rating_timestamp datetime not null default getdate(), -- automatically insert current timestamp when a rating is created
		foreign key (Product_Id) references Products(Product_Id)
	);
	--go

	----------------------------------------------------------------------------

	-- insert test data
	insert into Products (Product_Id, Name, Price) values (1, 'Mug', '150');
	insert into Products (Product_Id, Name, Price) values (2, 'Iphone', '5000');
	insert into Products (Product_Id, Name, Price) values (3, 'Samsung TV', '10000');
	--go

	insert into Categories (Category_Id) values (1);
	insert into Categories (Category_Id) values (2);
	--go

	insert into ProductRatings (Product_Id, Rating) values (1, 7);
	insert into ProductRatings (Product_Id, Rating) values (1, 5);
	insert into ProductRatings (Product_Id, Rating) values (2, 8);
	insert into ProductRatings (Product_Id, Rating) values (3, 9);
	--go

	----------------------------------------------------------------------------

	-- Shema migration on table products

	-- add new column to Products table
	alter table Products
	add Category_Id int; -- Having inserted data i cannot specify not null here.
	--go 

	-- add value to new column Category_Id in table Products
	update Products set Category_Id = 1 where Product_Id =  1; -- mug (category_id 1 = kitchen)
	update Products set Category_Id = 2 where Product_Id =  2; -- Iphone (category_id 2 = electronics)
	update Products set Category_Id = 2 where Product_Id =  3; -- Samsung TV
	--go

	-- here specify Category_Id cannot be null in Products table
	alter table Products
	alter column Category_Id int not null;
	--go

	-- Setup foreign key between Products and Categories tables on column Category_Id
	alter table Products
	add constraint fk_category
	foreign key (Category_Id) references Categories(Category_Id);
	--go

	----------------------------------------------------------------------------

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
		print 'Successfull: foreign key constraint works. Erroneous insertion fails (insertion of incorrect int-id)';
	end catch;

	-- insertion must fail as trying to create a null-value Category_Id
	begin try
		insert into Products (Product_Id, Name, Price, Category_Id) values (4, 'something', 1, null);
		print 'ERROR: foreign key constraint on Category_id in table Products does not work';
	end try
	begin catch
		print 'Successfull: foreign key constraint works. Erroneous insertion fails (insertion of null)';
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
		print 'Successfull: foreign key constraint in table ProductRatings works. Erroneous insertion fails (insertion of null as Product_Id)';
	end catch;
	----------------------------------------------------------------------------------------------------------------

	--print 'Successfull: all migrations, insertions and tests are successfull';
end try
begin catch
	print 'Error in setup of all migrations: ' + error_message();
end catch


-- Test rollback plan
begin try
	begin transaction;

	-- drop tables in reverse order than were created
	--drop table if exists ProductsRatings;  -- virker tilsyneladende ikke i rollback, brokker sig over fk constraint selvom ikke burde være et problem. forsøg at fjerne fk constraint først

	-- forsøg 0 start
	-- Remove FK constraint between ProductRatings and Products
    declare @fk_name_ratings nvarchar(128);
        
    -- Find the name of the foreign key constraint between ProductRatings and Products
    select @fk_name_ratings = fk.name
    from sys.foreign_keys as fk
    join sys.tables as t on fk.parent_object_id = t.object_id
    where object_name(fk.referenced_object_id) = 'Products' and t.name = 'ProductRatings';

    -- Drop the foreign key constraint
    if @fk_name_ratings is not null
    begin
        exec('alter table ProductRatings drop constraint ' + @fk_name_ratings);
        print 'Success: Foreign key constraint on Product_Id in ProductRatings table has been dropped.';
    end
    else
    begin
        print 'Warning: No foreign key constraint found on Product_Id in ProductRatings table.';
    end
        
    -- Now drop ProductRatings table
    --drop table ProductsRatings;  -- siger jeg ikke har permission til at slette den?
	drop table if exists ProductsRatings;

	if object_id('ProductRatings', 'U') is not null
	begin
		print 'Failed: table ProductRatings was not deleted';
	end
	else
	begin
		print 'Success: table ProductRatings is deleted';
	end

	--tjek locks på ProductRatings
	SELECT 
		request_session_id AS SessionID,
		resource_type AS ResourceType,
		resource_database_id AS DatabaseID,
		resource_associated_entity_id AS ResourceID,
		request_mode AS RequestMode,
		request_status AS RequestStatus
	FROM sys.dm_tran_locks
	WHERE resource_database_id = DB_ID('e-commerce_test')
	AND resource_associated_entity_id = OBJECT_ID('ProductRatings');

	-- hvilke sessioner der holder locks og typer
	SELECT 
		r.session_id,
		r.status,
		r.wait_type,
		r.wait_time,
		r.blocking_session_id,
		r.command,
		r.cpu_time,
		r.total_elapsed_time,
		t.text AS QueryText
	FROM sys.dm_exec_requests r
	CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
	WHERE r.session_id IN (SELECT request_session_id FROM sys.dm_tran_locks WHERE resource_associated_entity_id = OBJECT_ID('ProductRatings'));



/*
	if object_id('ProductRatings', 'U') is not null
	begin
		print 'Failed: table ProductRatings was not deleted';
	end
	else
	begin
		print 'Success: table ProductRatings is deleted';
	end

	-- debug hvorfor fjernes ProductRatins ikke?
	-- kontroller constraints
	SELECT * 
	FROM sys.foreign_keys 
	WHERE referenced_object_id = OBJECT_ID('ProductRatings'); 

	-- aktive sessions med tabellen?
	SELECT *
/*    session_id, 
    status, 
    --blocking_id, 
    wait_type, 
    wait_time, 
    wait_resource 
	*/
	FROM sys.dm_exec_requests 
	WHERE database_id = DB_ID('e-commerce_test');

*/


	-- forsøg 0 slut




	-- To delete Categories we must first delete its fk constraint on Product_Id, as we try to delete this table before the Products table
	-- NÅET HERTIL

	-- forsøg start

	-- Remove FK constraint on Category_Id in Products table
    declare @fk_name nvarchar(128);

    -- Find the name of the foreign key constraint between Products and Categories
    select @fk_name = fk.name
    from sys.foreign_keys as fk
    join sys.tables as t on fk.parent_object_id = t.object_id
    where object_name(fk.referenced_object_id) = 'Categories' and t.name = 'Products';

    -- Drop the foreign key constraint
    if @fk_name is not null
    begin
        exec('alter table Products drop constraint ' + @fk_name);
        print 'Success: Foreign key constraint on Category_Id in Products table has been dropped.';
    end
    else
    begin
        print 'Warning: No foreign key constraint found on Category_Id in Products table.';
    end

	-- forsøg slut



	drop table if exists Categories;
	if object_id('Categories', 'U') is not null
	begin
		print 'Failed: table Categories was not deleted';
	end
	else
	begin
		print 'Success: table Categories is deleted';
	end


	drop table if exists Products;
	if object_id('Products', 'U') is not null
	begin
		print 'Failed: table Products was not deleted';
	end
	else
	begin
		print 'Success: table Products is deleted';
	end


	-- validate all tables are deleted in test db
	declare @tableCount int;

	select @tableCount = count(*) from information_schema.tables;

	if @tableCount = 0
	begin
		print 'Successfull: all tables in db are successfully deleted';
	end
	else
	begin
		print 'Error: db are not empty, ' + cast(@tableCount as nvarchar(10)) + ' tables remain:';
		--select table_name from information_schema.tables;

		--throw; -- throw error
	end

	commit transaction;
	--print 'Successfull: Rollback plan was successful';
end try
begin catch
	rollback transaction;
	print 'Error in rollback plan:' + error_message();
end catch
