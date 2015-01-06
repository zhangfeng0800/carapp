using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Text;
using System.Web;
using BLL;
using Common;
using Model;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetPlaceApi 的摘要说明
    /// </summary>
    public class GetPlaceApi : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            var data = new CityBLL().GetAllCity();

            #region  呼叫中心选车的方法

            if (context.Request["action"] == "province" && context.Request["id"] == "0")
            {
                var result = (from m in data.AsEnumerable()
                              select new { name = m["provincename"].ToString(), id = m["provinceid"].ToString() }).Distinct()
                    .ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["action"] == "city" && context.Request["id"] != null)
            {
                var result =
                    (from m in data.AsEnumerable()
                     where m["provinceid"].ToString() == context.Request["id"]
                     select new { name = m["cityname"].ToString().Trim(), id = m["cityid"].ToString().Trim() })
                        .Distinct().ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["action"] == "town" && context.Request["id"] != null)
            {
                var result = (from m in data.AsEnumerable() where m["cityid"].ToString().Trim() == context.Request["id"].Trim() select new { name = m["townname"].ToString(), id = m["townid"] }).Distinct().ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["action"] == "caruse" && context.Request["id"] != null)
            {
                var cityId = context.Request.QueryString["id"];

                var bll = new ServiceCityBLL();
                var list = bll.GetCarUse(cityId);
                var townid = context.Request["id"];
                if (string.IsNullOrEmpty(townid))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var citybll = new CityBLL();
                var townData = citybll.GetTown(townid);
                if (townData.Rows.Count == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var result =
                    (from m in list select new { name = m.carusewayName, id = m.carusewayID }).Distinct().ToList();
                context.Response.Write(list.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result, type = townData.Rows[0]["type"].ToString() }));
                return;
            }
            else if (context.Request["action"] == "selectcar" && context.Request["id"] != null &&
                     context.Request["useid"] != "6")
            {
                var dt = new RentCarBLL().GetCarsInfo(context.Request.QueryString["id"],
                    Convert.ToInt32(context.Request.QueryString["useid"]));
                context.Response.Write(JsonConvert.SerializeObject(dt));

                return;
            }
            else if (context.Request["action"] == "selectcar" && context.Request["cityid"] != null &&
                     context.Request["hotlineid"] != null &&
                     context.Request["useid"] == "6" && context.Request["linetype"] != null)
            {
                var cityId = context.Request.QueryString["cityid"];
                var hotlineId = context.Request.QueryString["hotlineid"];
                var lineType = context.Request.QueryString["linetype"];
                DataTable dt = new RentCarBLL().GetCarsInfoHot(cityId, hotlineId, 6, lineType);


                context.Response.Write(JsonConvert.SerializeObject(dt));
                return;

            }
            else if (context.Request["action"] == "hotline" && context.Request["countyid"] != null)
            {
                var bll = new HotLineBLL();
                var result = bll.GetHotLineList(int.Parse(context.Request["countyid"].ToString()));
                if (result.Count == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        resultcode = 0
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        resultcode = 1,
                        data = (from m in result select new { name = m.EndPlace, id = m.HotLineId, sortorder = m.SortOrder }).Distinct().ToList()
                    }));
                }
                return;
            }
            else if (context.Request["action"] == "linetype" && context.Request["hotlineid"] != null &&
                     context.Request["cityid"] != null)
            {
                var result = (new HotLineBLL()).GetHotlineAllType(context.Request["cityid"].ToString(),
                    context.Request["hotlineid"].ToString());
                if (result.Rows.Count == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        resultcode = 0
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        resultcode = 1,
                        data = result
                    }));
                }
                return;
            }
            #endregion

            else if (context.Request["action"] == "airport" && context.Request["cityid"] != null)
            {

                if (string.IsNullOrEmpty(context.Request["cityid"]))
                {
                    context.Response.Write(
                        JsonConvert.SerializeObject(new { resultcode = "0", message = "请求参数错误" }));
                    return;
                }
                var bll = new AirportBLL();
                context.Response.Write(
                    JsonConvert.SerializeObject(bll.GetList((context.Request["cityid"]))));
                return;
            }
            if (context.Request["type"] == "province" && context.Request["id"] == "0")
            {
                var province = (new CityBLL()).GetProvince();
                var result = (from m in province.AsEnumerable()
                              select new { name = m["cityname"].ToString(), id = m["codeid"].ToString() }).Distinct()
                    .ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["type"] == "city" && context.Request["id"] != null)
            {
                var city = (new CityBLL()).GetCityByProvince(int.Parse(context.Request["id"]));
                var result =
                    (from m in city.AsEnumerable() select new { name = m["cityname"].ToString(), id = m["codeid"] })
                        .Distinct().ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["type"] == "town" && context.Request["id"] != null)
            {
                var town = (new CityBLL()).GetTownByCity(context.Request["id"]);
                var result =
                    (from m in town.AsEnumerable() select new { name = m["cityname"].ToString(), id = m["codeid"] })
                        .Distinct().ToList();
                context.Response.Write(result.Count == 0
                    ? JsonConvert.SerializeObject(new { resultcode = 0 })
                    : JsonConvert.SerializeObject(new { resultcode = 1, data = result }));
                return;
            }
            else if (context.Request["airporttype"] == "province" && context.Request["id"] == "0")
            {
                var bll = new CityBLL();
                var dt = bll.GetProvinceByAirport();
                context.Response.Write(dt.Rows.Count > 0
                    ? JsonConvert.SerializeObject(
                        new
                        {
                            resultcode = 1,
                            data =
                                (from m in dt.AsEnumerable()
                                 select new { name = m["cityname"].ToString(), id = m["codeid"].ToString() }).ToList()
                        })
                    : JsonConvert.SerializeObject(new { resultcode = 0, msg = "请求失败" }));
                return;
            }
            else if (context.Request["airporttype"] == "city" && context.Request["id"] != null)
            {
                var bll = new CityBLL();
                var result = bll.GetCityByAirport(context.Request.QueryString["id"]);
                context.Response.Write(data.Rows.Count > 0
                    ? JsonConvert.SerializeObject(
                        new
                        {
                            resultcode = 1,
                            data =
                                (from m in result.AsEnumerable()
                                 select new { name = m["cityname"].ToString(), id = m["codeid"].ToString() }).ToList()
                        })
                    : JsonConvert.SerializeObject(new { msg = "", resultcode = 0 }));
                return;
            }
            else if (context.Request["airporttype"] == "town" && context.Request["id"] != null)
            {
                string cityid = context.Request.QueryString["id"];
                var bll = new CityBLL();
                var result = bll.GetTownByAirport(cityid);
                context.Response.Write(data.Rows.Count > 0
                    ? JsonConvert.SerializeObject(
                        new
                        {
                            data =
                                (from m in result.AsEnumerable()
                                 select new { name = m["cityname"].ToString(), id = m["codeid"].ToString() }).ToList(),
                            resultcode = 1
                        })
                    : JsonConvert.SerializeObject(new { resultcode = 0 }));
                return;
            }
            else if (context.Request["airporttype"] == "airport" && context.Request["id"] != null)
            {
                if (string.IsNullOrEmpty(context.Request["id"]))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = "0", message = "请求参数错误" }));
                }
                else
                {
                    var bll = new AirportBLL();
                    var result = bll.GetList((context.Request["id"]));
                    if (result.Count > 0)
                    {
                        context.Response.Write(
                            JsonConvert.SerializeObject(
                                new
                                {
                                    resultcode = 1,
                                    data = (from m in result select new { name = m.AirPortName, id = m.Id })
                                }));
                    }
                }
            }
            else if (context.Request["rentcarid"] != null && context.Request["action"] == "hotplace")
            {
                var rentModel = (new RentCarBLL()).GetModel(int.Parse(context.Request["rentcarid"]));
                if (rentModel == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var hotlineid = rentModel.hotLineID;
                var hotModel = (new HotLineBLL()).GetModel(hotlineid);
                if (hotModel == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var townid = hotModel.countyId;
                var result = (new CityBLL()).GetFullResult(townid);
                if (result.Rows.Count == 0)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = result.Rows[0]["provincename"].ToString() + result.Rows[0]["citysname"].ToString() + result.Rows[0]["townname"], city = result.Rows[0]["citysname"].ToString() }));
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