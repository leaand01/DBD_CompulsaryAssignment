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
drop table if exists Categories;
go

----------------------------------------------------------------------------

-- create table Products
create table Products (
	Product_Id int primary key,
	Name nvarchar(100) not null,
	Price decimal(10,2) not null
);
go

-- create table Categories
create table Categories (
	Category_Id int Primary Key,	
);
go

----------------------------------------------------------------------------

-- insert test data
insert into Products (Product_Id, Name, Price) values (1, 'Mug', '150');
insert into Products (Product_Id, Name, Price) values (2, 'Iphone', '5000');
insert into Products (Product_Id, Name, Price) values (3, 'Samsung TV', '10000');
go

insert into Categories (Category_Id) values (1);
insert into Categories (Category_Id) values (2);
go

----------------------------------------------------------------------------

-- Shema migration on table products

-- add new column to Products table
alter table Products
add Category_Id int; -- Having inserted data i cannot specify not null here.
go 

-- add value to new column Category_Id in table Products
update Products set Category_Id = 1 where Product_Id =  1; -- mug (category_id 1 = kitchen)
update Products set Category_Id = 2 where Product_Id =  2; -- Iphone (category_id 2 = electronics)
update Products set Category_Id = 2 where Product_Id =  3; -- Samsung TV
go

-- here specify Category_Id cannot be null in Products table
alter table Products
alter column Category_Id int not null;
go

-- Setup foreign key between Products and Categories tables on column Category_Id
alter table Products
add constraint fk_category
foreign key (Category_Id) references Categories(Category_Id);
go

----------------------------------------------------------------------------

-- Test

-- test tables are created
if object_id('Products') is not null and object_id('Categories') is not null
	print 'Successfull: Tables Products and Categories are created successfully';
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


-- test inserted data is correct
declare
	@productCount int,
	@CategoriesCount int;

select @productCount = count(*) from Products;
select @CategoriesCount = count(*) from Categories;

if @productCount = 3 and @CategoriesCount = 2
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

----------------------------------------------------------------------------

-- remove tables from e-commerce_test
drop table if exists Products;
drop table if exists Categories;
go

-- Remark, potential improvements:
-- add shcema migration to Categories and add category_name such as electronics etc.
