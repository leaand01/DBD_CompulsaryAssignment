-- add new column to Products table
alter table Products
add Category_Id int; -- In case Products table already have data cannot specify not null here.
go

/*
alter table Products
alter column Category_Id int not null; -- add null constraint here instead
go
*/

-- Setup foreign key between Products and Categories tables on column Category_Id
alter table Products
add constraint fk_category
foreign key (Category_Id) references Categories(Category_Id);
