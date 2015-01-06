using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// GetServiceCity 的摘要说明
    /// </summary>
    public class GetServiceCity : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string carusewayID = context.Request["caruseway"];
            string provinceid = context.Request["province"];
            string cityid = context.Request["city"];
            string countryid = context.Request["country"];
            if (!string.IsNullOrEmpty(countryid))
            {
                var rentcarResults = new BLL.RentCarBLL().GetServiceCity(int.Parse(carusewayID), int.Parse(provinceid), int.Parse(cityid), int.Parse(countryid));
                List<BLL.BLLExpand.CityFullBLL> cityLists = new List<BLL.BLLExpand.CityFullBLL>();
                foreach (var item in rentcarResults)
                {
                    cityLists.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
                }
                JsonConvert.SerializeObject(new { rentcarResults = rentcarResults, cityLists = cityLists });
                return;
            }
            if (!string.IsNullOrEmpty(cityid))
            {
                 var rentcarResults = new BLL.RentCarBLL().GetServiceCity(int.Parse(carusewayID), int.Parse(provinceid), int.Parse(cityid));
                List<BLL.BLLExpand.CityFullBLL> cityLists = new List<BLL.BLLExpand.CityFullBLL>();
                foreach (var item in rentcarResults)
                {
                    cityLists.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
                }
                JsonConvert.SerializeObject(new { rentcarResults = rentcarResults, cityLists = cityLists });
                return;
            }
            if (!string.IsNullOrEmpty(provinceid))
            {
                 var rentcarResults = new BLL.RentCarBLL().GetServiceCity(int.Parse(carusewayID), int.Parse(provinceid));
                List<BLL.BLLExpand.CityFullBLL> cityLists = new List<BLL.BLLExpand.CityFullBLL>();
                foreach (var item in rentcarResults)
                {
                    cityLists.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
                }
                JsonConvert.SerializeObject(new { rentcarResults = rentcarResults, cityLists = cityLists });
                return;
            }
            if (!string.IsNullOrEmpty(carusewayID))
            {
                var rentcarResults = new BLL.RentCarBLL().GetServiceCity(int.Parse(carusewayID));
                List<BLL.BLLExpand.CityFullBLL> cityLists = new List<BLL.BLLExpand.CityFullBLL>();
                foreach (var item in rentcarResults)
                {
                    cityLists.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
                }
                JsonConvert.SerializeObject(new { rentcarResults = rentcarResults, cityLists = cityLists });
                return;
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