using Microsoft.AspNetCore.Mvc;
using StockAppWebApi2.Models;
using StockAppWebApi2.Services;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;

namespace StockAppWebApi2.Controllers
{
    [ApiController]
    [Route("api/[controller]")] 
    public class QuoteController : ControllerBase
    {

        private readonly IQuoteService _quoteService;
        public QuoteController(IQuoteService quoteService)
        {
            _quoteService = quoteService;
        }

        [HttpGet("ws")]
        // https://localhost:7260/api/quote/ws
        public async Task GetRealtimeQuotes(int page = 1, int limit = 10, string sector = "", string industry = "")
        {
            if (HttpContext.WebSockets.IsWebSocketRequest)
            {
                using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();
                while (webSocket.State == WebSocketState.Open)
                {
                    List<RealtimeQuote>? quotes = await _quoteService.GetRealtimeQuotes(page, limit, sector, industry);

                    string jsonString = JsonSerializer.Serialize(quotes);
                    var buffer = Encoding.UTF8.GetBytes(jsonString);

                    await webSocket.SendAsync(new ArraySegment<byte>(buffer), WebSocketMessageType.Text, true, CancellationToken.None);

                    await Task.Delay(2000);
                }
                await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Connection closed by the server", CancellationToken.None);
            }
            else
            {
                HttpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            }
        }
    }
}
