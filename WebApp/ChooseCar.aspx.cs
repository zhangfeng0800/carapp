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
    public partial class ChooseCar : System.Web.UI.Page
    {
        public string CarUseName = "";
        public string CityName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            int cityid;
            int usewayid;
            int linetype;
            int hotlineid;
            if (Request.QueryString.Count == 2)
            {
                if (Request.QueryString["cityid"] != null & Request.QueryString["carusewayid"] != null)
                {
                    if (int.TryParse(Request.QueryString["cityid"], out cityid) &&
                        int.TryParse(Request.QueryString["carusewayid"], out usewayid))
                    {
                        CarUseName = "用车方式：" + (new CarUseWayBLL()).GetCarUseWayModel(usewayid).Name;
                        var data = (new CityBLL()).GetFullResult(cityid.ToString());
                        if (data.Rows.Count > 0)
                        {
                            CityName = "用车城市：" + data.Rows[0]["provincename"] + " " + data.Rows[0]["citysname"] + " " + data.Rows[0]["townname"];
                        }
                    }
                    else
                    {
                        Page.Response.Redirect("/");
                    }

                }
                else
                {
                    Response.Redirect("/");
                }
            }
            else if (Request.QueryString.Count == 4)
            {
                if (Request.QueryString["cityid"] != null & Request.QueryString["carusewayid"] != null & Request.QueryString["hotlineId"] != null & Request.QueryString["lineType"] != null)
                {
                    if (int.TryParse(Request.QueryString["cityid"], out cityid) &&
                         int.TryParse(Request.QueryString["carusewayid"], out usewayid) &&
                         int.TryParse(Request.QueryString["hotlineId"], out  hotlineid) &&
                         int.TryParse(Request.QueryString["lineType"], out  linetype))
                    {

                        var isoneway = linetype == 0 ? "往返" : "单程";
                        var bll = new CityBLL();
                        var hotlinebll = new HotLineBLL();
                        var data = hotlinebll.GetHotLineList(cityid);
                        CarUseName = "用车方式：" + "热门路线(" + isoneway + ")";
                        var citydata = (new CityBLL()).GetFullResult(cityid.ToString());
                        try
                        {
                            var startname = citydata.Rows[0]["provincename"].ToString() +
                                            citydata.Rows[0]["citysname"].ToString() +
                                            citydata.Rows[0]["townname"].ToString();
                            var hotline = (new HotLineBLL()).GetHotlineById(hotlineid).Rows[0][0].ToString();
                            var hotdata = (new CityBLL()).GetFullResult(hotline);
                            var endname = hotdata.Rows[0]["provincename"].ToString() +
                                          hotdata.Rows[0]["citysname"].ToString() +
                                          hotdata.Rows[0]["townname"].ToString();
                            CityName = "起点城市：" + startname + "<br/>终点城市：" + endname;
                        }
                        catch
                        {
                            Page.Response.Redirect("/");
                        }
                    }
                    else
                    {
                        Page.Response.Redirect("/");
                    }
                }
            }

        }
    }
}