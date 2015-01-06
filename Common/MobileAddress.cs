using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Serialization;
using log4net.Util;
using Newtonsoft.Json;

namespace Common
{
    public class MobileAddress
    {
        public static AddressInfo GetMobileAddress(string telPhone)
        {
            try
            {
                string Url = "http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile=" + telPhone;
                HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(Url);
                myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
                myHttpWebRequest.Method = "get";
                myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
                HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
                Stream myResponseStream = myHttpWebResponse.GetResponseStream();
                if (myResponseStream != null)
                {

                    XmlSerializer serializer = new XmlSerializer(typeof(AddressInfo));
                    var address = (AddressInfo)serializer.Deserialize(myResponseStream);
                    return address;
                }
            }
            catch
            {
                return null;
            }
            return null;
        }
        [XmlRoot("root")]
        [Serializable]
        public class AddressInfo
        {
            [XmlElement]
            public string ENV_CgiName { get; set; }
            [XmlElement]
            public string ENV_ClientAgent { get; set; }
            [XmlElement]
            public string ENV_ClientIp { get; set; }
            [XmlElement]
            public string ENV_QueryString { get; set; }
            [XmlElement]
            public string ENV_RequestMethod { get; set; }
            [XmlElement]
            public string ENV_referer { get; set; }
            [XmlElement]
            public string chgmobile { get; set; }
            [XmlElement]
            public string city { get; set; }
            [XmlElement]
            public string province { get; set; }
            [XmlElement]
            public string retcode { get; set; }
            [XmlElement]
            public string retmsg { get; set; }
            [XmlElement]
            public string supplier { get; set; }
            [XmlElement]
            public string tid { get; set; }
        }
    }
}
