using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// gettravellist 的摘要说明
    /// </summary>
    public class gettravellist : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            if (context.Request["cityid"] != null && context.Request["idlist"] != null)
            {
                var idlist = context.Request["idlist"];
                var bll = new HotLineBLL();
                var results = new List<object>();
                int cityid = 0;
                if (int.TryParse(context.Request["cityid"], out cityid))
                {
                    var list = bll.GetHotLineList(cityid, 1);
                    var linetheme = new BLL.TravelthemeBll();
                    var resultlist = new List<HotLineModelExt>();
                    if (context.Request["idlist"] != "0")
                    {
                        var data = linetheme.GetLineThemeList("themeid=" + context.Request["idlist"]);
                        for (int i = 0; i < data.Rows.Count; i++)
                        {
                            resultlist.AddRange(list.Where(p => p.HotLineId == int.Parse(data.Rows[i]["lineid"].ToString())));
                        }
                    }
                    else
                    {
                        resultlist = list;
                    }

                    var linelist = (from m in resultlist select (m.StartPlace + '-' + m.EndPlace)).Distinct();


                    foreach (var line in linelist)
                    {
                        var linename = line;
                        var firtModel = (from m in resultlist
                                         where (m.StartPlace + '-' + m.EndPlace) == linename
                                         select m).First();

                        var spotInfo = (from m in resultlist
                                        where (m.StartPlace + '-' + m.EndPlace) == linename
                                        select new
                                        {
                                            StartPlace = m.StartPlace,
                                            EndPlace = m.EndPlace,
                                            HotLineId = m.HotLineId,
                                            LineName = linename,
                                            Summary = m.Summary,
                                            SpotPrice = m.SpotPrice,
                                            SpotImg = m.SpotImgUrl,
                                            FirstNum = firtModel.Num,
                                            FirstPrice = firtModel.StartPrice,
                                            Includes = firtModel.FeeIncludes,
                                            RentCarId = firtModel.RentCarId,
                                            HourPrice = firtModel.HourPrice,
                                            KiloPrice = firtModel.HourPrice,
                                            StartPrice = firtModel.StartPrice,
                                            OriginPrice = (new RentCarBLL()).GetModel(firtModel.RentCarId).startPrice,
                                            ThemeList=m.ThemeList
                                        }).Distinct().FirstOrDefault();


                        var rentInfo = from m in resultlist
                                       where (m.StartPlace + '-' + m.EndPlace) == linename
                                       select new
                                       {
                                           RentCarId = m.RentCarId,
                                           CarTypeName = m.CarTypeName,
                                           Price = m.StartPrice,
                                           CarBrands = (new CarBrandBLL()).GetBrandByRentID(m.RentCarId)
                                       };
                        results.Add(new
                        {
                            SpotInfo = spotInfo,
                            RentInfo = rentInfo
                        });

                    }
                    context.Response.Write(JsonConvert.SerializeObject(new { Data = results, CodeId = 1 }));
                    return;
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { CodeId = 1 }));
                    return;
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new { CodeId = 1 }));
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