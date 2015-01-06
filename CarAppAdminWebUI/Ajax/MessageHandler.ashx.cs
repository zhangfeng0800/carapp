using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// MessageHandler 的摘要说明
    /// </summary>
    public class MessageHandler : IHttpHandler
    {
        private readonly OrderBLL _orderBll=new OrderBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "ordersmessage":
                    OrdersMessage(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    List(context);
                    break;
            }
        }

        private void OrdersMessage(HttpContext context)
        {
            var message = new AjaxResultMessage();
            var list = _orderBll.GetOrdersByStatus(8);
            if (list.Count == 0)
            {
                message.IsSuccess = false;
                message.Message = "";
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            else
            {
                message.IsSuccess = true;
                message.Message = string.Format("你有 {0} 条订单需要派车", list.Count);
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Add(HttpContext context)
        {
            /*var message = new AjaxResultMessage();
            string typeName = context.Request["typeName"];
            int passengerNum = Convert.ToInt32(context.Request["passengerNum"]);
            string description = context.Request["description"];
            string imgUrl = context.Request["imgUrl"];
            if (_carTypeBll.IsExist(typeName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此类型";
            }
            else
            {
                var model = new Model.CarType
                {
                    typeName = typeName,
                    description = description,
                    information = description,
                    imgUrl = imgUrl,
                    passengerNum = passengerNum
                };
                _carTypeBll.AddData(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));*/
        }

        private void Edit(HttpContext context)
        {
            /*var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            string typeName = context.Request["typeName"];
            int passengerNum = Convert.ToInt32(context.Request["passengerNum"]);
            string description = context.Request["description"];
            string imgUrl = context.Request["imgUrl"];
            if (_carTypeBll.IsExist(id,typeName))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此类型";
            }
            else
            {
                var model = new Model.CarType
                {
                    id=id,
                    typeName = typeName,
                    description = description,
                    information = description,
                    imgUrl = imgUrl,
                    passengerNum = passengerNum
                };
                _carTypeBll.UpdateDate(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));*/
        }

        private void List(HttpContext context)
        {
            /*int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string where = "typeName like '%" + keyword + "%'";

            var list = _carTypeBll.GetPageList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));*/
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