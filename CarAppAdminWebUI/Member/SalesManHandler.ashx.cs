using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// SalesManHandler 的摘要说明
    /// </summary>
    public class SalesManHandler : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "list":
                    List(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
                case "reset":
                    Reset(context);
                    break;
            }
        }

        private void Reset(HttpContext context)
        {
            string id = context.Request["Id"];
            var message = new AjaxResultMessage();
            try
            {
                var model = new BLL.SalesManBll().GetModel(Int32.Parse(id));
                if(model.State == "正常")
                {
                    message.IsSuccess = false;
                    message.Message = "该用户状态为正常，无需恢复";
                }
                else
                {
                    model.State = "正常";
                    new BLL.SalesManBll().Update(model);
                    message.IsSuccess = true;
                }
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Delete(HttpContext context)
        {
            var _SaleBll = new BLL.SalesManBll();
            var message = new AjaxResultMessage();
            try
            {
                int id = Int32.Parse(context.Request["ids"]);
                //int result = new BLL.SalesManBll().Delete(id);
                var model = _SaleBll.GetModel(id);
                model.State = "已删除";
                _SaleBll.Update(model);
                message.IsSuccess = true;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
           
        }

        private void Edit(HttpContext context)
        {
            string name = context.Request["name"];
            string sort = context.Request["sort"];
            string id = context.Request["Id"];
            var message = new AjaxResultMessage();
            try
            {
                var model = new BLL.SalesManBll().GetModel(Int32.Parse(id));
                model.Name = name;
                model.Sort = Int32.Parse(sort);
               
                int row = new BLL.SalesManBll().Update(model);
             
                message.IsSuccess = row != 0 ? true : false;
                message.Message = "未知";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message; 
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
           
        }

        private void Add(HttpContext context)
        {
            string name = context.Request["name"];
            string sort = context.Request["Sort"];
            var message = new AjaxResultMessage();
            try
            {
                var model = new Model.SalesMan()
                {
                    CreateMan = context.User.Identity.Name,
                    Name = name,
                    Sort = Int32.Parse(sort)
                };
                int id = new BLL.SalesManBll().Add(model);
               
                message.IsSuccess = id != 0 ? true : false;
                message.Message = "未知";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
           
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string username = context.Request["username"].ToString();
            string state = context.Request["state"].ToString();
            string where = " 1=1 ";
            if (!string.IsNullOrEmpty(state))
            {
                where += " and State = '" + state + "'";
            }
            if(!string.IsNullOrEmpty(username))
            {
                where += " and Name like '%" + username + "%'";
            }
            var list = new BLL.SalesManBll().GetPageList(where, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }).ToLower());
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