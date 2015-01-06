using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using BLL;
using DAL;
using System.Web.Script.Serialization;
namespace WebApp.api
{
    /// <summary>
    /// RentCar 的摘要说明
    /// </summary>
    public class RentCar : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}