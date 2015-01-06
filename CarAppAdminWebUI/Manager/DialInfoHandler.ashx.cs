using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Manager
{
    /// <summary>
    /// DialInfoHandler 的摘要说明
    /// </summary>
    public class DialInfoHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["action"] == "list")
            {
                List(context);
                return;
            }
            if (context.Request["action"] == "callback")
            {
                CallBackOrder(context);
                return;
            }
            if (context.Request["action"] == "extenlist")
            {
                ExtentList(context);
                return;
            }
            if (context.Request["action"] == "statusetting")
            {
                ChangeExtenStatus(context);
                return;
            }

        }

        public void CallBackOrder(HttpContext context)
        {
            var id = 0;
            if (context.Request["id"] == null || !int.TryParse(context.Request["id"], out id))
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));
                return;
            }
            var dialinfobll = new DialInfoBLL();
            var dialInfoModel = dialinfobll.GetModel(id);
            if (dialInfoModel == null)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));
                return;
            }
            try
            {
                var cookie = context.Request.Cookies["exten"];
                if (cookie == null)
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));
                    return;
                }
                var exten = cookie.Value;
                if (exten == "0")
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));
                    return;
                }
                var request =
                    (HttpWebRequest)
                        WebRequest.Create("http://admin.iezu.cn/push.aspx?caller=" + dialInfoModel.UserTelphone + "," +
                                          dialInfoModel.Caller + "&callee=" + exten + "&redial=1&dialid=" + id +
                                          "&timestamp=" + DateTime.Now.ToString("yyyyMMddHHmmssffffff"));
                request.Method = "get";
                request.ContentType = "application/x-www-form-urlencoded";
                request.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
                var myHttpWebResponse = (HttpWebResponse)request.GetResponse();
                Stream myResponseStream = myHttpWebResponse.GetResponseStream();
                var result = "";
                if (myResponseStream != null)
                {
                    var myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
                    result = myStreamReader.ReadToEnd();
                    myStreamReader.Close();
                    myResponseStream.Close();
                }
                try
                {
                    if (!string.IsNullOrEmpty(context.Request.QueryString["id"]))
                    {
                        var dialid = context.Request.QueryString["id"].ToString();
                        var _dialid = 0;
                        if (int.TryParse(dialid, out _dialid))
                        {

                            dialInfoModel.AdminId = int.Parse(context.Request["adminname"]);
                            dialInfoModel.Status = "已处理";
                            dialinfobll.UpdateData(dialInfoModel);
                        }
                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                }
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.成功 }));
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = ResultCode.业务操作失败 }));
                return;
            }

        }

        public void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var bll = new BLL.DialInfoBLL();
            var condition = " 1=1 ";
            if (!string.IsNullOrEmpty(context.Request["usertelphone"]))
            {
                condition += " and ua.telphone like '%" + Common.Tool.SqlFilter(context.Request["usertelphone"]) + "%'";
            }
            if (!string.IsNullOrEmpty(context.Request["name"]))
            {
                condition += " and ua.compname like '%" + Common.Tool.SqlFilter(context.Request["name"]) + "%'";
            }
            if (!string.IsNullOrEmpty(context.Request["caller"]))
            {
                condition += " and dl.caller like '%" + Common.Tool.SqlFilter(context.Request["caller"]) + "%'";
            }
            if (!string.IsNullOrEmpty(context.Request["adminname"]))
            {
                condition += " and ad.adminname like '%" + Common.Tool.SqlFilter(context.Request["adminname"]) + "%'";
            }
            if (!string.IsNullOrEmpty(context.Request["exten"]))
            {
                condition += " and dl.extennum like '%" + Common.Tool.SqlFilter(context.Request["exten"]) + "%'";
            }
            var data = bll.GetPager(pageSize, pageIndex, condition, out count);
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                index = pageIndex,
                total = count,
                rows = data
            }));
        }

        public void ExtentList(HttpContext context)
        {
            var extent = (context.Request["extennt"] ?? "").Trim();
            var status = int.Parse(context.Request["status"]);
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            var count = 0;
            var data = (new ExtenLogBLL()).ExtentPager(extent, status, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new
            {
                index = pageIndex,
                total = count,
                rows = data
            }));
        }

        public void ChangeExtenStatus(HttpContext context)
        {
            var status = int.Parse(context.Request["status"]);
            var extent = context.Request["extent"];
            var result = (new ExtenLogBLL()).ExtenStatusSetting(extent, status == 1 ? 0 : 1);

            context.Response.Write(JsonConvert.SerializeObject(new
            {
                resultcode = result
            }));

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