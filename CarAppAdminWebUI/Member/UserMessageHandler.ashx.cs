using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// UserMessageHandler 的摘要说明
    /// </summary>
    public class UserMessageHandler : IHttpHandler
    {
        private readonly userMessageBLL _userMessageBll = new userMessageBLL();
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
                case "addmess":
                    AddMessage(context); //回复留言
                    break;
                case "Replystate":
                    Reply(context);
                    break;
            }
        }
        private void Reply(HttpContext context)
        {
            BLL.userMessageBLL _userMessageBll = new BLL.userMessageBLL();
            int id = Convert.ToInt32(context.Request["id"]);
            List<Model.userMessage> listM = new List<Model.userMessage>();
            var list = _userMessageBll.GetList_HeadQuestion(id, listM);
            context.Response.Write(list[list.Count - 1].type);
        }

        private void AddMessage(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["messID"]);
            string content = context.Request["content"];
            context.Response.Write(JsonConvert.SerializeObject(_userMessageBll.Answer(content, id)));
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
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            int userId = string.IsNullOrEmpty(context.Request["userId"])?0:Convert.ToInt32(context.Request["userId"]);
            string where = "content like '%" + keyword + "%' and isHead=1 ";
            if (userId != 0)
                where += " and userid=" + userId;

            var list = _userMessageBll.GetList(pageIndex, pageSize, where, out count);
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