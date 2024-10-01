using Microsoft.EntityFrameworkCore;
using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public class WatchlistRepository : IWatchlistRepository
    {
        private readonly StockAppContext _context;
        private readonly IConfiguration _config;

        public WatchlistRepository(StockAppContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        public async Task AddStockToWatchlist(int userId, int stockId)
        {
            var watchlist = await _context.Watchlists.FindAsync(userId, stockId);
            if (watchlist == null)
            {
                watchlist = new Watchlist
                {
                    UserId = userId,
                    StockId = stockId
                };

                _context.Watchlists.Add(watchlist);
                await _context.SaveChangesAsync(); // Save changes to the database: Commit
            }
        }

        public async Task<Watchlist?> GetWatchlist(int userId, int stockId)
        {
            return await _context.Watchlists.FirstOrDefaultAsync(w => w.UserId == userId && w.StockId == stockId);
        }
    }
}
