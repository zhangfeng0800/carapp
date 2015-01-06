using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.PCenter.api
{
    /// <summary>
    /// GetRentCarList 的摘要说明
    /// </summary>
    public class GetRentCarList : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            int carUseWayID = int.Parse(context.Request["useWay"]);
            int countryID = int.Parse(context.Request["upCountryID"]);
            var result = new BLL.RentCarBLL().GetList(carUseWayID, countryID);
            var results = new List<BLL.BLLExpand.CarFullType>();
            foreach (var item in result)
            {
                results.Add(new BLL.BLLExpand.CarFullType(item));
            }
            context.Response.Write(JsonConvert.SerializeObject(results));
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