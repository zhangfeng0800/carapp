using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;

namespace CarAppAdminWebUI.ProvinceCity
{
    public partial class HotLineTraveltheme : System.Web.UI.Page
    {
        protected string Values = string.Empty;
        private readonly TravelthemeBll _travelthemeBll=new TravelthemeBll();
        protected void Page_Load(object sender, EventArgs e)
        {
            var list = _travelthemeBll.GetLineThemeList("lineid=" + Request.QueryString["id"]);
            foreach (DataRow dr in list.Rows)
            {
                Values += dr["themeid"] + ",";
            }
            if (!string.IsNullOrEmpty(Values))
            {
                Values = Values.Substring(0, Values.Length - 1);
            }
        }
    }
}