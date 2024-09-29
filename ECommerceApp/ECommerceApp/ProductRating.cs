using System.ComponentModel.DataAnnotations; // for datavalidation en primary key
using System.ComponentModel.DataAnnotations.Schema; // for database related attributes (e.g. setup of ForeignKey)

namespace ECommerceApp
{
    public class ProductRating
    {
        [Key]
        public int RatingId { get; set; } // Specify this is the tables Primary key

        [Required] // Ensures not null
        public int Rating { get; set; }

        [Required]
        public DateTime RatingTimestamp { get; set; } = DateTime.Now; // automatically set RatingTimestamp to current time when created


        [ForeignKey("ProductId")] // Specify the foreign key
        public Product Product { get; set; } // specify table the foreign key references to

        public int ProductId { get; set; } // Create column ProductId in this table where specified as FK referencing to table Products
    }
}