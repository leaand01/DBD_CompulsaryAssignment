//using System;
using System.ComponentModel.DataAnnotations; // for datavalidation en primary key
//using System.ComponentModel.DataAnnotations.Schema; // for database related attributes

namespace ECommerceApp
{
    public class Product
    {
        public int ProductId { get; set; } // EF Core sets this automatically to be the primary key as it is the name of the class followed by Id

        [Required] // Ensures not null
        public string Name { get; set; }

        [Required]
        public decimal Price { get; set; }
    }
}
