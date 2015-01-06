using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.Signalr.Hubs;
using IEZU.Log;
using Microsoft.AspNet.SignalR;

namespace CarAppAdminWebUI
{
    public partial class Push : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            IHubContext hubContext = GlobalHost.ConnectionManager.GetHubContext<PushHub>();
            try
            {
                var caller = Request["caller"];
                var callee = Request["callee"];
                var result = 0;

                var usertelphone = "";
                var callertelphone = "";

                if (caller.IndexOf(',') > 0)
                {
                    var regex = new Regex(@"^(\d{3,4}-)?\d{6,8}$");
                    usertelphone = caller.Split(',')[0];
                    if (!regex.IsMatch(usertelphone))
                    {
                        if (usertelphone.StartsWith("0"))
                        {
                            usertelphone = usertelphone.Substring(1);
                        }
                    }
                    callertelphone = caller.Split(',')[1];
                    if (!regex.IsMatch(callertelphone))
                    {
                        if (callertelphone.Trim().StartsWith("0"))
                        {
                            callertelphone = callertelphone.Substring(1);
                        }
                    }
                }
                try
                {
                    if (Request.QueryString["redial"] == null)
                    {
                        var exten = 0;
                        if (!string.IsNullOrEmpty(Request.QueryString["callee"]) &&
                            int.TryParse(Request.QueryString["callee"], out exten))
                        {
                            if (Request.QueryString["callee"].ToString().Length == 4 && usertelphone.Length != 0 && caller.Length != 0 && callertelphone.Length != 0)
                            {
                                var dialInfo = new Model.DialInfo()
                                {
                                    AdminId = 0,
                                    DialTime = DateTime.Now,
                                    ExtenNum = callee,
                                    UserTelphone = usertelphone.Length > 11 ? usertelphone.Substring(0, 11) : usertelphone,
                                    Caller = callertelphone.Length > 11 ? callertelphone.Substring(0, 11) : callertelphone,
                                    Status = "未处理"
                                };
                                result = (new BLL.DialInfoBLL()).AddData(dialInfo);
                            }
                        }
                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                }
                hubContext.Clients.All.notice("<div title='点击刷新' style=\"float:right;margin-right:50px;cursor:pointer;\" onclick='refresh()'><img width='16' height='16' src=\"/static/images/refresh.png\"/>刷新</div><iframe id=\"ifrname\" name='caller" + callee + "caller' src='/Layer.aspx?telphone=" + usertelphone + ',' + callertelphone + "&callee=" + callee + "&dialid=" + result.ToString() + "' width=1000 height=700></iframe>");
                ClientScript.RegisterStartupScript(base.GetType(), "message",
                    "<script language='javascript' defer></script>");
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
        }

        protected void btn_Send_Click(object sender, EventArgs e)
        {

        }
    }
}