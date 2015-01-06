using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Configuration;
using BLL;
using Common;
using IEZU.Log;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// CallBack 的摘要说明
    /// </summary>
    public class CallBack : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["caller"] != null && context.Request["callee"] != null)
            {
                var caller = context.Request["caller"];
                var responseData = JsonConvert.DeserializeObject<ResponseResult>(GetServiceResponse("http://" + WebConfigurationManager.AppSettings["callcenteraddr"] + "/GetAllExten", new Dictionary<string, string>())).GetAllExtenResult.Where(p => p.Exten == caller);
                if (!responseData.Any())
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                    return;
                }
                var dict = new Dictionary<string, string>();
                var regex = new Regex(@"^(\d{3,4}-)?\d{6,8}$");
                var callee = context.Request["callee"];
                if (!regex.IsMatch(callee))
                {
                    if (callee.StartsWith("0"))
                    {
                        callee = callee.Substring(1);
                    }
                }
                var placeInfo = MobileAddress.GetMobileAddress(callee);

                if (placeInfo != null)
                {
                    if (placeInfo.retmsg.ToLower() == "error")
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                        return;
                    }
                    if (placeInfo.city.IndexOf("石家庄", System.StringComparison.Ordinal) > -1)
                    {
                        dict.Add("callee", "9" + callee);
                    }
                    else
                    {
                        dict.Add("callee", "90" + caller);
                    }
                    dict.Add("caller", context.Request["caller"]);
                    var result = GetServiceResponse("http://" + WebConfigurationManager.AppSettings["callcenteraddr"] + "/dial", dict);
                    if (string.IsNullOrEmpty(result))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
                        return;
                    }
                    if (result.Contains("success"))
                    {
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1 }));
                        return;
                    }
                }

                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0 }));
            }
        }
        private string GetServiceResponse(string url, Dictionary<string, string> parameters)
        {
            var suffix = new StringBuilder();
            foreach (var parameter in parameters)
            {
                suffix.Append(parameter.Key);
                suffix.Append("=");
                suffix.Append(parameter.Value);
                suffix.Append("&");
            }
            Stream stream = new MemoryStream();
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(url + "?" + suffix.ToString().TrimEnd('&'));
                WebResponse response = request.GetResponse();
                stream = response.GetResponseStream();
                if (stream != null)
                {
                    var reader = new StreamReader(stream);
                    return reader.ReadToEnd();
                }
            }
            catch (Exception exception)
            {
                LogHelper.WriteException(exception);
            }
            finally
            {
                if (stream != null)
                {
                    stream.Close();
                    stream.Dispose();
                }
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