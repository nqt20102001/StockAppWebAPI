using StockAppWebApi2.Models;
using StockAppWebApi2.Repositories;

namespace StockAppWebApi2.Services
{
    public class StockService : IStockService
    {
        private readonly IStockRepository _stockRepository;

        public StockService(IStockRepository stockRepository)
        {
            _stockRepository = stockRepository;
        }

        public async Task<Stock?> GetStockById(int stockId)
        {
            return await _stockRepository.GetStockById(stockId);
        }
    }
}
