use [e-commerce];

create table Products (
	Product_Id int primary key,
	Name nvarchar(100) not null,
	Price decimal(10,2) not null
);
