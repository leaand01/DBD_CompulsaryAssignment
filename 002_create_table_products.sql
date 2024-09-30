-- Create table Products if do not exist
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Products' and TABLE_SCHEMA = 'dbo')
begin
	create table Products (
	Product_Id int primary key,
	Name nvarchar(100) not null,
	Price decimal(10,2) not null
	);
end
