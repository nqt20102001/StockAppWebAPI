using Microsoft.EntityFrameworkCore;
using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public class QuoteRepository : IQuoteRepository
    {

        private readonly StockAppContext _context;
        public QuoteRepository(StockAppContext context)
        {
            _context = context;
        }
        public async Task<List<RealtimeQuote>?> GetRealtimeQuotes(int page, int limit, string sector, string industry)
        {
            var query = _context.RealtimeQuotes.Skip((page - 1) * limit).Take(limit);

            if(!string.IsNullOrEmpty(sector))
            {
                query = query.Where(q => (q.Sector ?? "").ToLower().Equals(sector.ToLower()));

            }
            if (!string.IsNullOrEmpty(industry))
            {
                query = query.Where(q => q.Industry == industry);
            }

            var quotes = await query.ToListAsync();
            return quotes;
        }
    }
}
