using StockAppWebApi2.Models;
using StockAppWebApi2.ViewModels;

namespace StockAppWebApi2.Repositories
{
    public interface IUserRepository
    {
        Task<User?> GetUserById(int userId);
        Task<User?> GetUserByUsername(string username);
        Task<User?> GetUserByEmail(string email);

        Task<string> Login(LoginViewModel loginViewModel);
        Task<User?> CreateUser(RegisterViewModel registerViewModel);
        //Task<User> UpdateUser(User user);
        //Task<User> DeleteUser(int userId);
    }   
}
