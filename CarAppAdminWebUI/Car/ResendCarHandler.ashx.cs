using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using BLL;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// 车辆改派记录
    /// </summary>
    public class ResendCarHandler : IHttpHandler
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        public void ProcessRequest(HttpContext context)
        {
            // 调用查询
            GetResendCarRecord(context);
        }

        #region 根据条件查询车辆改派记录
        /// <summary>
        /// 根据条件查询车辆改派记录
        /// </summary>
        /// <param name="context"></param>
        private void GetResendCarRecord(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string starDate = context.Request["startDate"];
            string endDate = context.Request["endDate"];
            string userName = context.Request["username"];
            string carNo = context.Request["carNo"];
            string sort = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式
            var list = _carInfoBll.GetResendCar(pageIndex, pageSize, starDate, endDate, userName, carNo,sort, out count);
            var foot = new List<object>() { new { orderid = "", exten = "<span style='color:red;font-size:15px;font-weight:bold'>改派次数总计：</span>" + count + "辆", } };
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