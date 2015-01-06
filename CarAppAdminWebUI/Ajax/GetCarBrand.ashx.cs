using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetCarBrand 的摘要说明
    /// </summary>
    public class GetCarBrand : IHttpHandler
    {
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var list = _carBrandBll.GetAllCarBrand();
            context.Response.Write(JsonConvert.SerializeObject(list));
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