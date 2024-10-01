using Microsoft.AspNetCore.Mvc;
using StockAppWebApi2.Filters;

namespace StockAppWebApi2.Attributes
{
    public class JwtAuthorizeAttribute : TypeFilterAttribute
    {
        public JwtAuthorizeAttribute() : base(typeof(JwtAuthorizeFilter))
        {
        }
    }
}
