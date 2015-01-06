using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.IO;
using System.Text;
using Newtonsoft.Json;
using System.Threading;
using System.Web.SessionState;
namespace WebApp.api
{
    /// <summary>
    /// predictPrice 的摘要说明
    /// </summary>
    public class predictPrice : IHttpHandler, IReadOnlySessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            var processStartTime = DateTime.Now;
            TimeSpan processTotalTime = new TimeSpan();
            TimeSpan baiduApiTime = new TimeSpan();
            context.Response.ContentType = "application/json";
            try
            {
                Model.Orders order = new BLL.OrderBLL().GetModel(context.Request["orderid"]);
                Model.RentCar rentCar = new BLL.RentCarBLL().GetModel(order.rentCarID);
                string startcityid = order.departureCityID;
                string overcityid = order.targetCityID;
                if (rentCar.carusewayID==6)
                {
                    Model.hotLine hotline =new BLL.HotLineBLL().GetModel(int.Parse(order.targetCityID));
                    overcityid = hotline.countyId;
                }
                string startPostion = order.mapPoint;
                string overPosition = order.EndPosition;
                startPostion = changePosition(startPostion);
                overPosition = changePosition(overPosition);
                BLL.CityBLL citybll = new BLL.CityBLL();
                string startCity =citybll.GetModule(citybll.GetModule(startcityid).ParentId).CityName;
                string overCity = citybll.GetModule(citybll.GetModule(overcityid).ParentId).CityName;
                string outdata = "";
                var baiduapiStartTime = DateTime.Now;
                string Url = "http://api.map.baidu.com/direction/v1?mode=driving&origin=" + startPostion + "&destination=" + overPosition + "&origin_region=" + startCity + "&destination_region=" + overCity + "&output=json&ak=kYvztiBTS4EKotMmUMyLt0dy";
                HttpWebRequest myHttpWebRequest = (HttpWebRequest)WebRequest.Create(Url);
                myHttpWebRequest.ContentType = "application/x-www-form-urlencoded";
                myHttpWebRequest.Method = "get";
                myHttpWebRequest.Timeout = 5000;
                myHttpWebRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; Q312461; .NET CLR 1.0.3705)";
                HttpWebResponse myHttpWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
                Stream myResponseStream = myHttpWebResponse.GetResponseStream();
                StreamReader myStreamReader = new StreamReader(myResponseStream, Encoding.GetEncoding("utf-8"));
                outdata = myStreamReader.ReadToEnd();
                myStreamReader.Close();
                myResponseStream.Close();
                baiduApiTime = DateTime.Now.Subtract(baiduapiStartTime);
                dynamic result = JsonConvert.DeserializeObject(outdata);
                decimal km = decimal.Parse(result.result.taxi.distance.ToString()) / 1000;
                decimal hour = decimal.Parse(result.result.taxi.duration.ToString()) / 3600;
                decimal overKm = 0;
                decimal overHour = 0;
                decimal perKm = 0;
                decimal perHour = 0;
                decimal startPrice = 0;
                string totalMoney = comParePredicePrice(km, hour, order.rentCarID,order.orderMoney, out overKm, out overHour, out perKm, out perHour, out startPrice);
                processTotalTime = DateTime.Now.Subtract(processStartTime);
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    result = totalMoney,
                    km = Math.Round(km, 2),
                    hour = Math.Round(hour * 60, 0),
                    overkm = Math.Round(overKm, 2),
                    overhour = Math.Round(overHour, 2),
                    perkm = perKm,
                    perhour = perHour,
                    startprice = startPrice,
                    apiuseTime=baiduApiTime,
                    processTime=processTotalTime
                }
                ));
            }
            catch (Exception)
            {
                Model.Orders order = new BLL.OrderBLL().GetModel(context.Request["orderid"]);
                decimal km = 0;
                decimal hour = 0;
                decimal overKm = 0;
                decimal overHour = 0;
                decimal perKm = 0;
                decimal perHour = 0;
                decimal startPrice = 0;
                string totalMoney = comParePredicePrice(km, hour, order.rentCarID,order.orderMoney, out overKm, out overHour, out perKm, out perHour, out startPrice);
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    result = totalMoney,
                    startprice = totalMoney,
                    km = km,
                    hour = hour,
                    overkm = overKm,
                    overhour = overHour,
                    perkm = perKm,
                    perhour = perHour,
                }));
            }
        }
        public string changePosition(string positon)
        {
            string[] result1 = { "0", "0" };
            if (positon.Contains(","))
            {
                result1 = positon.Split(',');
            }
            string result = result1[1] + "," + result1[0];
            return result;
        }
        public string comParePredicePrice(decimal km, decimal hour, int rentCarID,decimal ordermonry, out decimal overKm, out decimal overMinutes, out decimal perkm, out decimal perhour, out decimal startPrice)
        {
            decimal totalMinutes = hour * 60;
            decimal totalKm = km;
            Model.RentCar rentcar = new BLL.RentCarBLL().GetModel(rentCarID);
            overMinutes = (totalMinutes - rentcar.includeHour) < 0 ? 0 : (totalMinutes - rentcar.includeHour);
            decimal overMinutesMoney = overMinutes * rentcar.hourPrice;
            overKm = ((totalKm - rentcar.includeKm) < 0 ? 0 : (totalKm - rentcar.includeKm));
            decimal overKmMoney = overKm * rentcar.kiloPrice;
            decimal totalMoney = overKmMoney + overMinutesMoney + ordermonry;
            perkm = rentcar.kiloPrice;
            perhour = rentcar.hourPrice;
            startPrice = rentcar.DiscountPrice;
            return Math.Round(totalMoney, 2).ToString();
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