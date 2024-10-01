using StockAppWebApi2.Models;
using StockAppWebApi2.Repositories;
using StockAppWebApi2.ViewModels;

namespace StockAppWebApi2.Services
{
    public class WatchlistService : IWatchlistService
    {
        private readonly IWatchlistRepository _watchlistRepository;

        public WatchlistService(IWatchlistRepository watchlistRepository)
        {
            _watchlistRepository = watchlistRepository;
        }

        public async Task AddStockToWatchlist(int userId, int stockId)
        {
            await _watchlistRepository.AddStockToWatchlist(userId, stockId);
        }

        public async Task<Watchlist?> GetWatchlist(int userId, int stockId)
        {
            return await _watchlistRepository.GetWatchlist(userId, stockId);
        }

    }
}
