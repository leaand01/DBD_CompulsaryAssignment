# DBD_CompulsaryAssignment

**Rollback plan**

**How to execute a rollback in the EF Core framework**

The schema has been created in the following order:

1. Create table Products
2. Create table Categories
3. Add CategoriId, from table Categories, to the Products table as a foreign key
4. Create table ProductRatings with column ProductId as foreign key to the Products table

We can switch between these 4 version, where e.g. in version 2 only table Products and Categories have been created, but the CategoryID fk constraint has not yet been added to the Products table.

To go back to an earlier schema migration open Visual Studio and the package Manager Console and run the command:

Update-Database name-of-migration

The migration names can be seen in folder Migrations. If you want to migrate nr 2. migration above you only need to write

Update-Database CreateCategoriesTable

and not the whole filename:

Update-Database 20240928222606_CreateCategoriesTable

If you open the Migration files in Visual Studio you can see a description of what is done when you roll back/forward to that migration.
