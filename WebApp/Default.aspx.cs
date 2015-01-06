using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using Common;
using Model;
using ArticalContent = BLL.ArticalContent;

namespace WebApp
{

    public partial class Default : System.Web.UI.Page
    {
        public DataTable Data = new DataTable();
        public DataTable Hotcitylist = new DataTable();
        public List<Model.carBrand> carBrandList = new List<Model.carBrand>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.UrlReferrer != null)
            {
                string rawurl = Request.UrlReferrer.Host.ToString();
                if (rawurl.Contains("m.iezu.cn"))
                {

                }
                else
                {
                    string brower = "";
                    if (CheckBrower(Request.UserAgent, out brower))
                    {
                        Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["mobileUrl"].ToString());
                    }
                }
            }
            else
            {
                string brower = "";
                if (CheckBrower(Request.UserAgent, out brower))
                {
                    Response.Redirect(System.Configuration.ConfigurationManager.AppSettings["mobileUrl"].ToString());
                }
            }
         ;
            Hotcitylist =  new ServiceCityBLL().GetHotCity();
            int Count = 0;            
            carBrandList = DataTableToList.List<Model.carBrand>(new BLL.CarBrandBLL().GetAllCarBrand());
        }

        public IEnumerable<DataRow> GetCarBrand()
        {
            return (new CarBrandBLL()).GetAllCarBrand().AsEnumerable().Take(8);
        }
        public IEnumerable<Model.ArticalContent> GetTopNews(int skipnum = 0)
        {
            return BLL.ArticalContent.GetArticalContents().OrderBy(p => p.ID).Skip(skipnum).Take(3);
        }
        protected bool CheckBrower(string userAgent, out string browserName)
        {
            if (userAgent.ToLower().Contains("android"))
            {
                browserName = "Android";
                return true;
            }
            if (userAgent.ToLower().Contains("ucbrowser"))
            {
                browserName = "UC";
                return true;
            }
            if (userAgent.ToLower().Contains("iphone"))
            {
                browserName = "IPhone";
                return true;
            }
            if (userAgent.ToLower().Contains("wpdesktop"))
            {
                browserName = "WindowsPhone";
                return true;
            }
            else
            {
                browserName = "PC";
                return false;
            }
        }
    }
}