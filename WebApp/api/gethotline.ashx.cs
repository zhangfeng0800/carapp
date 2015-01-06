using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using BLL;
using Common;
using Model.Ext;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// gethotline 的摘要说明
    /// </summary>
    public class gethotline : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityId"] != null)
            {
                var startid = 0;
                if (int.TryParse(context.Request.QueryString["cityId"], out startid))
                {
                    int num = 0;
                    var bll = new HotLineBLL();
                    var data = bll.GetHotLineList(startid);
                    if (context.Request.QueryString["num"] != null)
                    {
                        if (!int.TryParse(context.Request.QueryString["num"], out num))
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败, Message = Message.BADPARAMETERS }));
                            return;
                        }
                    }
                    var hostlinename = (from instance in data
                                        select (instance.StartPlace + "-" + instance.EndPlace)).Distinct().ToList();
                    var hotlineid = (from instance in data
                                     select instance.HotLineId).Distinct().ToList();
                    var result = new List<object>();
                    

                    int index = 0;
                    foreach (var lineName in hostlinename)
                    {
                        var name = lineName;
                        var imgurl =
                            (from instance in data where (instance.StartPlace + "-" + instance.EndPlace) == name select instance.Imgurl).Distinct().ToList().FirstOrDefault();
                        var obj = new
                        {
                            linename = lineName,
                            hotlineid = hotlineid.ToList()[index],
                            ImgUrl = imgurl,
                            cartype = (from d in data
                                       where (d.StartPlace + "-" + d.EndPlace) == name
                                       select new { typename = d.CarTypeName }).Distinct(),
                            SingleWay = from d in data
                                        where d.IsOneWay == 1 & (d.StartPlace + "-" + d.EndPlace) == name
                                        select new { TripName = "单程", Price = d.StartPrice },
                            RoundWay = from d in data
                                       where d.IsOneWay == 0 & (d.StartPlace + "-" + d.EndPlace) == name
                                       select new { TripName = "往返", Price = d.StartPrice }
                        };
                        result.Add(obj);
                        index++;
                    }
                    List<object> objresult = new List<object>();
                    if (num > 0)
                    {
                        objresult = result.Take(4).ToList();
                    }
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = objresult.Count > 0 ? objresult : result,
                        Message = Message.SUCCESS,
                        StatusCode = StatusCode.请求成功
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败, Message = Message.BADPARAMETERS }));
                }
            }
            else
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse { StatusCode = StatusCode.请求失败, Message = Message.BADPARAMETERS }));
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