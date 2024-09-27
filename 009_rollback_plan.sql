use [e-commerce];
go

-- Rollback plan

-- Drop table ProductRatings
drop table if exists ProductRatings;


-- Drop table Categories
-- To delete Categories we must first delete its fk reference on Product_Id, as we try to delete this table before the Products table
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

drop table if exists Categories;


-- Drop column Category_Id from table Products
alter table Products drop column if exists Category_Id;


-- Drop table Products
drop table if exists Products;


print 'Notification: db e-commerce should now be empty / contain no tables';