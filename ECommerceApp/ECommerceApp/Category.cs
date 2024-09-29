//using System;
using System.ComponentModel.DataAnnotations; // for datavalidation en primary key
//using System.ComponentModel.DataAnnotations.Schema; // for database related attributes

namespace ECommerceApp
{
    public class Category
    {
        public int CategoryId { get; set; } // Primary key

        [Required] // Ensures not null
        public string CategoryName { get; set; }
    }
}

/*
 * Remark:
 * In migration
 * CreateCategoriesTableAndAddCategoryIdToProductsTableAsForeignKey
 * both the Categories table were created and the column CategoryId was added to the Products table as a foreign key.
 * Thus if rollback this migration, both the CategoryId column will be removed from table Products and the table Categores will be deleted.
 * We might not want to do both at the same time.
 * Therefore next time split it up into two migrations, eg.: migration-step1: create new table, migration-step2: add any foreign keys to
 * existing tables.
 * This way we can rollback with necessarily deleting tables we may not want to delete.
 * 
 * Updated remark:
 * Removed above migration and split it into 2 migration as descriped above.
 */