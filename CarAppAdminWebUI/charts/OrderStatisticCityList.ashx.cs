using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.charts
{
    /// <summary>
    /// OrderStatisticCityList 的摘要说明
    /// </summary>
    public class OrderStatisticCityList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var type = context.Request["type"];
            var data = (new CityBLL()).GetOrderCityList();
            switch (type)
            {
                case "province":
                    context.Response.Write(JsonConvert.SerializeObject((from d in data.AsEnumerable() select new { cityname = d["provincename"].ToString().Trim(), codeid = d["provincecode"].ToString().Trim() }).ToList().Distinct()));
                    break;
                case "city":
                    context.Response.Write(JsonConvert.SerializeObject((from d in data.AsEnumerable() where d["provincecode"].ToString().Trim() == context.Request["code"].ToString().Trim() select new { cityname = d["cityname"].ToString().Trim(), codeid = d["citycode"].ToString().Trim() }).ToList().Distinct()));
                    break;
                case "town":
                    context.Response.Write(JsonConvert.SerializeObject((from d in data.AsEnumerable() where d["citycode"].ToString().Trim() == context.Request["code"].ToString().Trim() select new { cityname = d["townname"].ToString().Trim(), codeid = d["towncode"].ToString().Trim() }).ToList().Distinct()));
                    break;
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