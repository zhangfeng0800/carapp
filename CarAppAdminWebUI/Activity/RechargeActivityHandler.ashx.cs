using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Common;
using Model;
using Model.Ext;
using Newtonsoft.Json;
using GiveMoney = BLL.GiveMoney;

namespace CarAppAdminWebUI.Activity
{
    /// <summary>
    /// RechargeActivityHandler 的摘要说明
    /// </summary>
    public class RechargeActivityHandler : IHttpHandler
    {
        private readonly GiveMoney _giveMoney=new GiveMoney();
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
            var model = new Model.GiveMoney();
            PostHelper.GetModel<Model.GiveMoney>(ref model, context.Request.Form);
            if (model.startDate < DateTime.Now.AddDays(-1))
            {
                message.IsSuccess = false;
                message.Message = "活动开始时间无效";
            }
            else if (model.startDate > model.deadline)
            {
                message.IsSuccess = false;
                message.Message = "开始时间不能大于结束时间";
            }
           
            else
            {
                if(model.deadline != null)
                    model.deadline = ((DateTime) model.deadline).AddDays(1).AddSeconds(-1);//以最后一天的最后一秒为活动到期日期 
                _giveMoney.Add(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            var model = _giveMoney.GetModel(id);
            PostHelper.GetModel<Model.GiveMoney>(ref model, context.Request.Form);
            if (model.startDate < DateTime.Now.AddDays(-1))
            {
                message.IsSuccess = false;
                message.Message = "活动开始时间无效";
            }
            else if (model.startDate > model.deadline)
            {
                message.IsSuccess = false;
                message.Message = "开始时间不能大于结束时间";
            }
         
            else
            {
                _giveMoney.Update(model);
                message.IsSuccess = true;
                message.Message = "";
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string keyword = context.Request["Keyword"];
            string where = "name like '%" + Common.Tool.SqlFilter(keyword) + "%'";

            var list = _giveMoney.GetPageList(pageIndex, pageSize, where, out count);
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