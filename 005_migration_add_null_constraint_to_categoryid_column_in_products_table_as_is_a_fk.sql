-- add null constraint to fk Category_id in Products table
-- Note, this constraint is only possible if have specified values to column Category_Id in all rows in table Products (or there are no data in the table)
alter table Products
alter column Category_Id int not null;
