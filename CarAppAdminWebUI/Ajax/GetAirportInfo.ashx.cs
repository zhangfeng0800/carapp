using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using Common;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// GetAirportInfo 的摘要说明
    /// </summary>
    public class GetAirportInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            try
            {
                StringBuilder sb=new StringBuilder();
                if (string.IsNullOrEmpty(context.Request["number"]))
                {
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(new List<object>()));
                    return;
                }
              
                var number = context.Request["number"].ToString(); 
                sb.Append("flight_number=" + number);
                if (!string.IsNullOrEmpty(context.Request["date"]))
                {
                    sb.Append("&dep_date=" + context.Request["date"]);
                }
                string outdata = "";
                string Url = "http://www.yongche.com/ajax/get_flight_info.php?"+sb.ToString();
                HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(Url);
                myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
                myHttpWebRequest.Method = "get";
                myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
                HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
                Stream myResponseStream = myHttpWebResponse.GetResponseStream();
                StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
                outdata = myStreamReader.ReadToEnd();
                myStreamReader.Close();
                myResponseStream.Close();
                var result = JsonConvert.DeserializeObject<AirportEntity>(outdata);
                if (result.code != 200)
                {
                    HttpContext.Current.Response.Write(JsonConvert.SerializeObject(new List<object>()));
                    return;
                }
                var airplaneInfo = JsonConvert.DeserializeObject(result.result.ToString(), typeof(List<AirplaneInfo>));
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(airplaneInfo));
            }
            catch (Exception exp)
            {
                HttpContext.Current.Response.Write(JsonConvert.SerializeObject(new List<object>()));
            }
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