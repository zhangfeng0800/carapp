using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetAllCarUseWay 的摘要说明
    /// </summary>
    public class GetAllCarUseWay : IHttpHandler
    {
        private readonly CarUseWayBLL _carUseWay = new CarUseWayBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var list = _carUseWay.GetAllCarUseWay();
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