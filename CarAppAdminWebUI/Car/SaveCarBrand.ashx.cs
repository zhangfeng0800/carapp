using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// SaveCarBrand 的摘要说明
    /// </summary>
    public class SaveCarBrand : IHttpHandler
    {
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        public void ProcessRequest(HttpContext context)
        {
            var message = new AjaxResultMessage();
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            if (action == "add")
            {
                Add(context, ref message);
            }
            else
            {
                Edit(context, ref message);
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context, ref AjaxResultMessage message)
        {
            string brandName = context.Request["brandName"];
            string imgUrl = context.Request["imgUrl"];
            string description = context.Request["description"] ?? "";
            string simgurl = context.Request["simgurl"];
            string content = context.Request["content"] ?? "";
            string sort = context.Request["sort"];
            if (sort == "")
                sort = "0";
            if (_carBrandBll.IsExist(brandName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此车辆品牌";
                LogHelper.WriteOperation("添加品牌为[" + brandName + "]", OperationType.Query, "此品牌的车辆已经存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = new Model.carBrand();
                model.brandName =Common.Tool.FormatString(brandName);
                model.ImgUrl = imgUrl;
                model.Description = description;
                model.SImgUrl = simgurl;
                model.MoreDescript =content;
                try
                {
                    model.Sort = Int32.Parse(sort);
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                    message.Message = "排序数据有误，请检查";
                    return;
                }
                try
                {
                    _carBrandBll.AddCarBrand(model);
                    message.IsSuccess = true;
                    message.Message = "";
                    LogHelper.WriteOperation("添加品牌为[" + brandName + "]", OperationType.Query, "添加成功", HttpContext.Current.User.Identity.Name);
                }
                catch (Exception exception)
                {
                    message.IsSuccess = false;
                    message.Message = "添加失败";
                    LogHelper.WriteException(exception);
                }

            }
        }

        private void Edit(HttpContext context, ref AjaxResultMessage message)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            string brandName = context.Request["brandName"];
            string imgUrl = context.Request["imgUrl"];
            string description = context.Request["description"] ?? "";
            string simgurl = context.Request["simgurl"];
            string content = context.Request["content"] ?? "";
            string sort = context.Request["sort"] ?? "0";
            if (sort == "")
                sort = "0";

            if (_carBrandBll.IsExist(id, brandName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此车辆品牌";
                LogHelper.WriteOperation("编辑编号[" + id + "]的汽车品牌", OperationType.Query, "此品牌的车辆已经存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = new Model.carBrand();
                model.id = id;
                model.brandName = Common.Tool.FormatString(brandName);
                model.ImgUrl = imgUrl;
                model.Description = description;
                model.SImgUrl = simgurl;
                model.MoreDescript = content;
                try
                {
                    model.Sort = Int32.Parse(sort);
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                    message.Message = "排序数据有误，请检查";
                    return;
                }
                try
                {
                    _carBrandBll.UpdateCarBrand(model);
                    message.IsSuccess = true;
                    message.Message = "";
                    LogHelper.WriteOperation("编辑编号[" + id + "]的汽车品牌", OperationType.Update, "编辑成功", HttpContext.Current.User.Identity.Name);
                }
                catch (Exception exception)
                {
                    message.IsSuccess = false;
                    LogHelper.WriteException(exception);
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