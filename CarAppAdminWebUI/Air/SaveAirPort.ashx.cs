using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Air
{
    /// <summary>
    /// SaveAirPort 的摘要说明
    /// </summary>
    public class SaveAirPort : IHttpHandler
    {
        private readonly AirportBLL _airportBll = new AirportBLL();
        public void ProcessRequest(HttpContext context)
        {
            var message = new AjaxResultMessage();
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "add")
            {
                Add(context,ref message);
            }
            else
            {
                Edit(context, ref message);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context,ref AjaxResultMessage message)
        {
            string airportName = context.Request["airportName"];
            string provenceID = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string lat = context.Request["lat"];
            string lng = context.Request["lng"];
            if (_airportBll.IsExist(airportName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此机场名称";
            }
            else
            {
                Model.AirPort model = new Model.AirPort();
                model.CityId = Convert.ToInt32(cityId);
                model.AirPortName = airportName;
                model.ProvenceID = provenceID;
                model.countyId = Convert.ToInt32(countyId);
                model.Lng = lng;
                model.Lat = lat;
                _airportBll.AddData(model);
                message.IsSuccess = true;
                message.Message = "";
            }
        }

        private void Edit(HttpContext context,ref AjaxResultMessage message)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            string airportName = context.Request["airportName"];
            string provenceID = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string lat = context.Request["lat"];
            string lng = context.Request["lng"];
            if (_airportBll.IsExist(id,airportName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此机场名称";
            }
            else
            {
                Model.AirPort model = new Model.AirPort();
                model.CityId = Convert.ToInt32(cityId);
                model.ProvenceID = provenceID;
                model.AirPortName = airportName;
                model.countyId = Convert.ToInt32(countyId);
                model.Lng = lng;
                model.Lat = lat;
                model.Id = id;
                _airportBll.UpdateData(model);
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