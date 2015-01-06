using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// Get_airport_service 的摘要说明
    /// </summary>
    public class Get_airport_service : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string provinceid = context.Request["province"];
            string cityid = context.Request["city"];
            string countryid = context.Request["country"];
            var airPortList = new BLL.AirportBLL().GetList();
            var cityList = new List<BLL.BLLExpand.CityFullBLL>();
            if (!string.IsNullOrEmpty(countryid))
            {
                airPortList = (from a in airPortList where a.countyId == int.Parse(countryid) select a).ToList();
                context.Response.Write(JsonConvert.SerializeObject(airPortList));
                return;
            }
            if (!string.IsNullOrEmpty(cityid))
            {
                cityList = removeRepeat("country", airPortList.Where(s=>s.CityId==int.Parse(cityid)).ToList());
                context.Response.Write(JsonConvert.SerializeObject(cityList));
                return;
            }
            if (!string.IsNullOrEmpty(provinceid))
            {
                cityList = removeRepeat("city", airPortList.Where(s=>s.ProvenceID==provinceid).ToList());
                context.Response.Write(JsonConvert.SerializeObject(cityList));
                return;
            }
            else
            {
                cityList = removeRepeat("province", airPortList);
                context.Response.Write(JsonConvert.SerializeObject(cityList));
                return;
            }
        }
        public List<BLL.BLLExpand.CityFullBLL> removeRepeat(string type, List<Model.AirPort> datas)
        {
            var result = new List<Model.AirPort>();
            var cityResult = new List<BLL.BLLExpand.CityFullBLL>();
            switch (type)
            {
                case "province":
                    {
                        var typeList = from t in datas group t by t.ProvenceID into g select g;
                        foreach (var item in typeList)
                        {
                            result.Add((from d in datas where d.ProvenceID == item.Key select d).ToList().FirstOrDefault());
                        }
                        break;
                    }
                case "city":
                    {
                        var typeList = from t in datas group t by t.CityId into g select g;
                        foreach (var item in typeList)
                        {
                            result.Add((from d in datas where d.CityId == item.Key select d).ToList().FirstOrDefault());
                        }
                        break;
                    }

                case "country":
                    {
                        var typeList = from t in datas group t by t.countyId into g select g;
                        foreach (var item in typeList)
                        {
                            result.Add((from d in datas where d.countyId == item.Key select d).ToList().FirstOrDefault());
                        }
                        break;
                    }
                default:
                    return null;
            }
            foreach (var item in result)
            {
                cityResult.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
            }
            return cityResult;
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