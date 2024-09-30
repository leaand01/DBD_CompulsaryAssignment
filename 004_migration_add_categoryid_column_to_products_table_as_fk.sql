-- If column Category_Id do not exist in Products table
if not exists (select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'Products' and COLUMN_NAME = 'Category_Id' and TABLE_SCHEMA = 'dbo')
begin
	-- add new column to Products table
	alter table Products
	add Category_Id int; -- In case Products table already have data cannot specify not null here.


	-- Setup foreign key between Products and Categories tables on column Category_Id
	alter table Products
	add constraint fk_category
	foreign key (Category_Id) references Categories(Category_Id);
end
