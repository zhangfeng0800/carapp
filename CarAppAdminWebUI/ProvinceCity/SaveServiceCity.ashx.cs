using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// SaveServiceCity 的摘要说明
    /// </summary>
    public class SaveServiceCity : IHttpHandler
    {
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        private const string CarusewayHotline = "6";
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var action = context.Request["action"];
            var carUseWay = context.Request["carUseWay"];
            var cityId = context.Request["cityId"];
            var hotlines = context.Request["hotline"];
            
            if (action == "add")
            {
                Add(context, carUseWay, cityId, hotlines);
            }
            else if (action == "edit")
            {
                Edit(context, carUseWay, cityId, hotlines);
            }
            else if (action == "delete")
            {
                Delete(context, cityId);
            }
        }

        private void Add(HttpContext context, string carUseWay, string cityId, string hotlines)
        {
            string hotlineindexs = context.Request["hotlineindexs"];
            string ishotcity = context.Request["ishotcity"];
            string provenceID = context.Request["provenceID"];
            string cityId1 = context.Request["cityId1"];
            if (string.IsNullOrEmpty(cityId))
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = false, Message = "请选择需要开通服务的城市" }));
                return;
            }

            int allCount = 0;
            int successCount = 0;

            if (!string.IsNullOrEmpty(carUseWay))
            {
                string[] carUseWayArray = carUseWay.Split(new string[] {","}, StringSplitOptions.RemoveEmptyEntries);
                foreach (var s in carUseWayArray)
                {
                    allCount++;
                    if (!_serviceCityBll.IsExistCarUseWay(cityId, s)) // todo:  循环访问数据库
                    {
                        successCount++;
                        var model = new Model.ServiceCity()
                        {
                            cityID = cityId1,
                            carusewayID = Convert.ToInt32(s),
                            HotlineId = "",
                            ishotcity = Convert.ToInt32(ishotcity),
                            needTime = 0,
                            imgUrl = "",
                            IsDelete = 0,
                            ProvenceId = Convert.ToInt32(provenceID),
                            CountyId = Convert.ToInt32(cityId)
                        };
                        _serviceCityBll.InsertServiceCity(model); //todo:  循环访问数据库
                    }
                }
            }

            if (!string.IsNullOrEmpty(hotlineindexs))
            {
                string[] hotLineArray = hotlineindexs.Split(new string[] {","}, StringSplitOptions.RemoveEmptyEntries);
                foreach (var s in hotLineArray)
                {
                    string hotlineid = context.Request["hotLine" + s];
                    if (string.IsNullOrEmpty(hotlineid))
                    {
                        continue;
                    }

                    allCount++;
                    if (!_serviceCityBll.IsExistHotLine(cityId, hotlineid, CarusewayHotline)) // todo:  循环访问数据库
                    {
                        successCount++;
                        var model = new Model.ServiceCity()
                        {
                            cityID = cityId1,
                            carusewayID = Convert.ToInt32(CarusewayHotline),
                            HotlineId = hotlineid,
                            ishotcity = Convert.ToInt32(ishotcity),
                            needTime = 0,
                            imgUrl = "",
                            IsDelete = 0,
                            ProvenceId = Convert.ToInt32(provenceID),
                            CountyId = Convert.ToInt32(cityId)
                        };
                        _serviceCityBll.InsertServiceCity(model);// todo:  循环访问数据库
                    }
                }
            }

            context.Response.Write(
                JsonConvert.SerializeObject(new AjaxResultMessage()
                {
                    IsSuccess = true,
                    Message = string.Format("共申请开通服务 {0} 条，其中原来已经开通 {1} 条，本次成功开通 {2} 条",
                        allCount, allCount - successCount, successCount)
                }));
        }

        private void Edit(HttpContext context, string carUseWay, string cityId, string hotlines)
        {
            string cityId1 = context.Request["cityId1"];
            string provenceID = context.Request["provenceID"];
            string ishotcity = context.Request["ishotcity"];
            _serviceCityBll.DeleteServiceCity(cityId);
            if (!string.IsNullOrEmpty(carUseWay))
            {
                string[] carUseWayArray = carUseWay.Split(new string[] {","}, StringSplitOptions.RemoveEmptyEntries);
                foreach (string s in carUseWayArray)
                {
                    var model = new Model.ServiceCity() // todo:  循环访问数据库
                    {
                        cityID = cityId1,
                        carusewayID = Convert.ToInt32(s),
                        HotlineId = "",
                        ishotcity = Convert.ToInt32(ishotcity),
                        needTime = 0,
                        imgUrl = "",
                        IsDelete = 0,
                        ProvenceId = Convert.ToInt32(provenceID),
                        CountyId = Convert.ToInt32(cityId)
                    };
                    _serviceCityBll.InsertServiceCity(model); // todo:  循环访问数据库
                }
            }
            if (!string.IsNullOrEmpty(hotlines))
            {
                string[] hotLineArray = hotlines.Split(new string[] {","}, StringSplitOptions.RemoveEmptyEntries);
                foreach (string s in hotLineArray)
                {
                    var model = new Model.ServiceCity() // todo:  循环访问数据库
                    {
                        cityID = cityId1,
                        carusewayID = Convert.ToInt32(CarusewayHotline),
                        HotlineId = s,
                        ishotcity = Convert.ToInt32(ishotcity),
                        needTime = 0,
                        imgUrl = "",
                        IsDelete = 0,
                        ProvenceId = Convert.ToInt32(provenceID),
                        CountyId = Convert.ToInt32(cityId)
                    };
                    _serviceCityBll.InsertServiceCity(model); // todo:  循环访问数据库
                }
            }
            context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = true, Message = "" }));
        }

        private void Delete(HttpContext context, string cityId)
        {
            _serviceCityBll.VirtualDelete("countyId=" + cityId);
            context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = true, Message = "" }));
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