using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarTypeHandler 的摘要说明
    /// </summary>
    public class CarTypeHandler : IHttpHandler
    {
        private readonly CarTypeBLL _carTypeBll = new CarTypeBLL();
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
                case "delete":
                    Delete(context);
                    break;
            }
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string idStr = context.Request["id"];
            int id;

            if (!int.TryParse(idStr, out id))
            {
                message.IsSuccess = false;
                message.Message = "参数错误";
            }
            else
            {
                try
                {
                    _rentCarBll.VirtualDelete("carTypeID=" + id);
                    LogHelper.WriteOperation("删除了车辆舒适类型编号为[" + id + "]的车", OperationType.Delete, "删除成功",
                        HttpContext.Current.User.Identity.Name);
                    _carTypeBll.DeleteData(id);
                    LogHelper.WriteOperation("删除了车辆舒适类型编号为[" + id + "]的记录", OperationType.Delete, "删除成功",
                        HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                catch (Exception exception)
                {
                    message.IsSuccess = false;
                    LogHelper.WriteException(exception);
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string typeName = context.Request["typeName"];
            int passengerNum = Convert.ToInt32(context.Request["passengerNum"]);
            string description = context.Request["description"];
            string imgUrl = context.Request["imgUrl"];
            if (_carTypeBll.IsExist(typeName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此类型";
                LogHelper.WriteOperation("已经存在车辆类型为[" + typeName + "]的记录", OperationType.Add, "添加失败", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = new Model.CarType
                {
                    typeName = Common.Tool.FormatString(typeName),
                    description =Common.Tool.FormatString(description),
                    information = Common.Tool.FormatString(description),
                    imgUrl = imgUrl,
                    passengerNum = passengerNum
                };
                try
                {
                    _carTypeBll.AddData(model);
                    message.IsSuccess = true;
                    message.Message = "";
                    LogHelper.WriteOperation("添加车辆类型为[" + typeName + "]的记录", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            string typeName = context.Request["typeName"];
            int passengerNum = Convert.ToInt32(context.Request["passengerNum"]);
            string description = context.Request["description"];
            string imgUrl = context.Request["imgUrl"];
            if (_carTypeBll.IsExist(id, typeName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此类型";
                LogHelper.WriteOperation("已经存在车辆类型为[" + typeName + "]的记录", OperationType.Update, "更新失败", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = new Model.CarType
                {
                    id = id,
                    typeName = Common.Tool.FormatString(typeName),
                    description = Common.Tool.FormatString(description),
                    information = Common.Tool.FormatString(description),
                    imgUrl = imgUrl,
                    passengerNum = passengerNum
                };
                try
                {
                    _carTypeBll.UpdateDate(model);
                    LogHelper.WriteOperation("更新车辆类型编号为[" + id + "]车辆类型名称为[" + typeName + "]", OperationType.Update,"更新成功", HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                }
               
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string where = "typeName like '%" + Common.Tool.SqlFilter(keyword) + "%'";

            var list = _carTypeBll.GetPageList(pageIndex, pageSize, where, out count);
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