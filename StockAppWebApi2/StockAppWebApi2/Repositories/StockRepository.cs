﻿using StockAppWebApi2.Models;

namespace StockAppWebApi2.Repositories
{
    public class StockRepository : IStockRepository
    {

        private readonly StockAppContext _context;

        public StockRepository(StockAppContext context)
        {
            _context = context;
        }

        public async Task<Stock?> GetStockById(int stockId)
        {
            return await _context.Stocks.FindAsync(stockId);
        }
    }
}
