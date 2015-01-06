using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Air
{
    /// <summary>
    /// SaveAirPlane 的摘要说明
    /// </summary>
    public class SaveAirPlane : IHttpHandler
    {
        private readonly AirPlaneBLL _airPlaneBll = new AirPlaneBLL();
        public void ProcessRequest(HttpContext context)
        {
            var message = new AjaxResultMessage();
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "add")
            {
                Add(context, ref message);
            }
            else
            {
                Edit(context, ref message);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context, ref AjaxResultMessage message)
        {
            string provenceID = context.Request["provenceID"];
            string airportName = context.Request["airportName"];
            string planeNo = context.Request["planeNo"];
            string time = context.Request["time"];
            string arrivalTime = context.Request["arrivalTime"];
            if (_airPlaneBll.IsExist(airportName, planeNo))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此航班";
            }
            else
            {
                Model.AirPlane model = new Model.AirPlane()
                {
                    AirPortName=airportName,
                    PlaneNo=planeNo,
                    Time=time,
                    ArrivalTime=arrivalTime
                };
                _airPlaneBll.AddData(model);
                message.IsSuccess = true;
                message.Message = "";
            }
        }

        private void Edit(HttpContext context, ref AjaxResultMessage message)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            string provenceID = context.Request["provenceID"];
            string airportName = context.Request["airportName"];
            string planeNo = context.Request["planeNo"];
            string time = context.Request["time"];
            string arrivalTime = context.Request["arrivalTime"];
            if (_airPlaneBll.IsExist(id,airportName, planeNo))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此航班";
            }
            else
            {
                var model = new Model.AirPlane()
                {
                    Id=id,
                    AirPortName = airportName,
                    PlaneNo = planeNo,
                    Time = time,
                    ArrivalTime = arrivalTime
                };
                _airPlaneBll.UpdateData(model);
                message.IsSuccess = true;
                message.Message = "";
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