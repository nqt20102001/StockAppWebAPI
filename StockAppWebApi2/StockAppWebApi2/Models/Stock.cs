using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace StockAppWebApi2.Models
{
    [Table("Stocks")]  // Tên bảng là "Stocks"
    public class Stock
    {
        [Key]
        [Column("stock_id")]  // Tên cột là "stock_id"
        public int StockId { get; set; }

        [Required(ErrorMessage = "Symbol is required")]
        [StringLength(10, ErrorMessage = "Symbol cannot be longer than 10 characters")]
        [Column("symbol")]  // Tên cột là "symbol"
        public string? Symbol { get; set; }

        [Required(ErrorMessage = "Company name is required")]
        [StringLength(255, ErrorMessage = "Company name cannot be longer than 255 characters")]
        [Column("company_name")]  // Tên cột là "company_name"
        public string? CompanyName { get; set; }

        [Column("market_cap", TypeName = "decimal(18,2)")]  // Tên cột là "market_cap"
        public decimal? MarketCap { get; set; }

        [StringLength(200, ErrorMessage = "Sector cannot be longer than 200 characters")]
        [Column("sector")]  // Tên cột là "sector"
        public string? Sector { get; set; }

        [StringLength(200, ErrorMessage = "Industry cannot be longer than 200 characters")]
        [Column("industry")]  // Tên cột là "industry"
        public string? Industry { get; set; }

        [StringLength(200, ErrorMessage = "Sector (English) cannot be longer than 200 characters")]
        [Column("sector_en")]  // Tên cột là "sector_en"
        public string? SectorEn { get; set; } 

        [StringLength(200, ErrorMessage = "Industry (English) cannot be longer than 200 characters")]
        [Column("industry_en")]  // Tên cột là "industry_en"
        public string? IndustryEn { get; set; } 

        [StringLength(50, ErrorMessage = "Stock type cannot be longer than 50 characters")]
        [Column("stock_type")]  // Tên cột là "stock_type"
        public string? StockType { get; set; }

        [Column("rank", TypeName = "int")]  // Tên cột là "rank"
        public int Rank { get; set; } = 0;

        [StringLength(200, ErrorMessage = "Rank source cannot be longer than 200 characters")]
        [Column("rank_source")]  // Tên cột là "rank_source"
        public string? RankSource { get; set; }

        [StringLength(255, ErrorMessage = "Reason cannot be longer than 255 characters")]
        [Column("reason")]  // Tên cột là "reason"
        public string? Reason { get; set; }

        public ICollection<Watchlist>? Watchlists { get; set; }
    }
}
