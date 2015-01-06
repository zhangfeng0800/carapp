using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Weixin
{
    public partial class NewsManage : System.Web.UI.Page
    {
        protected int unsendNum = 4;
        protected void Page_Load(object sender, EventArgs e)
        {
            unsendNum =4- new WxNewsBLL().GetNowSendNum();
            if (unsendNum < 0)
                unsendNum = 0;
        }
    }
}