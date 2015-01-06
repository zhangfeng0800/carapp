using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using Common;
using IEZU.Log;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// updateExtenTime 的摘要说明
    /// </summary>
    public class updateExtenTime : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var url = WebConfigurationManager.AppSettings["callcenteraddr"];
            if (!string.IsNullOrEmpty(context.Request["exten"]))
            {
                Global.ExtenLogin(context.Request["exten"]);
                var dict = new Dictionary<string, string>();
                dict.Add("groupid","0");
                dict.Add("exten",context.Request["exten"]);
                try
                {
                    var response = ServiceHelper.GetServiceResponse("http://"+url+"/GetStatus", dict);
                    if (response.Contains("checkedout"))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new {resultcode = ResultCode.成功, text = "签出"}));
                    }
                    else if (response.Contains("checkedin"))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new {resultcode = ResultCode.成功, text = "签入"}));
                    }
                    else
                    {
                        context.Response.Write(
                            JsonConvert.SerializeObject(new {resultcode = ResultCode.成功, text = "状态未知"}));
                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败, text = "服务器错误" }));
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