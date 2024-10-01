﻿using StockAppWebApi2.Models;
using StockAppWebApi2.Repositories;

namespace StockAppWebApi2.Services
{
    public class QuoteService : IQuoteService
    {
        private readonly IQuoteRepository _quoteRepository;

        public QuoteService(IQuoteRepository quoteRepository)
        {
            _quoteRepository = quoteRepository;
        }
        public async Task<List<RealtimeQuote>?> GetRealtimeQuotes(int page, int limit, string sector, string industry)
        {
            return await _quoteRepository.GetRealtimeQuotes(page, limit, sector, industry);
        }
    }
}
