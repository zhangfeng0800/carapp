using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using Newtonsoft.Json;

namespace Common
{
    public class BaiduAPI
    {
        public static string GetDistanceByPosition(string startCityName, string startPosition, string arriveCityName, string arricePostion)
        {
            string result = "";
            string Url = "http://api.map.baidu.com/direction/v1?mode=driving&origin=" + startPosition + "&destination=" + arricePostion + "&origin_region=" + startCityName + "&destination_region=" + arriveCityName + "&output=json&ak=kYvztiBTS4EKotMmUMyLt0dy";
            HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(Url);
            myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
            myHttpWebRequest.Method = "get";
            myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
            Stream myResponseStream = myHttpWebResponse.GetResponseStream();
            StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
            result = myStreamReader.ReadToEnd();
            myStreamReader.Close();
            myResponseStream.Close();
            return result;
        }
        public static string GetPlaceByLng(string lng, string lat, string formattter)
        {
            string result = "";
            string url = "http://api.map.baidu.com/geocoder/v2/?ak=kYvztiBTS4EKotMmUMyLt0dy&location=" + lat + "," + lng + "&output=" + formattter + "&pois=0";
            var request = (HttpWebRequest)WebRequest.Create(url);
            var myHttpWebResponse = (HttpWebResponse)request.GetResponse();
            Stream myResponseStream = myHttpWebResponse.GetResponseStream();
            if (myResponseStream != null)
            {
                var myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
                result = myStreamReader.ReadToEnd();
                myStreamReader.Close();
                myResponseStream.Close();
            }
            return result;
        }

        public static string GetLngByPlace(string address, string city)
        {
            string result = "";
            string url = "http://api.map.baidu.com/geocoder/v2/?ak=kYvztiBTS4EKotMmUMyLt0dy&output=json&address=" + address + "&city=" + city;
            var request = (HttpWebRequest)WebRequest.Create(url);
            var myHttpWebResponse = (HttpWebResponse)request.GetResponse();
            Stream myResponseStream = myHttpWebResponse.GetResponseStream();
            if (myResponseStream != null)
            {
                var myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
                result = myStreamReader.ReadToEnd();
                myStreamReader.Close();
                myResponseStream.Close();
            }
            return result;
        }

        public static ResponseResult GetPlaceByLng(string lng, string lat)
        {
            return JsonConvert.DeserializeObject<ResponseResult>(GetPlaceByLng(lng, lat, "json"));

        }
    }


}
