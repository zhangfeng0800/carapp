using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using BLL;

namespace WebApp.api
{
    /// <summary>
    /// BaiduPlaceApi 的摘要说明
    /// </summary>
    public class BaiduPlaceApi : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var q = context.Request.Form["q"];
            context.Response.Write(GetResponse(context, q, context.Request.Form["c"], context.Request.Form["ishot"]));
        }

        public string GetResponse(HttpContext context, string queryString, string cityname, string ishot)
        {
            context.Response.ContentType = "application/json";
            CityBLL bll = new CityBLL();
            if (ishot == "1")
            {
                HotLineBLL hl = new HotLineBLL();
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
            StreamReader srReader = new StreamReader(stream);
            return srReader.ReadToEnd();
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