using System.ComponentModel.DataAnnotations; // for datavalidation en primary key
using System.ComponentModel.DataAnnotations.Schema; // for database related attributes (e.g. setup of ForeignKey)

namespace ECommerceApp
{
    public class Product
    {
        public int ProductId { get; set; } // EF Core sets this automatically to be the primary key as it is the name of the class followed by Id

        [Required] // Ensures not null
        public string Name { get; set; }

        [Required]
        public decimal Price { get; set; }


        [ForeignKey("CategoryId")] // Specify the foreign key
        public Category Category { get; set; } // specify table the foreign key references to

        public int CategoryId { get; set; } // Create column CategoryId in this table where specified as FK referencing to table Categories
    }
}
