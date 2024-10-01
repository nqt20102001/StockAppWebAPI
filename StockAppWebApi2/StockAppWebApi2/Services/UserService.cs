using StockAppWebApi2.Models;
using StockAppWebApi2.Repositories;
using StockAppWebApi2.ViewModels;

namespace StockAppWebApi2.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;

        public UserService(IUserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        public async Task<User?> GetUserById(int userId)
        {
            User? user = await _userRepository.GetUserById(userId);
            return user;
        }

        public async Task<string> Login(LoginViewModel loginViewModel)
        {
            return await _userRepository.Login(loginViewModel);

        }

        public async Task<User?> Register(RegisterViewModel registerViewModel)
        {
            // Kiểm tra xem Username đã tồn tại chưa
            var existingUser = await _userRepository.GetUserByUsername(registerViewModel.Username ?? "");
            if (existingUser != null)
            {
                throw new ArgumentException("Username already exists");
            }

            // Kiểm tra xem Email đã tồn tại chưa
            existingUser = await _userRepository.GetUserByEmail(registerViewModel.Email);
            if (existingUser != null)
            {
                throw new ArgumentException("Email already exists");
            }

            // Tạo mới User
            return await _userRepository.CreateUser(registerViewModel);

        }

    }
}
