using StockAppWebApi2.Models;

namespace StockAppWebApi2.Services
{
    public interface IStockService
    {
        Task<Stock?> GetStockById(int stockId);
    }
}
