using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Web.Script.Serialization;
using System.Text;
using System.IO;

namespace CarAppAdminWebUI.App_Code
{
    /// <summary>
    ///WXCommon 的摘要说明
    /// </summary>
    public static class WXCommon
    {
        public static string Token = "aiyizuweixin"; //微信里面开发者模式Token
        public static string appid = "wx2345420d88954ca7";//微信里面开发者模式：开发者，ID开发者凭据APPIDwx2345420d88954ca7
        public static string appsecret = "87b870e88dbdbe8ec552ff79e40dc7a4";//微信里面开发者模式： 开发者密码 AppSecret

        /// <summary>
        /// 获得access_token,获得通行证
        /// </summary>
        /// <param name="appid"></param>
        /// <param name="appsecret"></param>
        /// <returns></returns>
        public static string Get_Access_token()
        {
            WebClient webclient = new WebClient();

            string url = @"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=" + appid + "&secret=" + appsecret + "";
            byte[] bytes = webclient.DownloadData(url);//在指定的path上下载
            string result = Encoding.GetEncoding("utf-8").GetString(bytes);//转string
            JavaScriptSerializer js = new JavaScriptSerializer();
            //access_token类建立在本文档的最下面.
            accesstoken amodel = js.Deserialize<accesstoken>(result);//此处为定义的类，用以将json转成model        
            string a_token = amodel.access_token;
            return a_token;
        }

        public static string GetOpenidList(string access_token)
        {
            WebClient webclient = new WebClient();

            string url = @"https://api.weixin.qq.com/cgi-bin/user/get?access_token=" + access_token;
            byte[] bytes = webclient.DownloadData(url);//在指定的path上下载
            string result = Encoding.GetEncoding("utf-8").GetString(bytes);//转string
            JavaScriptSerializer js = new JavaScriptSerializer();
            //access_token类建立在本文档的最下面.
            OpenID openmodel = js.Deserialize<OpenID>(result);//此处为定义的类，用以将json转成model       

            string rej = string.Join("\",\"", openmodel.data.openid);
            return rej;
        }
        /// <summary>
        /// 根据地址获取信息
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string GetData(string url)
        {
            string outdata = "";
            string token_url = url;

            HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(token_url);
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


        /// <summary>
        /// 向微信端发送post请求
        /// </summary>
        /// <param name="posturl">请求地址</param>
        /// <param name="postData">请求内容</param>
        /// <returns></returns>
        public static string GetPage(string posturl, string postData)
        {
            Stream outstream = null;
            Stream instream = null;
            StreamReader sr = null;
            HttpWebResponse response = null;
            HttpWebRequest request = null;
            Encoding encoding = Encoding.UTF8;
            byte[] data = encoding.GetBytes(postData);
            // 准备请求...
            try
            {
                // 设置参数
                request = WebRequest.Create(posturl) as HttpWebRequest;
                CookieContainer cookieContainer = new CookieContainer();
                request.CookieContainer = cookieContainer;
                request.AllowAutoRedirect = true;
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;

                outstream = request.GetRequestStream();
                outstream.Write(data, 0, data.Length);
                outstream.Close();
                //发送请求并获取相应回应数据
                response = request.GetResponse() as HttpWebResponse;
                //直到request.GetResponse()程序才开始向目标网页发送Post请求
                instream = response.GetResponseStream();
                sr = new StreamReader(instream, encoding);
                //返回结果网页（html）代码
                string content = sr.ReadToEnd();
                string err = string.Empty;
                return content;
            }
            catch (Exception ex)
            {
                string err = ex.Message;
                return string.Empty;
            }
        }

        
    }

    public class accesstoken
    {
        public string access_token { get; set; }
        public string expires_in { get; set; }
    }

    public class fileUp
    {
        public string type { get; set; }
        public string media_id { get; set; }
        public string created_at { get; set; }
    }

    public class erroModel
    {
        public string errcode { get; set; }
        public string errmsg { get; set; }
        public string msg_id { get; set; }
    }

    public struct data
    {
        public string[] openid;
    }
    public struct OpenID
    {
        public int total;
        public int count;
        public data data;
        public string next_openid;
    }

}