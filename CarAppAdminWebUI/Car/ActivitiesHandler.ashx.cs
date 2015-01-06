using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Web;
using BLL;
using Common;
using Common.BaiduPush;
using Common.BaiduPush.Enums;
using IEZU.Log;
using Model;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// ActivitiesHandler 的摘要说明
    /// </summary>
    public class ActivitiesHandler : IHttpHandler
    {
        private readonly ActivitiesBLL _activitiesBll = new ActivitiesBLL();
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "rentcarlist":
                    RentCarList(context);
                    break;
                case "waylist":
                    GetCarUseWayList(context);
                    break;
                case "carlist":
                    GetCarList(context);
                    break;
                case "hotlist":
                    GetHotLineList(context);
                    break;
                case "typelist":
                    GetCarType(context);
                    break;

            }
        }

        public void GetCarType(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var cityid = context.Request["cityid"];
            var hotlineid = context.Request["hotlineid"];
            var data = (new HotLineBLL()).GetCarType(cityid, int.Parse(hotlineid));
            context.Response.Write(data.Rows.Count > 0
             ? JsonConvert.SerializeObject(new { CodeId = 1, Data = data })
             : JsonConvert.SerializeObject(new { CodeId = 0 }));
        }
        public void GetHotLineList(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var cityid = context.Request["cityid"];
            var data = (new HotLineBLL()).GetHotLineByCity(cityid);
            context.Response.Write(data.Rows.Count > 0
                ? JsonConvert.SerializeObject(new { CodeId = 1, Data = data })
                : JsonConvert.SerializeObject(new { CodeId = 0 }));
        }
        public void GetCarList(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var cityid = context.Request["cityid"];
            var useid = context.Request["usewayid"];
            var data = (new RentCarBLL()).GetCarsInfo(cityid, int.Parse(useid));
            context.Response.Write(data.Rows.Count > 0
             ? JsonConvert.SerializeObject(new { CodeId = 1, Data = data })
             : JsonConvert.SerializeObject(new { CodeId = 0 }));
        }
        private void RentCarList(HttpContext context)
        {
            string v = context.Request["v"];
            var list = _rentCarBll.GetList(v);
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        public void GetCarUseWayList(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var cityid = context.Request["cityid"];
            var list = (new BLL.ServiceCityBLL()).GetCarUse(cityid);
            context.Response.Write(list.Count > 0
                ? JsonConvert.SerializeObject(new { CodeId = 1, Data = list })
                : JsonConvert.SerializeObject(new { CodeId = 0 }));
        }
        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string rendCarStr = context.Request["rentCar"];
            string isArticle = context.Request["isArticle"];
            if (isArticle == "0")
            {
                if (context.Request["addrentcar"] == "0" || context.Request["addrentcar"] == "")
                {
                    message.IsSuccess = false;
                    message.Message = "请填写相关车辆信息";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                else if (context.Request["addrentcar"] == "6")
                {
                    if (context.Request["selectline"] == "0" || context.Request["addrelatedcar"] == "0" || context.Request["selectline"] == "" || context.Request["addrelatedcar"] == "")
                    {
                        message.IsSuccess = false;
                        message.Message = "请填写相关车辆信息";
                        context.Response.Write(JsonConvert.SerializeObject(message));
                        return;
                    }


                }
                else
                {
                    if (context.Request["addrelatedcar"] == "0" || context.Request["addrelatedcar"] == "")
                    {
                        message.IsSuccess = false;
                        message.Message = "请填写相关车辆信息";
                        context.Response.Write(JsonConvert.SerializeObject(message));
                        return;
                    }
                }
            }

            try
            {
                var model = new Activities();
                PostHelper.GetModel(ref model, context.Request.Form);
                model.IsArticle = Convert.ToInt32(isArticle);
                if (model.IsArticle == 0)
                {
                    model.RentCarId = Convert.ToInt32(context.Request["addrelatedcar"]);
                    model.carusewayId = Convert.ToInt32(context.Request["addrentcar"]);
                }
                else
                {
                    model.RentCarId = 0;
                    model.Content = Common.regexPath.DoChange(context.Request["content"].ToString(), "http://admin.iezu.cn").Replace('\'','"');
                    model.ContentUrl = context.Request["contentUrl"].ToString();
                    if (model.ContentUrl == "")
                        model.ContentUrl = "http://m.iezu.cn/ClientCenterDetail.aspx?activeId=";
                }
                model.IsFocus = context.Request["isFocus"] == null ? 0 : 1;
                model.IsTop = context.Request["isTop"] == null ? 0 : 1;
                model.IsHide = context.Request["isHide"] == null ? 0 : 1;

                model.starttime = DateTime.Now;
                model.endtime = DateTime.Now;
                model.imgurl = context.Request["imgurl"] == null ? "" : context.Request["imgurl"].ToString();
                message.IsSuccess = true;
                message.Message = "";
                _activitiesBll.Add(model);
                LogHelper.WriteOperation("添加了活动，活动信息为:租车编号[" + model.RentCarId.ToString() + "],用车方式编号[" + model.carusewayId.ToString() + "]，开始时间[" + model.starttime.ToString() + "]，结束时间[" + model.endtime.ToString() + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                //PushManager.PushNotificationToCustomer(DeviceType.Andriod, PushType.All, model.Content,
                //    JsonConvert.SerializeObject(new { contentType = 5, data = model }), "", "", "");
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.IsSuccess = false;
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string idStr = context.Request["id"];
            string isArticle = context.Request["isArticle"];
            if (isArticle == "0")
            {
                if (context.Request["rentCar"] == "0" || context.Request["rentCar"] == "")
                {
                    message.IsSuccess = false;
                    message.Message = "请填写相关车辆信息";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                else if (context.Request["rentCar"] == "6")
                {
                    if (context.Request["editlinename"] == "0" || context.Request["relatedcars"] == "0" || context.Request["editlinename"] == "" || context.Request["relatedcars"] == "")
                    {
                        message.IsSuccess = false;
                        message.Message = "请填写相关车辆信息";
                        context.Response.Write(JsonConvert.SerializeObject(message));
                        return;
                    }
                }
                else
                {
                    if (context.Request["relatedcars"] == "0")
                    {
                        message.IsSuccess = false;
                        message.Message = "请填写相关车辆信息";
                        context.Response.Write(JsonConvert.SerializeObject(message));
                        return;
                    }
                }
            }
            try
            {
                var model = _activitiesBll.GetModel(Convert.ToInt32(idStr));
                PostHelper.GetModel(ref model, context.Request.Form);
                model.IsArticle = Convert.ToInt32(isArticle);
                if (model.IsArticle == 0)
                {
                    model.RentCarId = Convert.ToInt32(context.Request["relatedcars"]);
                    model.carusewayId = Convert.ToInt32(context.Request["rentCar"]);
                }
                else
                {
                    model.RentCarId = 0;
                    model.Content = Common.regexPath.DoChange(context.Request["content"].ToString(), "http://admin.iezu.cn");
                    model.ContentUrl = context.Request["contentUrl"].ToString();
                    if (model.ContentUrl == "")
                        model.ContentUrl = "http://m.iezu.cn/ClientCenterDetail.aspx?activeId=";
                }
                model.IsFocus = context.Request["isFocus"] == null ? 0 : 1;
                model.IsTop = context.Request["isTop"] == null ? 0 : 1;
                model.IsHide = context.Request["isHide"] == null ? 0 : 1;

                model.imgurl = context.Request["imgurl"] == null ? "" : context.Request["imgurl"].ToString();
                _activitiesBll.Update(model);
                message.IsSuccess = true;
                message.Message = "";
                LogHelper.WriteOperation("更新活动，编号[" + idStr + "]", OperationType.Update, "更新成功", HttpContext.Current.User.Identity.Name);
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                LogHelper.WriteException(exception);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string provinceId = context.Request["provinceId"];
            string cityId = context.Request["cityId"];
            string countyId = context.Request["countyId"];
            string isFocus = context.Request["isFocus"];
            string isHide = context.Request["isHide"];
            string where = "1=1";
            if (!string.IsNullOrEmpty(provinceId))
            {
                where += " and provinceId='" + provinceId + "'";
            }
            if (!string.IsNullOrEmpty(cityId))
            {
                where += " and cityId='" + cityId + "'";
            }
            if (!string.IsNullOrEmpty(countyId))
            {
                where += " and countyId='" + countyId + "'";
            }
            if (isFocus == "1")
            {
                where += " and isFocus=1";
            }
            if (isHide == "1")
            {
                where += " and isHide=1 ";
            }
            if (!string.IsNullOrEmpty(context.Request["activitytype"]))
            {
                where += " and isarticle=" + context.Request["activitytype"];
            }
            var list = _activitiesBll.GetList(pageIndex, pageSize, where, out count);
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