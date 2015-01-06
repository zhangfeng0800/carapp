using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;
using Model.Ext;

namespace WebApp
{
    public partial class travel : System.Web.UI.Page
    {
        public DataTable data = new DataTable();
        public List<TravelTheme> ThemeList = new List<TravelTheme>();
        protected void Page_Load(object sender, EventArgs e)
        {
            data = (new HotLineBLL()).GetTravelCityList();
            ThemeList = (new  TravelthemeBll()).GetParentChildList();
        }
    }
}