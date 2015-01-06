using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// Delete 的摘要说明
    /// </summary>
    public class Delete : IHttpHandler
    {
        private readonly ProvinceBLL _provinceBll = new ProvinceBLL();
        public void ProcessRequest(HttpContext context)
        {
            string t = context.Request["t"];
            string f = context.Request["f"];
            string v = context.Request["v"];
            context.Response.ContentType = "text/plain";
            try
            {
                _provinceBll.Delete(t, f, v);
                LogHelper.WriteOperation("删除了表[" + t + "],编号[" + f + "=" + v + "]", OperationType.Delete, "删除成功", HttpContext.Current.User.Identity.Name);
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = true, Message = "" }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new AjaxResultMessage() { IsSuccess = false, Message = "" }));
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