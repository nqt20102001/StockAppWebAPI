using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public interface IStockRepository
    {
        Task<Stock?> GetStockById(int stockId); 
    }
}
