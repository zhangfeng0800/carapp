using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.SysConfig
{
    public partial class ConfigRCoupon : System.Web.UI.Page
    {
        protected string val1 = string.Empty;
        protected string val2 = string.Empty;
        protected string val3 = string.Empty;
        private readonly SystemConfigBLL _bll=new SystemConfigBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            val1 = _bll.Get(Common.SystemConfig.注册送优惠券金额);
            val2 = _bll.Get(Common.SystemConfig.注册送优惠券限额);
            val3 = _bll.Get(Common.SystemConfig.注册送优惠券名称);
        }
    }
}