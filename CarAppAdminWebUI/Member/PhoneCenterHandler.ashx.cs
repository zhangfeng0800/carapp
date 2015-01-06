using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Sql;
using System.EnterpriseServices;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceModel.Configuration;
using System.Text;
using System.Web;
using System.Web.Configuration;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Bson;
using Newtonsoft.Json.Linq;

namespace CarAppAdminWebUI.Member
{
    /// <summary>
    /// PhoneCenterHandler 的摘要说明
    /// </summary>
    public class PhoneCenterHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var url = WebConfigurationManager.AppSettings["callcenteraddr"];
            if (context.Request["action"] == "list")
            {
                int count;
                var pagesize = context.Request["rows"] ?? "15";
                var pageindex = context.Request["page"] ?? "1";
                var jobnumber = context.Request["jobnumber"].ToString();
                var condition = " 1=1 ";
                if (!string.IsNullOrEmpty(jobnumber))
                {
                    condition += " and exten like '%" + Common.Tool.SqlFilter(jobnumber) + "%' ";
                }
                if (!string.IsNullOrEmpty(context.Request["status"]))
                {
                    condition += " and isuse=" + context.Request["status"];
                }
                try
                {
                    var data = JsonConvert.DeserializeObject<ResponseResult>(ServiceHelper.GetServiceResponse("http://"+url+"/GetAllExten",
                        new Dictionary<string, string>()));
                    if (data.ExecResult.ToLower() == "true")
                    {
                        var result = data.GetAllExtenResult;
                        if (!string.IsNullOrEmpty(context.Request["status"]))
                        {
                            result = result.Where(p => p.Status == int.Parse(context.Request["status"])).ToList();
                        }
                        if (!string.IsNullOrEmpty(jobnumber))
                        {
                            result = result.Where(p => p.Exten.Contains(jobnumber)).ToList();
                        }
                        var realResult = result.OrderBy(p => p.Exten).Skip((int.Parse(pageindex) - 1) * int.Parse(pagesize)).Take(int.Parse(pagesize)).ToList();
                        context.Response.Write(JsonConvert.SerializeObject(new { index = pageindex, total = result.Count, rows = realResult }));
                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                }
            }
            else if (context.Request["action"] == "checkinout" && context.Request["groupid"] != null && context.Request["exten"] != null)
            {
                try
                {
                    string message;
                    var parameters = new Dictionary<string, string>();
                    var bll = new AdminBll();

                    var logModel = new ExtenLog()
                    {
                        Exten = context.Request["exten"],
                        Name = context.User.Identity.Name,
                        OperationTime = DateTime.Now,
                    };
                    var text = "";
                    var dict = new Dictionary<string, string>();
                    dict.Add("groupid", "0");
                    dict.Add("exten", context.Request["exten"]);
                    var serviceResponse = ServiceHelper.GetServiceResponse("http://"+url+"/GetStatus", dict);
                    if (serviceResponse.Contains("checkedin"))
                    {
                        logModel.OperationType = CallcenterOperationType.签出.ToString();
                        parameters.Add("state", "0");
                        text = "签出";
                        Global.RemoveExten(context.Request["exten"]);
                        LogHelper.WriteOperation("客服[" + context.User.Identity.Name + "]签出，签出的坐席号是[" + context.Request["exten"] + "]，签出时间是[" + DateTime.Now.ToString() + "]", OperationType.Login, "签出成功");
                    }
                    else
                    {
                        parameters.Add("state", "1");
                        logModel.OperationType = CallcenterOperationType.签入.ToString();
                        text = "签入";
                        Global.ExtenLogin(context.Request["exten"]);
                        LogHelper.WriteOperation("客服[" + context.User.Identity.Name + "]签入，签入的坐席号是[" + context.Request["exten"] + "]，签入时间是[" + DateTime.Now.ToString() + "]", OperationType.Login, "签入成功");
                    }
                    parameters.Add("groupid", context.Request["groupid"]);
                    parameters.Add("exten", context.Request["exten"]);
                    var result = ServiceHelper.GetServiceResponse("http://" + url+"/CheckInOut", parameters);
                    if (string.IsNullOrEmpty(result))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "操作失败" }));
                        return;
                    }

                    var dictionary = JsonConvert.DeserializeObject<Dictionary<string, string>>(result);
                    if (dictionary.First().Value == "failure")
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "操作失败" }));
                        return;
                    }
                    else if (dictionary.First().Value == "success")
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg = "操作成功", text = text }));
                        new ExtenLogBLL().Insert(logModel);
                        return;
                    }
                    else
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "操作失败" }));
                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "操作失败" }));
                }
            }
            else if (context.Request["action"] == "group")
            {
                var response = ServiceHelper.GetServiceResponse("http://"+url+"/GetAllExten", new Dictionary<string, string>());
                if (string.IsNullOrEmpty(response))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var result = JObject.Parse(response);
                var sign = bool.Parse(result.Last.Values().First().ToString().ToLower());
                if (!sign)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var data = result.First.Values();
                var list = data.Select(val => val["groupid"].ToString()).ToList();
                var groupresult = list.Distinct();
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = groupresult }));
            }
            else if (context.Request["action"] == "exten" || context.Request["groupid"] != null)
            {
                var response = ServiceHelper.GetServiceResponse("http://" + url+"/GetAllExten", new Dictionary<string, string>());
                if (string.IsNullOrEmpty(response))
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var result = JObject.Parse(response);
                var sign = bool.Parse(result.Last.Values().First().ToString().ToLower());
                if (!sign)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var data = result.First.Values();
                var list = data.Where(p => p["groupid"].ToString() == context.Request["groupid"]).ToList();
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, data = list }));
                return;
            }
            else if (context.Request["action"] == "loglist")
            {
                int count;
                var pagesize = context.Request["rows"] ?? "15";
                var pageindex = context.Request["page"] ?? "1";
                var condition = " 1=1 ";
                if (!string.IsNullOrEmpty(context.Request["name"]))
                {
                    condition += " and name like '%" + Common.Tool.SqlFilter(context.Request["name"]) + "%'";
                }
                if (!string.IsNullOrEmpty(context.Request["exten"]))
                {
                    condition += " and exten like '%" + Common.Tool.SqlFilter(context.Request["exten"]) + "%'";
                }
                if (!string.IsNullOrEmpty(context.Request["type"]))
                {
                    condition += " and operationtype ='" + Common.Tool.SqlFilter(context.Request["type"]) + "'";
                }
                if (!string.IsNullOrEmpty(context.Request["startdate"]))
                {
                    var startdate = DateTime.Parse(context.Request["startdate"]);
                    condition += " and  operationtime>='" + startdate.ToString("yyyy-MM-dd 00:00:00")+"'";              
                }
                if( !string.IsNullOrEmpty(context.Request["enddate"]))
                {
                    var enddate = DateTime.Parse(context.Request["enddate"]);
                    condition += " and  operationtime<='" + enddate.ToString("yyyy-MM-dd 23:59:59") + "'";
                }
                try
                {
                    var data = (new ExtenLogBLL()).PagerList(int.Parse(pagesize), int.Parse(pageindex), condition, out count);
                    context.Response.Write(JsonConvert.SerializeObject(new { index = pageindex, total = count, rows = data }));
                }
                catch (Exception exception)
                {
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