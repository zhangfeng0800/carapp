using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using BLL;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarCityNum1 的摘要说明
    /// </summary>
    public class CarCityNum1 : IHttpHandler
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        public void ProcessRequest(HttpContext context)
        {
            GetCarCityNum(context);
        }

        #region 根据省市县获取城市车辆数
        /// <summary>
        /// 根据省市县获取城市车辆数
        /// </summary>
        /// <param name="context">请求参数</param>
        private void GetCarCityNum(HttpContext context)
        {
            int count = 0;
            int carCount = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string province = context.Request["province"] == null ? "13" : context.Request["province"];
            string city = context.Request["city"] == null ? "" : context.Request["city"];
            string county = context.Request["town"] == null ? "" : context.Request["town"];
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式

            var list = _carInfoBll.GetCityCarNum(pageIndex, pageSize, province, city, county,sort, out count,ref carCount);
            var foot = new List<object>() { new { countyName = "<span style='color:red;font-size:15px;font-weight:bold'>车辆总计：</span>" , carNum =carCount + "辆",cx="" } };
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
        }
        #endregion




        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}