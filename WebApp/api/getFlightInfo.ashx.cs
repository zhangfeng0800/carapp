using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;
using System.Net;
using System.IO;
using System.Text;

namespace WebApp.api
{
    /// <summary>
    /// getFlightInfo 的摘要说明
    /// </summary>
    public class getFlightInfo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string date = context.Request["date"];
            string flightNumber = context.Request["flightNumber"];
            context.Response.Write(GetDetail(date,flightNumber));
        }

        public string GetDetail(string date,string flightNumber)
        {
            string outdata = "";
            string Url = "http://www.yongche.com/ajax/get_flight_info.php?dep_date=" + date + "&flight_number="+flightNumber;
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
            return outdata;
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