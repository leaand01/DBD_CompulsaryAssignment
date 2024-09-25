-- create local test db if do not exist
if not exists (select * from sys.databases where name = 'e-commerce_test')
begin
	create database [e-commerce_test];
end
go

use [e-commerce_test];
go

-- drop tables in test db if exists
drop table if exists Products;
drop table if exists ProductRatings;
go

----------------------------------------------------------------------------

-- create table Products
create table Products (
	Product_Id int primary key,
	Name nvarchar(100) not null,
	Price decimal(10,2) not null
);
go

-- create table ProductRatings
create table ProductRatings (
	Rating_Id int primary key identity(1,1),  --identity(1,1) ensures a Rating_id is automatically assigned
	Product_Id int not null,
	Rating int null,
	Rating_timestamp datetime not null default getdate(), -- automatically insert current timestamp when a rating is created
	foreign key (Product_Id) references Products(Product_Id)
);
go

----------------------------------------------------------------------------

-- insert test data
insert into Products (Product_Id, Name, Price) values (1, 'Mug', '150');
insert into Products (Product_Id, Name, Price) values (2, 'Iphone', '5000');
insert into Products (Product_Id, Name, Price) values (3, 'Samsung TV', '10000');
go

insert into ProductRatings (Product_Id, Rating) values (1, 7);
insert into ProductRatings (Product_Id, Rating) values (1, 5);
insert into ProductRatings (Product_Id, Rating) values (2, 8);
insert into ProductRatings (Product_Id, Rating) values (3, 9);
go

----------------------------------------------------------------------------

-- Test

-- test tables are created
if object_id('Products') is not null and object_id('ProductRatings') is not null
	print 'Successfull: Tables Products and ProductRatings are created successfully';
else
	print 'Error in creation of tables';

-- test number of columns are correct in Products table
declare @ProductsColumnsCount int; 

select @ProductsColumnsCount = count(*) from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Products';

if @ProductsColumnsCount = 3
	print 'Successfull: Correct number of columns in table Products';
else
	print 'Error: incorrect number of columns in table Products';
-- Remark, potential refactor: could make this into a function as reused


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
	@productRatingsCount int;

select @productCount = count(*) from Products;
select @productRatingsCount = count(*) from ProductRatings;

if @productCount = 3 and @productRatingsCount = 4
	print 'Successfull: Data inserted correctly';
else
	print 'Error in insertion of data';


-- NÅET HERTIL
-- test foreign key constraint in ProductRatings:
-- insertion must fail as trying to create a non-existing Product_Id
begin try
	insert into ProductRatings (Product_Id, Rating) values (99, 7);
	print 'ERROR: foreign key constraint on Product_Id in table ProductRatings does not work';
end try
begin catch
	print 'Successfull: foreign key constraint works. Erroneous insertion fails (insertion of incorrect Product_Id)';
end catch;

-- insertion must fail as trying to create a null-value Product_Id
begin try
	insert into ProductRatings (Product_Id, Rating) values (null, 5);
	print 'ERROR: foreign key constraint on Product_Id in table ProductRatings does not work';
end try
begin catch
	print 'Successfull: foreign key constraint works. Erroneous insertion fails (insertion of null as Product_Id)';
end catch;

----------------------------------------------------------------------------

-- remove tables from e-commerce_test
drop table if exists ProductRatings;  -- ProductRatins must be deleted before Products due to the foreign key constraint
drop table if exists Products;
go
