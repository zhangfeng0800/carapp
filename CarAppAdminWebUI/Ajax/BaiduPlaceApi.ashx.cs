using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using BLL;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// BaiduPlaceApi 的摘要说明
    /// </summary>
    public class BaiduPlaceApi : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["q"] != null && context.Request["region"] != null && context.Request["ishot"] != null)
            {
                var result = GetResponse(context, context.Request["q"], context.Request["region"], context.Request["ishot"]);
                
                context.Response.Write((result));
            }
        }
        public string GetResponse(HttpContext context, string queryString, string cityname, string ishot)
        {
            context.Response.ContentType = "application/json";
            var bll = new CityBLL();
            if (ishot == "1")
            {
                var hl = new HotLineBLL();
                DataTable dt = hl.GetHotlineById(int.Parse(cityname));
                if (dt.Rows.Count > 0)
                {
                    cityname = dt.Rows[0][0].ToString();
                }
            }
            var city = "";
            var data = bll.GetFullResult(cityname);
            if (data.Rows.Count > 0)
            {
                city = data.Rows[0]["citysname"].ToString();
                if (!city.Contains("市"))
                {
                    city = city + "市";
                }
            }
            else
            {
                if (!cityname.Contains("市"))
                {
                    city = cityname + "市";
                }
            }
            var request = (HttpWebRequest)WebRequest.Create("http://api.map.baidu.com/place/v2/search?&q=" + queryString + "&region=" + city + "&output=json&ak=kYvztiBTS4EKotMmUMyLt0dy");

            var response = request.GetResponse();
            Stream stream = response.GetResponseStream();
            if (stream != null)
            {
                var srReader = new StreamReader(stream);
                return srReader.ReadToEnd();
            }
            return "";
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}