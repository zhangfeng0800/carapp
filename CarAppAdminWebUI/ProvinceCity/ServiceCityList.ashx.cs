using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// ServiceCityList 的摘要说明
    /// </summary>
    public class ServiceCityList : IHttpHandler
    {
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        public void ProcessRequest(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string provenceId = context.Request["provenceID"];
            string cityId = context.Request["cityId"];
            context.Response.ContentType = "text/plain";
            //var list = _serviceCityBll.GetServiceCityJson(provenceId,pageIndex,pageSize,out count);

            var list = _serviceCityBll.GetServiceCityByProc(string.IsNullOrEmpty(provenceId)?"":provenceId, string.IsNullOrEmpty(cityId)?"":cityId, pageIndex, pageSize, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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