using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// getCity_service 的摘要说明
    /// </summary>
    public class getCity_service : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string carUseWayID = context.Request["useway"];
            string provinceID = context.Request["province"];
            string cityID = context.Request["city"];
            string countryID = context.Request["country"];
            List<BLL.BLLExpand.CityFullBLL> citys = new List<BLL.BLLExpand.CityFullBLL>();
            List<Model.RentCar> rentcars = new List<Model.RentCar>();
            List<BLL.BLLExpand.CarFullType> fullRentCars = new List<BLL.BLLExpand.CarFullType>();
            if (!string.IsNullOrEmpty(carUseWayID))
            {
                if (!string.IsNullOrEmpty(provinceID))
                {
                    if (!string.IsNullOrEmpty(cityID))
                    {
                        if (!string.IsNullOrEmpty(countryID))
                        {
                            rentcars = new BLL.RentCarBLL().GetList().Where(s => s.carusewayID == int.Parse(carUseWayID) && s.provenceId == int.Parse(provinceID) && s.cityID.Trim() == cityID.Trim() && s.countyId == int.Parse(countryID)).ToList();
                            goto SerializeRentCar;
                        }
                        rentcars = new BLL.RentCarBLL().GetList().Where(s => s.carusewayID == int.Parse(carUseWayID) && s.provenceId == int.Parse(provinceID) && s.cityID.Trim() == cityID.Trim()).ToList();
                        rentcars = RemoveRepeat("country", rentcars);
                        goto SerializeCitys;
                    }
                    rentcars = new BLL.RentCarBLL().GetList().Where(s => s.carusewayID == int.Parse(carUseWayID) && s.provenceId == int.Parse(provinceID)).ToList();
                    rentcars = RemoveRepeat("city", rentcars);
                    goto SerializeCitys;
                }
                rentcars = new BLL.RentCarBLL().GetList().Where(s => s.carusewayID == int.Parse(carUseWayID)).ToList();
               
                rentcars = RemoveRepeat("province", rentcars);
                goto SerializeCitys;
            }
        SerializeCitys:
            {
                foreach (var item in rentcars)
                {
                    citys.Add(new BLL.BLLExpand.CityFullBLL(item.countyId));
                }
                context.Response.Write(JsonConvert.SerializeObject(citys));
                return;
            }
        SerializeRentCar:
            {
                foreach (var item in rentcars)
                {
                    fullRentCars.Add(new BLL.BLLExpand.CarFullType(item));
                }
                context.Response.Write(JsonConvert.SerializeObject(fullRentCars));
                return;
            }
        }
        public List<Model.RentCar> RemoveRepeat(string type,List<Model.RentCar> datas)
        {
            var codeIDList = new List<string>();
            var results = new List<Model.RentCar>();
            if (type=="province")
            {
                foreach (var item in datas)
                {
                    codeIDList.Add(item.provenceId.ToString().Trim());
                }
                codeIDList = (from c in codeIDList group c by c into g select g.Key).ToList();
                foreach (var item in codeIDList)
                {
                    results.Add(datas.Where(s=>s.provenceId==int.Parse(item)).FirstOrDefault());
                }
                return results;
            }
            if (type == "city")
            {
                foreach (var item in datas)
                {
                    codeIDList.Add(item.cityID.ToString().Trim());
                }
                codeIDList = (from c in codeIDList group c by c into g select g.Key).ToList();
                foreach (var item in codeIDList)
                {
                    results.Add(datas.Where(s => s.cityID.Trim() == item).FirstOrDefault());
                }
                return results;
            }
            if (type=="country")
            {
                  foreach (var item in datas)
                {
                    codeIDList.Add(item.countyId.ToString().Trim());
                }
                codeIDList = (from c in codeIDList group c by c into g select g.Key).ToList();
                foreach (var item in codeIDList)
                {
                    results.Add(datas.Where(s => s.countyId ==int.Parse(item)).FirstOrDefault());
                }
                return results;
            }
            else
            {
                return null;
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