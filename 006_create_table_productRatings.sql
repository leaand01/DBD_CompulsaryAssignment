-- Create table ProductRatings if do not exist
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'ProductRatings' and TABLE_SCHEMA = 'dbo')
begin
	create table ProductRatings (
		Rating_Id int primary key identity(1,1),  --identity(1,1) ensures a Rating_id is automatically assigned
		Product_Id int not null,
		Rating int null,
		Rating_timestamp datetime not null default getdate(), -- automatically insert current timestamp when a rating is created
		foreign key (Product_Id) references Products(Product_Id)
	);
end
