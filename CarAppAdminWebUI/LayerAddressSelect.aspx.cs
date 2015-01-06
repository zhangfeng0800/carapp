using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Common;
using Newtonsoft.Json;

namespace CarAppAdminWebUI
{
    public partial class LayerAddressSelect : System.Web.UI.Page
    {
        public string controlId = "";
        protected string location = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["controlId"]!=null)
            {
                if (Request.QueryString["cityName"] == null || Request.QueryString["cityName"].ToString() == "")
                {
                    Response.Write("需要先选择城市");
                    Response.End();
                }
                controlId = Request.QueryString["controlId"];
                var cityName = Request.QueryString["cityName"].ToString();

                var addressJson = JsonConvert.DeserializeObject<GeoLocationLngLat>(BaiduAPI.GetLngByPlace(cityName + "市政府", cityName + "市"));
                var startLat = addressJson.result.location.lat;//纬度
                var startLng = addressJson.result.location.lng;//经度
                location = startLng + "," + startLat;
            }
        }
    }
}