using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Text;
using System.IO;

namespace WebApp.api
{
    /// <summary>
    /// GetFlightNum 的摘要说明
    /// </summary>
    public class GetFlightNum : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string query=context.Request["q"];
            context.Response.Write(Do_GetFligth(query));
        }
        public string Do_GetFligth(string query)
        {
            string outdata = "";
            string Url = "http://www.yongche.com/ajax/flight_complete.php?q="+query+"&limit=10";
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