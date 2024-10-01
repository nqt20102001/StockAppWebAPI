using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StockAppWebApi2.Models
{
    [Table("Users")]  // Đặt tên bảng là "Users"
    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Column("user_id")]  // Tên cột là "user_id"
        public int UserId { get; set; }

        [Required(ErrorMessage = "Username is required")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Username must be between 6 and 100 characters")]
        [Column("username")]  // Tên cột là "username"
        public string? Username { get; set; }

        [Required(ErrorMessage = "Password is required")]
        [StringLength(200, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters long")]
        [Column("hashed_password")]  // Tên cột là "hashed_password"
        public string HashedPassword { get; set; } = "";  // Mật khẩu đã được hash

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        [Column("email")]  // Tên cột là "email"
        public string Email { get; set; } = "";

        [Required(ErrorMessage = "Phone number is required")]
        [RegularExpression(@"^\+?\d{10,15}$", ErrorMessage = "Invalid phone number")]
        [Column("phone")]  // Tên cột là "phone"
        public string? Phone { get; set; }

        [StringLength(255, ErrorMessage = "Full name can't be longer than 255 characters")]
        [Column("full_name")]  // Tên cột là "full_name"
        public string? FullName { get; set; }

        //[DataType(DataType.Date, ErrorMessage = "Invalid date format")]
        [Column("date_of_birth")]  // Tên cột là "date_of_birth"
        public DateTime? DateOfBirth { get; set; }

        [StringLength(200, ErrorMessage = "Country name can't be longer than 200 characters")]
        [Column("country")]  // Tên cột là "country"
        public string? Country { get; set; }

        // Navigation property
        public ICollection<Watchlist>? Watchlists { get; set; }
    }
}
