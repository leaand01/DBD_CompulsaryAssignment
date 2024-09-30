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


-- Drop column Category_Id from table Products
alter table Products drop column Category_Id;

-- Remark: redundant to remove null constraint on Category_Id in Products table as the column is removed.
