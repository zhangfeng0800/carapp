using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getserviceplace 的摘要说明
    /// </summary>
    public class getserviceplace : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();
            var data = new DataTable();
            string type;
            int useid;
            string cityid;
            if (context.Request.Form["type"] != null && context.Request.Form["useid"] != null &&
                context.Request.Form["cityid"] != null)
            {
                try
                {
                    type = context.Request.Form["type"];
                    useid = int.Parse(context.Request.Form["useid"]);
                    cityid = context.Request.Form["cityid"];

                    if (type == "province")
                    {
                        data = bll.GetHotlineProvince(int.Parse(context.Request.Form["useid"]));
                    }
                    else if (type == "city")
                    {
                        data = bll.GetCityByProvince(int.Parse(cityid), useid);
                    }
                    else if (type == "town")
                    {
                        data = bll.GetTownByCity(int.Parse(cityid), useid);
                    }
                    data.Columns[0].ColumnName = "name";
                    data.Columns[1].ColumnName = "id";
                    context.Response.Write(data.Rows.Count > 0
                        ? JsonConvert.SerializeObject(new { CodeId = 1, Message = Message.SUCCESS, Data = data })
                        : JsonConvert.SerializeObject(new
                        {
                            CodeId = 0,
                            Message = Message.EMPTY
                        }));
                }
                catch (Exception exception)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0,
                        Message = Message.BADPARAMETERS
                    }));
                }
            }
            else if (context.Request.Form["istravel"] != null && context.Request.Form["cityid"] != null && context.Request.Form["type"] != null)
            {
                var rentbll = new RentCarBLL();
                try
                {
                    type = context.Request.Form["type"];

                    cityid = context.Request.Form["cityid"];

                    if (type == "province")
                    {
                        data = rentbll.GetTravelProvince();
                    }
                    else if (type == "city")
                    {
                        data = rentbll.GetTravelCity(cityid);
                    }
                    else if (type == "town")
                    {
                        data = rentbll.GetTravelTown(cityid);
                    }
                    data.Columns[0].ColumnName = "id";
                    data.Columns[1].ColumnName = "name";
                    context.Response.Write(data.Rows.Count > 0
                        ? JsonConvert.SerializeObject(new { CodeId = 1, Message = Message.SUCCESS, Data = data })
                        : JsonConvert.SerializeObject(new
                        {
                            CodeId = 0,
                            Message = Message.EMPTY
                        }));
                }
                catch (Exception exception)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        CodeId = 0,
                        Message = Message.BADPARAMETERS
                    }));
                }
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