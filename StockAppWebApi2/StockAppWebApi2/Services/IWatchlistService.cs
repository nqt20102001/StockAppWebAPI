using StockAppWebApi2.Models;
using StockAppWebApi2.ViewModels;

namespace StockAppWebApi2.Services
{
    public interface IWatchlistService
    {
        Task AddStockToWatchlist(int userId, int stockId);
        Task<Watchlist?> GetWatchlist(int userId, int stockId);
    }
}
