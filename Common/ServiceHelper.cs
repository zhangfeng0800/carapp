using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Configuration;
using Newtonsoft.Json;

namespace Common
{
    public class ServiceHelper
    {

        public static string GetServiceResponse(string url, Dictionary<string, string> parameters)
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
                throw exception;
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

        /// <summary>
        /// 发送短信
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public static bool SendSms(string receiver, string smsType, Dictionary<string, string> parameters)
        {
            string url = WebConfigurationManager.AppSettings["SMSUrl"];
            Stream stream = new MemoryStream();
            string mess = "false";
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(url + "?receiver=" + receiver + "&smsType=" + smsType + "&paramsDic=" + JsonConvert.SerializeObject(parameters));
                WebResponse response = request.GetResponse();
                stream = response.GetResponseStream();
                if (stream != null)
                {
                    var reader = new StreamReader(stream);
                    mess = reader.ReadToEnd();
                }
            }
            catch (Exception exception)
            {
                 //暂时不做处理，及时发布出去短信也不影响下面的代码
            }
            finally
            {
                if (stream != null)
                {
                    stream.Close();
                    stream.Dispose();
                }
            }
            return mess == "" ? true : false;


        }

    }
}
