using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public interface IWatchlistRepository
    {
        Task AddStockToWatchlist(int userId, int stockId);
        Task<Watchlist?> GetWatchlist(int userId, int stockId);
    }
}
