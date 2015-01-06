using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp
{
    public partial class hotline : System.Web.UI.Page
    {
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        protected List<CityModel> List = new List<CityModel>();
        public string wayname = "";
        public string querystring = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["cityid"] != null)
                {
                    querystring = Request.QueryString["cityid"].ToString();
                }
                List = _serviceCityBll.GetCityList(6);
            }
        }

        public string GetCityName(string codeid)
        {
            var bll = new CityBLL();
            var dt = bll.GetCityById(codeid);
            return dt.Rows.Count > 0 ? dt.Rows[0]["cityname"].ToString() : "";
        }
    }
}