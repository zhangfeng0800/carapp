using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// getCity 的摘要说明
    /// </summary>
    public class getCity : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string prarent = context.Request["prarent"];
            var provice = new BLL.CityBLL().GetList().Where(s => s.ParentId.Trim() == prarent);
            string result = "<option value='-1'>请选择</option>";
            foreach (var item in provice)
            {
                result += "<option value='" + item.CodeId + "'>" + item.CityName + "</option>";
            }
            context.Response.Write(result);
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