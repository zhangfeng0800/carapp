using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using CarAppAdminWebUI.Signalr.Hubs;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace CarAppAdminWebUI
{
    public partial class PushOrderMsg : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var hubContext = GlobalHost.ConnectionManager.GetHubContext<OrderMsgHub>();
            hubContext.Clients.All.notice("刷新订单列表");
            ClientScript.RegisterStartupScript(base.GetType(), "message",
                "<script language='javascript' defer></script>");




        }
    }
}