using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.ProvinceCity
{
    /// <summary>
    /// ServiceCityHandler 的摘要说明
    /// </summary>
    public class ServiceCityHandler : IHttpHandler
    {
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    ItemAdd(context);
                    break;
                case "hotlineadd":
                    HotLineAdd(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
                case "onEditHotLine":
                    EditHotLine(context);
                    break;
                case "Recovery":
                    Recovery(context);
                    break;
            }
        }

        private  void Recovery(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["Id"]);
            var ServiceModel = new BLL.ServiceCityBLL().GetModel(id);
            ServiceModel.IsDelete = 0;
        }

        private void EditHotLine(HttpContext context)
        {
            string idStr = context.Request["id"];
            string imgUrl = context.Request["imgUrl"];
            int id;
            if (!int.TryParse(idStr, out id))
            {
                context.Response.Write(
                JsonConvert.SerializeObject(new AjaxResultMessage()
                {
                    IsSuccess = false,
                    Message = "参数错误"
                }));
                return;
            }

            _serviceCityBll.UpdateServiceCity(id, imgUrl);

            context.Response.Write(
                JsonConvert.SerializeObject(new AjaxResultMessage()
                {
                    IsSuccess = true,
                    Message = ""
                }));
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string idStr = context.Request["id"];
            int id;
            if (!int.TryParse(idStr, out id))
            {
                message.IsSuccess = false;
                message.Message = "参数无效";
            }
            else
            {
                var model = _serviceCityBll.GetModel(id);
                if (model == null)
                {
                    message.IsSuccess = false;
                    message.Message = "数据错误";
                }
                else if (model.IsDelete == 1)
                {
                    message.IsSuccess = false;
                    message.Message = "此数据已经是删除状态，不允许重复删除";
                }
                else
                {
                    string where = string.Empty;
                    where += "countyId='" + model.CountyId + "' and carusewayID=" + model.carusewayID;
                    if (!string.IsNullOrEmpty(model.HotlineId))
                    {
                        where += " and hotLineID=" + model.HotlineId;
                    }
                    _serviceCityBll.VirtualDelete(id);
                    _rentCarBll.VirtualDelete(where);
                    message.IsSuccess = true;
                    message.Message = "";
                }
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void HotLineAdd(HttpContext context)
        {
            string carUseWay = context.Request["carUseWay"];
            string ishotcity = context.Request["ishotcity"];
            string provenceID = context.Request["provenceID"];
            string cityId1 = context.Request["cityId1"];
            string cityId = context.Request["cityId"];
            string hotlineid = context.Request["hotlineid"];
            string imgUrl = context.Request["imgUrl"];
            if (string.IsNullOrEmpty(cityId))
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = false, Message = "请选择需要开通服务的城市" }));
                return;
            }

            int allCount = 0;
            int successCount = 0;

            if (!string.IsNullOrEmpty(hotlineid))
            {
                allCount++;
                if (!_serviceCityBll.IsExistHotLine(cityId, hotlineid, carUseWay))
                {
                    successCount++;
                    var model = new Model.ServiceCity()
                    {
                        cityID = cityId1,
                        carusewayID = Convert.ToInt32(carUseWay),
                        HotlineId = hotlineid,
                        ishotcity = Convert.ToInt32(ishotcity),
                        needTime = 0,
                        imgUrl = imgUrl,
                        IsDelete = 0,
                        ProvenceId = Convert.ToInt32(provenceID),
                        CountyId = Convert.ToInt32(cityId)
                    };
                    _serviceCityBll.InsertServiceCity(model);
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

        private void ItemAdd(HttpContext context)
        {
            string carUseWay = context.Request["carUseWay"];
            string ishotcity = context.Request["ishotcity"];
            string provenceID = context.Request["provenceID"];
            string cityId1 = context.Request["cityId1"];
            string cityId = context.Request["cityId"];
            if (string.IsNullOrEmpty(cityId))
            {
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = false, Message = "请选择需要开通服务的城市" }));
                return;
            }

            int allCount = 0;
            int successCount = 0;

            if (!string.IsNullOrEmpty(carUseWay))
            {
                string[] carUseWayArray = carUseWay.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var s in carUseWayArray)
                {
                    allCount++;
                    if (!_serviceCityBll.IsExistCarUseWay(cityId, s))// todo:  循环访问数据库
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

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string provenceID = context.Request["provenceID"];
            string cityId = context.Request["cityId"];
            string countyId = context.Request["areaId"];
 
            string caruseway = context.Request["caruseway"];

            string state = context.Request["state"];


            var list = _serviceCityBll.GetServiceCity(provenceID, cityId, countyId, caruseway,Int32.Parse(state), pageIndex, pageSize,
                                                      out count);
            //var list = _serviceCityBll.GetPageList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
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