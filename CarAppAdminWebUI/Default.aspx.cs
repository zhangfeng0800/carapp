using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;

namespace CarAppAdminWebUI
{
    public partial class Default : System.Web.UI.Page
    {
        protected Model.Admin Model;
        private readonly AdminBll _adminBll = new AdminBll();
        public string Exten = "";
        public string Status = "";   
        protected void Page_Load(object sender, EventArgs e)
        {
              var url = WebConfigurationManager.AppSettings["callcenteraddr"];
            Model = _adminBll.GetModel(User.Identity.Name);

            var httpCookie = Request.Cookies["exten"];
            if (httpCookie != null && httpCookie.Value !="")
            {
                    Exten = httpCookie.Value;
                    var dict = new Dictionary<string, string>();
                    dict.Add("groupid", "0");
                    dict.Add("exten", Exten);
                    var result = ServiceHelper.GetServiceResponse("http://"+url+"/GetStatus", dict);
                    if (result.Contains("checkedin"))
                    {
                        Status = "签入";
                    }
                    else if (result.Contains("checkedout"))
                    {
                        Status = "签出";
                    }
                    else
                    {
                        Status = "状态未知";
                    }
                

            }

          
        }

    }
}