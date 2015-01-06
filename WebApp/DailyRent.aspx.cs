using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Model;

namespace WebApp
{
    public partial class DailyRent : System.Web.UI.Page
    {
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        protected List<CityModel> List = new List<CityModel>();
        public string wayname = "";
        public string wayid;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["wayid"] != null)
                {
                    wayid = Request.QueryString["wayid"];
                   
                    List = _serviceCityBll.GetCityList(int.Parse((Request.QueryString["wayid"].ToString())));
                    var model =
                        (new BLL.CarUseWayBLL()).GetCarUseWayModel(int.Parse(Request.QueryString["wayid"].ToString()));
                    if (model != null)
                    {
                        wayname = model.Name;
                    }
                    else
                    {
                        wayname = "暂无此类型";
                    }
                 
                }

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