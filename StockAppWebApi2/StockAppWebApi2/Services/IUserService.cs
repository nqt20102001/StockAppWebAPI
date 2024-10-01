using StockAppWebApi2.Models;
using StockAppWebApi2.ViewModels;

namespace StockAppWebApi2.Services
{
    public interface IUserService
    {
        Task<User?> GetUserById(int userId);
        Task<User?> Register(RegisterViewModel registerViewModel);

        // String : Json Web Token string
        Task<string> Login(LoginViewModel loginViewModel);
    }
}
