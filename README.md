**Setting up project**

Ensure you have DB Browser for SQLite on your pc. Can be downloaded here: https://sqlitebrowser.org/dl/ . This is only for viewing the SQLite db and tables.

Open Visual Studio (VS) and select "Open a project or solution" and select the solution file: "insert-your-local-path\DBD_CompulsaryAssignment\ECommerceApp\ECommerceApp.sln".

Go to menu Tools - NuGet Package Manager - Package Manager Console to open the Package manager console. In the Package manager console run the command: update-database

You should now have created the SQLite db and applied all 4 migraitions. To roll back to an earlier migration, see section Rollback plan below.

In case the command "update-database" fails in the Package manager console, you might not have all the needed NuGet packages installed. The Packages used can be seen in VS in Solution Explorer under ECommerceApp - Dependencies - Packages which contains

- microsoft.entityframeworkcore 8.0.8
- microsoft.entityframeworkcore.sqlite 8.0.8
- microsoft.entityframeworkcore.tools 8.0.8

Instead of installing all these yourself in the project ECommerceApp, then go to menu Tools - NuGetPackage Manger - manage NuGet Packages for Solution,  and select Restore. 

Now your setup should be complete. Try again and run the command in the package manager console: update-database

For instructions on how go rollback to an earlier migration see section Rollback plan below.


**Rollback plan**

**How to execute a rollback in the EF Core framework**

The schema has been created in the following order:

1. Create table Products
2. Create table Categories
3. Add CategoryId, from table Categories, to the Products table as a foreign key
4. Create table ProductRatings with column ProductId as foreign key to the Products table

We can switch between these 4 version, where e.g. in version 2 only table Products and Categories have been created, but the CategoryId fk constraint has not yet been added to the Products table.

To go back to an earlier schema migration open Visual Studio and the package Manager Console and run the command:

Update-Database name-of-migration

The migration names can be seen in folder Migrations. If you want to migrate nr 2. migration above you only need to write

Update-Database CreateCategoriesTable

and not the whole filename:

Update-Database 20240928222606_CreateCategoriesTable

If you open the Migration files in Visual Studio you can see a description of what is done when you roll back/forward to that migration in the Down/up method, respectively. 

The Migration files are found here in VS in Solution Explorer: EcommerceApp - Migrations
