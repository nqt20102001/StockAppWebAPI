namespace StockAppWebApi2.Extensions
{
    public static class HttpContextExtention
    {
        public static int GetUserId(this HttpContext httpContext)
        {
            return httpContext.Items["UserId"] as int? ?? throw new Exception("User Id not found in context");
        }
    }
}
