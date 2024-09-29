using Microsoft.EntityFrameworkCore;

namespace ECommerceApp
{
    public class ECommerceContext : DbContext  // Class ECommerceContext inherits from DBContext class
    {
        // Instructs EF Core to map class Product to a table called Products, i.e. table Products is created
        public DbSet<Product> Products { get; set; } 

        //public DbSet<Category> Categories { get; set; } // Tabel for kategorier
        //public DbSet<ProductRating> ProductRatings { get; set; } // Tabel for ratings

        // Configure a SQLite db called ecommerce.db in root folder og project.
        // Create db if do not exist
        protected override void OnConfiguring(DbContextOptionsBuilder options)
            => options.UseSqlite("Data Source=ecommerce.db"); // Angiv stien til SQLite-databasen
    }
}