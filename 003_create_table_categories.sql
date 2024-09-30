-- Create table Categories if do not exist
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Categories' and TABLE_SCHEMA = 'dbo')
begin
	create table Categories (
		Category_Id int Primary Key
	);
end
