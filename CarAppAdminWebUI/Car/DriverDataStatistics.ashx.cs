using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// DriverDataStatistics 的摘要说明
    /// </summary>
    public class DriverDataStatistics : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "agegroup")
            {
                context.Response.Write(JsonConvert.SerializeObject(new DirverAccountBLL().GetAgeGroup()));
            }
            else if (context.Request["action"] == "drivertime")
            {
                context.Response.Write(JsonConvert.SerializeObject(new DirverAccountBLL().GetDriverTime()));
            }
            else if (context.Request["action"] == "driverorder")
            {
                context.Response.Write(JsonConvert.SerializeObject((new DirverAccountBLL()).GetDriverOrder(context.Request["startDate"], context.Request["endDate"])));
            }
            else if (context.Request["action"] == "driverKm")
            {
                context.Response.Write(JsonConvert.SerializeObject((new DirverAccountBLL()).GetDriverServiceKm(context.Request["startDate"], context.Request["endDate"])));
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