using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarBrandList 的摘要说明
    /// </summary>
    public class CarBrandList : IHttpHandler
    {
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        public void ProcessRequest(HttpContext context)
        {
            string action = context.Request["action"];
            if(action == "list")
            {
                int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
                int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
                string keyword = context.Request["Keyword"];
                context.Response.ContentType = "text/plain";

                int count;
                // var list = _carBrandBll.GetPageList(pageSize, pageIndex, Common.Tool.SqlFilter(keyword), out count);
                var list = _carBrandBll.GetPageListPro(string.IsNullOrEmpty(keyword) ? "" : keyword, pageSize, pageIndex,
                                                       out count);
                context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
            }
            else
            {
                string brandId = context.Request["BrandId"];
                var list = _carBrandBll.GetCityAndNum(Int32.Parse(brandId));
                context.Response.Write(JsonConvert.SerializeObject(new {rows = list }));
            }
            
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