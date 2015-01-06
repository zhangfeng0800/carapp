using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetCarType 的摘要说明
    /// </summary>
    public class GetCarType : IHttpHandler
    {
        private readonly CarTypeBLL _carTypeBll = new CarTypeBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var list = _carTypeBll.GetDataTable();
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