using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace StockAppWebApi2.ViewModels
{
    public class RegisterViewModel
    {
        public string? Username { get; set; }

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email format")]
        public string Email { get; set; } = "";

        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; } = "";

        [Required(ErrorMessage = "You must enter your phone")]
        public string Phone { get; set; } = "";
        public string? FullName { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string? Country { get; set; }
    }
}
