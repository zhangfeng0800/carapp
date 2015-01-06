using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using IEZU.Log;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetDefaultCarInfo 的摘要说明
    /// </summary>
    public class GetDefaultCarInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (!string.IsNullOrEmpty(context.Request["telphone"]))
            {
                var telphone = context.Request["telphone"];
                var result = Common.MobileAddress.GetMobileAddress(telphone);
                if (result == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var provincename = result.province;

                var cityname = result.city;
                var citybll = new CityBLL();
                var alldata = citybll.GetAllCity();

                var provinceData = alldata.AsEnumerable().FirstOrDefault(p => p["provincename"].ToString() == provincename.Trim());
                if (provinceData == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var provinceid = provinceData["provinceid"].ToString();
                var citydata = (from m in alldata.AsEnumerable().Where(p => p["provincename"].ToString() == provincename.Trim())
                                select new
                                    {
                                        cityid = m["cityid"].ToString().Trim(),
                                        cityname = m["cityname"].ToString().Trim()
                                    }).Distinct().ToList();
                var defaultCity =
                    citydata.FirstOrDefault(
                        p =>
                            p.cityname.Trim() == cityname.Trim() ||
                            (cityname.IndexOf("市", System.StringComparison.Ordinal) > -1 &&
                             p.cityname.Trim() == cityname.Substring(0, cityname.Length - 1).Trim()));
                if (defaultCity == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                cityname = defaultCity.cityname.Trim();
                string cityid = defaultCity.cityid;
                var townlist = (from m in alldata.AsEnumerable()
                                where m["cityid"].ToString().Trim() == cityid.Trim()
                                select new { townid = m["townid"].ToString(), townname = m["townname"].ToString(),type=m["type"].ToString() });
                var servicebll = new ServiceCityBLL();
                var firstOrDefault = townlist.FirstOrDefault();
                if (firstOrDefault != null)
                {
                    var caruselist = servicebll.GetCarUse(firstOrDefault.townid);
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        provinceid = provinceid,
                        provincename = provincename,
                        citylist = citydata,
                        cityid = cityid,
                        cityname = cityname,
                        townlist = townlist,
                        caruselist = caruselist
                    }));
                    return;
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
            }
            else if (!string.IsNullOrEmpty(context.Request["defaultinfo"]) && !(string.IsNullOrEmpty(context.Request["caruseway"])))
            {
                try
                {
                    if (context.Request["caruseway"] != "2")
                    {
                        var provinceid = context.Request["provinceid"];
                        var citybll = new CityBLL();
                        var citydata = citybll.GetCityByProvince(int.Parse(provinceid));
                        var towndata = citybll.GetTownByCity(context.Request["cityid"].ToString());
                        context.Response.Write(
                            JsonConvert.SerializeObject(
                                new
                                {
                                    resultcode = 1,
                                    citydata = citydata,
                                    towndata = towndata
                                }));
                    }
                    else
                    {
                        var provinceid = context.Request["provinceid"];
                        var citybll = new CityBLL();
                        var citydata = citybll.GetCityByAirport(provinceid);
                        var towndata = citybll.GetTownByAirport(context.Request["cityid"]);
                        var airportdata = citybll.GetAirportByTown(context.Request["townid"]);
                        context.Response.Write(
                         JsonConvert.SerializeObject(
                             new
                             {
                                 resultcode = 1,
                                 citydata = citydata,
                                 towndata = towndata,
                                 airportdate = airportdata
                             }));
                    }

                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                }

                return;
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
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