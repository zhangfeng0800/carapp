using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Common;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.SysConfig
{
    /// <summary>
    /// ConfigHandler 的摘要说明
    /// </summary>
    public class ConfigHandler : IHttpHandler
    {
        private readonly SystemConfigBLL _systemConfigBll = new SystemConfigBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "ConfigRCoupon":
                    ConfigRCoupon(context);
                    break;
            }  
        }

        private void ConfigRCoupon(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string key1 = context.Request["key1"];
            string value1 = context.Request["value1"];
            string key2 = context.Request["key2"];
            string value2 = context.Request["value2"];
            string key3 = context.Request["key3"];
            string value3 = context.Request["value3"];
            Common.SystemConfig config1;
            Common.SystemConfig config2;
            Common.SystemConfig config3;
            if (!Enum.TryParse(key1, out config1))
            {
                message.IsSuccess = false;
                message.Message = "你要修改金额值无效";
            }
            else if (!Enum.TryParse(key2, out config2))
            {
                message.IsSuccess = false;
                message.Message = "你要修改使用限制无效";
            }
            else if (!Enum.TryParse(key3, out config3))
            {
                message.IsSuccess = false;
                message.Message = "你要修改使用名称无效";
            }
            else
            {
                _systemConfigBll.Set(config1, value1);
                _systemConfigBll.Set(config2, value2);
                _systemConfigBll.Set(config3, value3);
                message.IsSuccess = true;
                message.Message = "";
            }

            context.Response.Write(JsonConvert.SerializeObject(message));
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