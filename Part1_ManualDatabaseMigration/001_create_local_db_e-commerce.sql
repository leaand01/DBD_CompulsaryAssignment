-- Create local e-commerce db if do not exist
if not exists (select * from sys.databases where name = 'e-commerce')
begin
	create database [e-commerce];
end
go
