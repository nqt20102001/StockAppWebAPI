using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public interface IQuoteRepository
    {
        Task<List<RealtimeQuote>?> GetRealtimeQuotes(int page, int limit, string sector, string industry);

        //Task<List>
    }
}
