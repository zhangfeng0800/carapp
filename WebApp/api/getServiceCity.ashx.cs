using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model;
using BLL;
using DAL;
using System.Web.Script.Serialization;
namespace WebApp.api
{
    /// <summary>
    /// getServiceCity 的摘要说明
    /// </summary>
    public class getServiceCity : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            ServiceCityBLL objBll = new ServiceCityBLL();
            //查询提供服务的全部省份
            if (context.Request.Params["type"] != null)
            {
                List<ServiceCityExt> list = objBll.GetProvinceList();
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string province = jss.Serialize(list);
                context.Response.Write(province);
                return;
            }
            if (context.Request.Params["select"] == "selectCarUseWay")
            {
                string cityID=context.Request.Params["cityID"].ToString();
                List<ServiceCityExt> list = objBll.GetCarUse(cityID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string caruseway = jss.Serialize(list);
                context.Response.Write(caruseway);
                return;
            }
            //根据省份查询提供租车服务的城市
            if (context.Request.Params["getservicecity"] != null)
            {
                string provinceID = context.Request.Params["provinceID"].ToString();
                List<ServiceCityExt> list = objBll.GetCityByProvince(provinceID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string cityList = jss.Serialize(list);
                context.Response.Write(cityList);
                return;
            }
            //查询热门线路(根据出发城市查询目的城市）
            if (context.Request.Params["getTargetCity"] != null)
            {
                List<ServiceCityExt> list = new ServiceCityBLL().GetTargetCity(context.Request.Params["departureCityID"].ToString());
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string cityList = jss.Serialize(list);
                context.Response.Write(cityList);
                return;
            }
            //（热门线路）根据出发城市和目的城市查询查询线路是单程还是往返
            if (context.Request.Params["startCityID"] != null && context.Request.Params["arriveCityID"] != null)
            {
               List<int> hotType = new ServiceCityBLL().GetHotType(context.Request.Params["startCityID"].ToString(), context.Request.Params["arriveCityID"].ToString());
               JavaScriptSerializer jss = new JavaScriptSerializer();
               string typeList = jss.Serialize(hotType);
               context.Response.Write(typeList);
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