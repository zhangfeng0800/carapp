using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Common
{

    public class BaiduDistance
    {
        public int status { get; set; }
        public string message { get; set; }
        public int type { get; set; }
        public object info { get; set; }
        public object result { get; set; }
    }

    public class Route
    {
        public int distance { get; set; }
        public int duration { get; set; }
        public object steps { get; set; }
        public object originLocation { get; set; }
        public object destinationLocation { get; set; }
    }

    public class BaiduResult
    {
        public object routes { get; set; }
        public object origin { get; set; }
        public object destination { get; set; }
        public object taxi { get; set; }
    }

    #region 经纬度获取地理位置

    public class Location
    {
        /// <summary>
        /// 精度
        /// </summary>
        public string lng { get; set; }
        /// <summary>
        /// 纬度
        /// </summary>
        public string lat { get; set; }
    }

    public class AddressComponent
    {
        public string city { get; set; }
        public string district { get; set; }
        public string province { get; set; }
        public string street { get; set; }
        public string street_number { get; set; }

    }

    public class LocationResult
    {
        public Location location { get; set; }
        public string formatted_address { get; set; }
        public string Business { get; set; }
        public AddressComponent addressComponent { get; set; }
        public string cityCode { get; set; }
    }

    public class ResponseResult
    {
        public string status { get; set; }
        public LocationResult result { get; set; }
    }

    #endregion
    #region 地理位置获取经纬度

    public class GeoLocationLngLat
    {
        public string status { get; set; }
        public GeoLocationLngLatResult result { get; set; }
    }

    public class GeoLocationLngLatResult
    {
        public Location location { get; set; }
        public string precise { get; set; }
        public string confidence { get; set; }
        public string level { get; set; }
    }
    #endregion

    #region 百度驾车—起/终点模糊检索返回值说明

    public class PlaceInfo
    {
        public object originInfo { get; set; }
        public object destinationInfo { get; set; }
        public object origin { get; set; }
        public object destination { get; set; }
    }

    public class DestinationPlaceInfo
    {
        public string cityName { get; set; }
        public object content { get; set; }
    }

    public class ContentInfo
    {
        public string name { get; set; }
        public string address { get; set; }
        public string uid { get; set; }
        public string telephone { get; set; }
        public object location { get; set; }
    }
    #endregion

    #region 计算直线距离
    public class CalculatorDistance
    {
        public static double GetDistance(double startLat, double startLng, double endLat, double endLng)
        {
            double radLat1 = rad(startLat);
            double radLat2 = rad(endLat);
            double a = radLat1 - radLat2;
            double b = rad(startLng) - rad(endLng);

            double s = 2 * Math.Asin(Math.Sqrt(Math.Pow(Math.Sin(a / 2), 2) +
             Math.Cos(radLat1) * Math.Cos(radLat2) * Math.Pow(Math.Sin(b / 2), 2)));
            s = s * EARTH_RADIUS;
            s = Math.Round(s * 10000) / 10000;
            return s;
        }
        private const double EARTH_RADIUS = 6378.137;//地球半径
        private static double rad(double d)
        {
            return d * Math.PI / 180.0;
        }
    }
    #endregion
}
