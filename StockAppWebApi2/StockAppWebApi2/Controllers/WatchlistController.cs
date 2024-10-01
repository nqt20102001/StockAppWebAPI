using Microsoft.AspNetCore.Mvc;
using StockAppWebApi2.Services;
using StockAppWebApi2.Attributes;
using StockAppWebApi2.Extensions;

namespace StockAppWebApi2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WatchlistController : ControllerBase
    {
        private readonly IWatchlistService _watchlistService;
        private readonly IUserService _userService;
        private readonly IStockService _stockService;

        public WatchlistController(IWatchlistService watchlistService, IUserService userService, IStockService stockService)
        {
            _watchlistService = watchlistService;
            _userService = userService;
            _stockService = stockService;
        }

        // https://localhost:7260/api/watchlist/addstocktowatchlist
        [HttpPost("addstocktowatchlist/{stockId}")]
        [JwtAuthorize]
        public async Task<IActionResult> AddStockToWatchlist(int stockId)
        {
            int userId = HttpContext.GetUserId();
            var user = await _userService.GetUserById(userId);
            var stock = await _stockService.GetStockById(stockId);

            if(user == null || stock == null)
            {
                return NotFound();
            }

            var existingWatchlist = await _watchlistService.GetWatchlist(userId, stockId);
            if(existingWatchlist != null)
            {
                return BadRequest("Stock is already in watchlist");
            }
            await _watchlistService.AddStockToWatchlist(1, stockId);
            return Ok();
        }
    }
}
