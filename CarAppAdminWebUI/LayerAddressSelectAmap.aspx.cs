using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using Common;

namespace CarAppAdminWebUI
{
    public partial class LayerAddressSelectAmap : System.Web.UI.Page
    {
        public string controlId = "";
        protected string address = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["controlId"] != null)
            {
                if (Request.QueryString["cityName"] == null || Request.QueryString["cityName"].ToString() == "")
                {
                    Response.Write("需要先选择城市");
                    Response.End();
                }
                controlId = Request.QueryString["controlId"];
                var cityName = Request.QueryString["cityName"].ToString();

                address = cityName + "市政府";
            }
        }
    }
}