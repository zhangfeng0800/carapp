using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using BLL;
using Common;
using Newtonsoft.Json;

namespace WebApp.api.selectcarapi
{
    /// <summary>
    /// SelectCarRight 的摘要说明
    /// </summary>
    public class SelectCarRight : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request.QueryString["cityId"] != null && context.Request.QueryString["useType"] != null)
            {
                var provinceCity = (new BLL.province_cityBLL()).GetCityNameByCityId((context.Request.QueryString["cityId"]));
                {
                    var cityname = provinceCity;
                    var model =
                        (new BLL.CarUseWayBLL()).GetCarUseWayModel(Convert.ToInt32(context.Request.QueryString["useType"]));
                    var usetype = model.Name;
                    var imgUrl = model.ImgUrl;
                    var targetPlace = "";
                    var linetype = "";
                    if (context.Request.QueryString["lineType"] != null && context.Request.QueryString["hotlineId"] != null)
                    {
                        linetype = context.Request.QueryString["lineType"] == "0" ? "往返" : "单程";
                        var firstOrDefault = (new HotLineBLL()).GetHotById(Convert.ToInt32(context.Request.QueryString["hotlineId"])).FirstOrDefault();
                        if (firstOrDefault != null)
                            targetPlace = firstOrDefault.name;
                    }
                    context.Response.Write(JsonConvert.SerializeObject(new AjaxResponse
                    {
                        Data = new
                        {
                            cityname = cityname,
                            usetype = usetype,
                            linetype = linetype,
                            imgurl = imgUrl,
                            targetPlace = targetPlace
                        },
                        Message = Message.SUCCESS,
                        StatusCode = StatusCode.请求成功
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