using StockAppWebApi2.Models;

namespace StockAppWebApi2.Services
{
    public interface IQuoteService
    {
        Task<List<RealtimeQuote>?> GetRealtimeQuotes(int page, int limit, string sector, string industry);

    }
}
