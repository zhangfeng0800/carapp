using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// DataStatistics 的摘要说明
    /// </summary>
    public class DataStatistics : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var account = new AccountBLL();
            var data = new DataTable();
            if (context.Request.Form["type"] == "total")
            {
                data = account.GetTotalInOutMoney(context.Request["startDate"], context.Request["endDate"]);
            }
            else if (context.Request.Form["type"] == "month")
            {
                data = account.GetMonthlyData(context.Request["startDate"], context.Request["endDate"]);
            }
            else if (context.Request.Form["type"] == "day")
            {
                data = account.GetDailyData(context.Request["startDate"], context.Request["endDate"]);
            }
            else if (context.Request["type"] == "hour")
            {
                data = account.GetHourlyData(context.Request["startDate"], context.Request["endDate"]);

            }
            else if (context.Request["type"] == "compare")
            {
                var startDate = context.Request["startData"];
                var endDate = context.Request["endDate"];
                try
                {
                    if (startDate != "" && endDate != "")
                    {
                        if (Convert.ToDateTime(startDate) >= Convert.ToDateTime(endDate))
                        {
                            context.Response.Write("0");
                            return;

                        }
                        else
                        {
                            context.Response.Write("1");
                            return;
                        }
                    }

                    else
                    {
                        context.Response.Write("0");
                        return;

                    }
                }
                catch
                {
                    context.Response.Write("0");
                    return;
                }
                return;

            }
            context.Response.Write(JsonConvert.SerializeObject(data));

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