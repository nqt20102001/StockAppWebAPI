using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using StockAppWebApi2.Models;
using StockAppWebApi2.ViewModels;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace StockAppWebApi2.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly StockAppContext _context;
        private readonly IConfiguration _config;

        public UserRepository(StockAppContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // Tìm User bằng userId
        public async Task<User?> GetUserById(int userId)
        {
            return await _context.Users.FindAsync(userId);
        }

        // Tìm User bằng Username
        public async Task<User?> GetUserByUsername(string username)
        {
            return await _context.Users.SingleOrDefaultAsync(u => u.Username == username);
        }

        // Tìm User bằng Email
        public async Task<User?> GetUserByEmail(string email)
        {
            return await _context.Users.SingleOrDefaultAsync(u => u.Email == email);
        }

        // Tạo mới User
        public async Task<User?> CreateUser(RegisterViewModel registerViewModel)
        {
            string sql = "execute dbo.RegisterUser @username, @password, @email, @phone, @full_name, @date_of_birth, @country";
            // Đoạn này sẽ gọi 1 procedure trong SQL Server để tạo mới User
            
            IEnumerable<User> result = await _context.Users.FromSqlRaw(sql,
                new SqlParameter("@username", registerViewModel.Username ?? ""),
                new SqlParameter("@password", registerViewModel.Password),
                new SqlParameter("@email", registerViewModel.Email),
                new SqlParameter("@phone", registerViewModel.Phone ?? ""),
                new SqlParameter("@full_name", registerViewModel.FullName ?? ""),
                new SqlParameter("@date_of_birth", registerViewModel.DateOfBirth),
                new SqlParameter("@country", registerViewModel.Country ?? "")).ToListAsync();
            
            User? user = result.FirstOrDefault();
            return user;
        }

        // Đăng nhập
        public async Task<string> Login(LoginViewModel loginViewModel)
        {
            string sql = "execute dbo.CheckLogin @password, @email";
            // Đoạn này sẽ gọi 1 procedure trong SQL Server để tạo mới User
            IEnumerable<User> result = await _context.Users.FromSqlRaw(sql,
                new SqlParameter("@email", loginViewModel.Email),
                new SqlParameter("@password", loginViewModel.Password)).ToListAsync();

            User? user = result.FirstOrDefault();
            //
            if(user != null)
            {
                // Tạo ra JWT String
                // Nếu xác thực thành công, trả về chuỗi JWT
                var tokenHandler = new JwtSecurityTokenHandler();
                var keyString = _config["Jwt:SecretKey"];
                if (string.IsNullOrEmpty(keyString))
                {
                    throw new ArgumentException("JWT Secret Key is missing or empty.");
                }
                var key = Encoding.ASCII.GetBytes(keyString);

                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                        new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString())
                    }),
                    Expires = DateTime.UtcNow.AddDays(30),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };

                var token = tokenHandler.CreateToken(tokenDescriptor);
                var jwtToken = tokenHandler.WriteToken(token);

                return jwtToken;
            }
            else
            {
                throw new Exception("Wrong user or password.");
            }
        }
    }
}
