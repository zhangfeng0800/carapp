using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using BLL;
using IEZU.Log;
using Model;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// MyOrderHandler 的摘要说明
    /// </summary>
    public class MyOrderHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            try
            {
                OrderBLL bll = new OrderBLL();
                if (context.Session["UserInfo"] != null)
                {
                    var user = (UserAccount)context.Session["UserInfo"];
                    if (user == null)
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请求失败" }));
                        return;
                    }
                    var uid = user.Id;
                    var condition = "";
                    if (string.IsNullOrEmpty(context.Request["startDate"]) || string.IsNullOrEmpty(context.Request["endDate"]))
                    {
                        if (user.Type == 2 || user.Type == 3)
                        {
                            if (context.Request["status"] == "all")
                            {
                                condition = " userid=" + uid;
                            }
                            else
                            {
                                condition = " userid=" + uid + "and orderstatusid=" + context.Request["status"];
                            }
                        }
                        else
                        {
                            var list = (new UserAccountBLL()).GetSubIdArrayStr(user.Id);
                            if (context.Request["status"] == "all")
                            {
                                condition = " userid in (" + list + ")";
                            }
                            else
                            {
                                condition = " userid in (" + list + ") and orderstatusid=" + context.Request["status"];
                            }
                        }


                    }
                    else if (context.Request["status"] == "all")
                    {
                        if (user.Type == 2 || user.Type == 3)
                        {
                            condition = " userid=" + uid + "  and  orderdate between '" +
                                        Common.Tool.SqlFilter(context.Request["startDate"]) + " 00:00:00'  and '" +
                                        Common.Tool.SqlFilter(context.Request["endDate"]) + " 23:59:59'";
                        }
                        else
                        {
                            var list = (new UserAccountBLL()).GetSubIdArrayStr(user.Id);
                            condition = " userid in (" + list + ")  and  orderdate between '" +
                                       Common.Tool.SqlFilter(context.Request["startDate"]) + " 00:00:00'  and '" +
                                       Common.Tool.SqlFilter(context.Request["endDate"]) + " 23:59:59'";
                        }
                    }
                    else
                    {
                        if (user.Type == 2 || user.Type == 3)
                        {
                            condition = " userid=" + uid + " and orderstatusid=" + context.Request["status"] +
                                        " and  orderdate between '" +
                                        Common.Tool.SqlFilter(context.Request["startDate"]) + " 00:00:00'  and '" +
                                        Common.Tool.SqlFilter(context.Request["endDate"]) + " 23:59:59'";
                        }
                        else
                        {
                            var list = (new UserAccountBLL()).GetSubIdArrayStr(user.Id);
                            condition = " userid in (" + list + ") and orderstatusid=" + context.Request["status"] +
                                      " and  orderdate between '" +
                                      Common.Tool.SqlFilter(context.Request["startDate"]) + " 00:00:00'  and '" +
                                      Common.Tool.SqlFilter(context.Request["endDate"]) + " 23:59:59'";
                        }
                    }
                    var result = bll.GetOrderPagerOld(int.Parse(context.Request["pageIndex"]), int.Parse(context.Request["pageSize"]), condition);
                    context.Response.Write(JsonConvert.SerializeObject(new
                    {
                        resultcode = 1,
                        data = result
                    }));
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请求失败" }));
                    return;
                }

            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请求失败" }));
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