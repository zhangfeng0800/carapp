using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// 会员级别管理的一般处理程序
    /// </summary>
    public class LevelHandler : IHttpHandler
    {
        private readonly LevelBLL _levelBll = new LevelBLL();
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
            }
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string name = context.Request["name"];
                var usertype = 0;
                var scoreLL = 0;
                var scoreUL = 0;
                var discount = 0;
                var order = 0;
                if (!int.TryParse(context.Request["usertype"], out usertype))
                {
                    message.IsSuccess = false;
                    message.Message = "类型错误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["scoreLL"], out scoreLL))
                {
                    message.IsSuccess = false;
                    message.Message = "积分下限有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["scoreUL"], out scoreUL))
                {
                    message.IsSuccess = false;
                    message.Message = "积分上限有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["discount"], out discount))
                {
                    message.IsSuccess = false;
                    message.Message = "折扣只能是整数";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["order"], out order))
                {
                    message.IsSuccess = false;
                    message.Message = "排序输入有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                var model = new Model.Level()
                {
                    Name = name,
                    UserType = usertype,
                    ScoreLL = scoreLL,
                    ScoreUL = scoreUL,
                    Discount = discount,
                    Order = order
                };
                if (_levelBll.IsExist(model.Name, model.UserType))
                {
                    message.IsSuccess = false;
                    message.Message = "已经存在此级别名称";
                }
                else
                {
                    _levelBll.Add(model);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.IsSuccess = false;
                message.Message = "操作失败";
                context.Response.Write(JsonConvert.SerializeObject(message));
            }

        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int id = Convert.ToInt32(context.Request["id"]);
                string name = context.Request["name"];
                var usertype = 0;
                var scoreLL = 0;
                var scoreUL = 0;
                var discount = 0;
                var order = 0;
                if (!int.TryParse(context.Request["usertype"], out usertype))
                {
                    message.IsSuccess = false;
                    message.Message = "类型错误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["scoreLL"], out scoreLL))
                {
                    message.IsSuccess = false;
                    message.Message = "积分下限有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["scoreUL"], out scoreUL))
                {
                    message.IsSuccess = false;
                    message.Message = "积分上限有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["discount"], out discount))
                {
                    message.IsSuccess = false;
                    message.Message = "折扣只能是整数";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                if (!int.TryParse(context.Request["order"], out order))
                {
                    message.IsSuccess = false;
                    message.Message = "排序输入有误";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }
                var model = new Model.Level()
                {
                    Id = id,
                    Name = name,
                    UserType = usertype,
                    ScoreLL = scoreLL,
                    ScoreUL = scoreUL,
                    Discount = discount,
                    Order = order
                };
                if (_levelBll.IsExist(id, model.Name, model.UserType))
                {
                    message.IsSuccess = false;
                    message.Message = "已经存在此级别名称";
                }
                else
                {
                    _levelBll.Update(model);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                message.IsSuccess = false;
                message.Message = "操作失败";
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string where = "name like '%" + keyword + "%'";

            var list = _levelBll.GetPageList(pageIndex, pageSize, where, out count);
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