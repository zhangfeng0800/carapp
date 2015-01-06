using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// RentCarHandler 的摘要说明
    /// </summary>
    public class RentCarHandler : IHttpHandler
    {
        private readonly RentCarBLL _rentCarBll = new RentCarBLL();
        private readonly HotLineBLL _hotLineBll = new HotLineBLL();
        private readonly CarBrandBLL _carBrandBll = new CarBrandBLL();
        private readonly CarUseWayBLL _carUseWayBll = new CarUseWayBLL();
        public void ProcessRequest(HttpContext context)
        {

            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    context.Response.ContentType = "text/plain";
                    Add(context);
                    break;
                case "edit":
                    context.Response.ContentType = "text/plain";
                    Edit(context);
                    break;
                case "list":
                    context.Response.ContentType = "text/plain";
                    List(context);
                    break;
                case "caruseway":
                    context.Response.ContentType = "text/plain";
                    GetCarUseWay(context);
                    break;
                case "hotline":
                    context.Response.ContentType = "text/plain";
                    GetHotLine(context);
                    break;
                case "carbrand":
                    context.Response.ContentType = "text/plain";
                    GetCarBrand(context);
                    break;
                case "delete":
                    context.Response.ContentType = "text/plain";
                    Delete(context);
                    break;
                case "editpause":
                    context.Response.ContentType = "text/plain";
                    Editpause(context);
                    break;
                case "predict":
                    context.Response.ContentType = "application/json";
                    PredictMoney(context);
                    break;
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
        public void PredictMoney(HttpContext context)
        {
            var id = context.Request["id"];
            var data = (new OrderBLL()).GetOrderPositionInfo(id);
            try
            {
                string startPostion = data.Rows[0]["mapPoint"].ToString();
                string overPosition = data.Rows[0]["EndPosition"].ToString();
                startPostion = changePosition(startPostion);
                overPosition = changePosition(overPosition);
                var citybll = new CityBLL();

                string startCity = data.Rows[0]["startcity"].ToString();
                string overCity = data.Rows[0]["overcity"].ToString();

                string outdata = "";
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
                dynamic result = JsonConvert.DeserializeObject(outdata);
                decimal km = decimal.Parse(result.result.taxi.distance.ToString()) / 1000;
                decimal hour = decimal.Parse(result.result.taxi.duration.ToString()) / 3600;
                decimal overKm = 0.00M;
                decimal overHour = 0.00M;
                decimal perKm = 0.00M;
                decimal perHour = 0.00M;
                decimal startPrice = 0.00M;
                string totalMoney = comParePredicePrice(km, hour, int.Parse(data.Rows[0]["rentCarID"].ToString()), Convert.ToDecimal(data.Rows[0]["orderMoney"].ToString()), out overKm, out overHour, out perKm, out perHour, out startPrice);
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    result = totalMoney,
                    feeIncludes = data.Rows[0]["feeIncludes"].ToString(),
                    km = Math.Round(km, 2),
                    hour = Math.Round(hour * 60, 0),
                    overkm = Math.Round(overKm, 2),
                    overhour = Math.Round(overHour, 2),
                    perkm = perKm,
                    perhour = perHour,
                    startprice = startPrice
                }
                ));
            }
            catch (Exception)
            {


                decimal km = 0;
                decimal hour = 0;
                decimal overKm = 0;
                decimal overHour = 0;
                decimal perKm = 0;
                decimal perHour = 0;
                decimal startPrice = 0;
                string totalMoney = comParePredicePrice(km, hour, int.Parse(data.Rows[0]["rentCarID"].ToString()), Convert.ToDecimal(data.Rows[0]["orderMoney"].ToString()), out overKm, out overHour, out perKm, out perHour, out startPrice);
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    result = totalMoney,
                    feeIncludes = "",
                    km = km,
                    hour = hour,
                    overkm = overKm,
                    overhour = overHour,
                    perkm = perKm,
                    perhour = perHour,
                    startprice = startPrice
                }));
            }
        }
        public string comParePredicePrice(decimal km, decimal hour, int rentCarID, decimal orderMoney, out decimal overKm, out decimal overMinutes, out decimal perkm, out decimal perhour, out decimal startPrice)
        {
            decimal totalMinutes = hour * 60;
            decimal totalKm = km;
            Model.RentCar rentcar = new BLL.RentCarBLL().GetModel(rentCarID);
            overMinutes = (totalMinutes - rentcar.includeHour) < 0 ? 0 : (totalMinutes - rentcar.includeHour);
            decimal overMinutesMoney = overMinutes * rentcar.hourPrice;
            overKm = ((totalKm - rentcar.includeKm) < 0 ? 0 : (totalKm - rentcar.includeKm));
            decimal overKmMoney = overKm * rentcar.kiloPrice;
            decimal totalMoney = overKmMoney + overMinutesMoney + orderMoney;
            perkm = rentcar.kiloPrice;
            perhour = rentcar.hourPrice;
            startPrice = rentcar.DiscountPrice;
            return Math.Round(totalMoney, 2).ToString();
        }
        private void Editpause(HttpContext context)
        {
            int id = Convert.ToInt32(context.Request["id"]);
            Model.RentCar rentcar = new BLL.RentCarBLL().GetModel(id);
            if (rentcar.IsDelete == 0)
                rentcar.IsDelete = 2;
            else
            {
                rentcar.IsDelete = 0;
            }
            new BLL.RentCarBLL().UpdateRentCar(rentcar);
            context.Response.Write("success");
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string idStr = context.Request["id"];
            int id;
            if (!int.TryParse(idStr, out id))
            {
                message.IsSuccess = false;
                message.Message = "参数无效";
                LogHelper.WriteOperation("参数无效", OperationType.Query, "参数错误", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = _rentCarBll.GetModel(id);
                if (model == null)
                {
                    message.IsSuccess = false;
                    message.Message = "数据错误";
                    LogHelper.WriteOperation("查询rentcar指定编号[" + id + "]", OperationType.Query, "指定编号的记录不存在", HttpContext.Current.User.Identity.Name);
                }
                else if (model.IsDelete == 1)
                {
                    message.IsSuccess = false;
                    message.Message = "此数据已经是删除状态，不允许重复删除";
                    LogHelper.WriteOperation("查询rentcar指定编号[" + id + "]", OperationType.Query, "此数据已经是删除状态，不允许重复删除", HttpContext.Current.User.Identity.Name);
                }
                else
                {
                    try
                    {
                        _rentCarBll.VirtualDelete("id=" + id);
                        message.IsSuccess = true;
                        message.Message = "";
                        LogHelper.WriteOperation("删除rentcar指定编号[" + id + "]", OperationType.Query, "删除成功", HttpContext.Current.User.Identity.Name);
                    }
                    catch (Exception exception)
                    {
                        message.IsSuccess = false;
                        LogHelper.WriteException(exception);
                    }

                }
            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string provenceId = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string carusewayId = context.Request["carusewayID"];
            string hotLineId = context.Request["hotLineID"];
            string carTypeId = context.Request["carTypeID"];
            string startPrice = context.Request["startPrice"];
            string feeIncludes = context.Request["feeIncludes"];
            string kiloPrice = context.Request["kiloPrice"];
            string hourPrice = context.Request["hourPrice"];
            string carbrand = context.Request["carbrand"];
            string includeKmStr = context.Request["includeKm"];
            string includeHourStr = string.IsNullOrEmpty(context.Request["includeHour"]) ? "0" : context.Request["includeHour"];
            int isoneway = Convert.ToInt32(context.Request["isoneway"]);
            string DiscountPrice = context.Request["DiscountPrice"];
            string includeMStr = context.Request["includeM"];
            string others = context.Request["others"].Trim();
            decimal includeKm;
            decimal includeHour;
            decimal includeM;

            if (string.IsNullOrEmpty(carbrand))
            {
                message.IsSuccess = false;
                message.Message = "必须选择车辆品牌";
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }

            bool isSuccess = decimal.TryParse(includeKmStr, out includeKm);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "包含公里类型错误";
                LogHelper.WriteOperation("添加租车信息", OperationType.Add, "包含公里类型错误", HttpContext.Current.User.Identity.Name);
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }

            isSuccess = decimal.TryParse(includeHourStr, out includeHour);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "包含小时数据类型错误";
                LogHelper.WriteOperation("添加租车信息", OperationType.Add, "包含小时数据类型错误", HttpContext.Current.User.Identity.Name);
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }

            isSuccess = decimal.TryParse(includeMStr, out includeM);
            if (!isSuccess)
            {
                includeM = 0;
            }
            var model = new Model.RentCar()
            {
                cityID = cityId,
                carusewayID = Convert.ToInt32(carusewayId),
                carTypeID = Convert.ToInt32(carTypeId),
                startPrice = Convert.ToDecimal(startPrice),
                kiloPrice = Convert.ToDecimal(kiloPrice),
                hourPrice = Convert.ToDecimal(hourPrice),
                includeHour = includeHour * 60 + includeM,
                includeKm = includeKm,
                IsOneWay = isoneway,
                IsDelete = 0,
                provenceId = Convert.ToInt32(provenceId),
                countyId = Convert.ToInt32(countyId),
                DiscountPrice = Convert.ToDecimal(DiscountPrice),
                Others = "",
                RemarkId = int.Parse(others)
            };

            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}公里", includeKm);
            }
            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}小时", includeHour);
            }
            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}分钟", includeM);
            }

            if (string.IsNullOrEmpty(model.feeIncludes))
            {
                model.feeIncludes = "暂无套餐";
            }
            else
            {
                model.feeIncludes = "含" + model.feeIncludes;
            }

            if (!string.IsNullOrEmpty(hotLineId))
            {
                model.hotLineID = Convert.ToInt32(hotLineId);
            }
            try
            {
                _rentCarBll.InsertRentCar(model);
                if (!string.IsNullOrEmpty(carbrand))
                {
                    string[] carBrandArray = carbrand.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var s in carBrandArray)
                    {
                        _rentCarBll.InsertLinkRentcarBrand(_rentCarBll.GetMaxId(), s);//todo:  循环访问数据库
                    }
                }
                message.IsSuccess = true;
                message.Message = "";
                LogHelper.WriteOperation("添加租车信息，记录数据[城市编号：" + cityId + "；用车方式编号：" + carusewayId + "；车辆类型编号：" + carTypeId + "；热门路线编号：" + hotLineId + "；起步价：" + startPrice + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                LogHelper.WriteException(exception);
            }

            //}
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            int id = Convert.ToInt32(context.Request["id"]);
            string provenceId = context.Request["provenceID"];
            string cityId = context.Request["cityId1"];
            string countyId = context.Request["cityId"];
            string carusewayId = context.Request["carusewayID"];
            string hotLineId = context.Request["hotLineID"];
            string carTypeId = context.Request["carTypeID"];
            string startPrice = context.Request["startPrice"];
            string feeIncludes = context.Request["feeIncludes"];
            string kiloPrice = context.Request["kiloPrice"];
            string hourPrice = context.Request["hourPrice"];
            string carbrand = context.Request["carbrand"];
            string includeKmStr = context.Request["includeKm"];
            string includeHourStr = string.IsNullOrEmpty(context.Request["includeHour"]) ? "0" : context.Request["includeHour"];
            int isoneway = Convert.ToInt32(context.Request["isoneway"]);
            string DiscountPrice = context.Request["DiscountPrice"];
            string includeMStr = context.Request["includeM"];
            string others = context.Request["others"].Trim();
            decimal includeKm;
            decimal includeHour;
            decimal includeM;


            if (string.IsNullOrEmpty(carbrand))
            {
                message.IsSuccess = false;
                message.Message = "必须选择车辆品牌";
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }

            bool isSuccess = decimal.TryParse(includeKmStr, out includeKm);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "包含公里类型错误";
                context.Response.Write(JsonConvert.SerializeObject(message));
                LogHelper.WriteOperation("编辑租车信息，编号为[" + id + "]", OperationType.Update, "包含公里类型错误", HttpContext.Current.User.Identity.Name);
                return;
            }

            isSuccess = decimal.TryParse(includeHourStr, out includeHour);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "包含小时数据类型错误";
                context.Response.Write(JsonConvert.SerializeObject(message));
                LogHelper.WriteOperation("编辑租车信息，编号为[" + id + "]", OperationType.Update, "包含小时数据类型错误", HttpContext.Current.User.Identity.Name);
                return;
            }

            isSuccess = decimal.TryParse(includeMStr, out includeM);
            if (!isSuccess)
            {
                includeM = 0;
            }
            var model = new Model.RentCar()
            {
                id = id,
                cityID = cityId,
                carusewayID = Convert.ToInt32(carusewayId),
                carTypeID = Convert.ToInt32(carTypeId),
                startPrice = Convert.ToDecimal(startPrice),
                kiloPrice = Convert.ToDecimal(kiloPrice),
                hourPrice = Convert.ToDecimal(hourPrice),
                includeHour = includeHour * 60 + includeM,
                includeKm = includeKm,
                IsOneWay = isoneway,
                IsDelete = 0,
                provenceId = Convert.ToInt32(provenceId),
                countyId = Convert.ToInt32(countyId),
                DiscountPrice = Convert.ToDecimal(DiscountPrice),
                Others = "",
                RemarkId = int.Parse(others)
            };

            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}公里", includeKm);
            }
            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}小时", includeHour);
            }
            if (includeKm > 0)
            {
                model.feeIncludes += string.Format("{0}分钟", includeM);
            }

            if (string.IsNullOrEmpty(model.feeIncludes))
            {
                model.feeIncludes = "暂无套餐";
            }
            else
            {
                model.feeIncludes = "含" + model.feeIncludes;
            }

            if (!string.IsNullOrEmpty(hotLineId))
            {
                model.hotLineID = Convert.ToInt32(hotLineId);
            }
            try
            {
                _rentCarBll.DeleteCarBrand(id);
                LogHelper.WriteOperation("删除了指定租车编号[" + id + "]的汽车品牌数据", OperationType.Delete, "删除成功", HttpContext.Current.User.Identity.Name);
                _rentCarBll.UpdateRentCar(model);
                LogHelper.WriteOperation("更新了指定租车编号[" + id + "]的记录", OperationType.Update, "更新成功", HttpContext.Current.User.Identity.Name);
                if (!string.IsNullOrEmpty(carbrand))
                {
                    string[] carBrandArray = carbrand.Split(new string[] { "," },
                        StringSplitOptions.RemoveEmptyEntries);
                    foreach (var s in carBrandArray)
                    {
                        _rentCarBll.InsertLinkRentcarBrand(id, s); //todo:  循环访问数据库
                        LogHelper.WriteOperation("添加指定租车编号[" + id + "]的汽车品牌数据，编号为[" + s + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                    }
                }

                message.IsSuccess = true;
                message.Message = "";
            }
            catch (Exception ex)
            {
                message.IsSuccess = false;
                LogHelper.WriteException(ex);
            }
            //}
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string provenceId = string.IsNullOrEmpty(context.Request["provenceID"]) ? "" : context.Request["provenceID"];
            string cityId = string.IsNullOrEmpty(context.Request["cityId"]) ? "" : context.Request["cityId"];
            string areaId = string.IsNullOrEmpty(context.Request["areaId"]) ? "" : context.Request["areaId"];
            string sIsDelete = context.Request["sIsDelete"];

            string caruseway = context.Request["caruseway"];
            string cartype = context.Request["cartype"];


            DataTable dtData = new BLL.RentCarBLL().GetRentCarsByPro(provenceId, cityId, areaId, string.IsNullOrEmpty(caruseway) ? 0 : Int32.Parse(caruseway),
                string.IsNullOrEmpty(cartype) ? 0 : Int32.Parse(cartype), string.IsNullOrEmpty(sIsDelete) ? -1 : Int32.Parse(sIsDelete), pageSize, pageIndex, out count);

            DataTable mylist = dtData.Clone();
            int index = 0;
            int lastnum = 0;
            foreach (DataRow row in dtData.Rows)
            {
                int rownum = Convert.ToInt32(row["rownum"]);
                if (lastnum == rownum)
                {
                    mylist.Rows[mylist.Rows.Count - 1]["brandName"] += (" " + row["brandName"]);
                }
                else
                {
                    DataRow myrow = mylist.NewRow();
                    myrow.ItemArray = dtData.Rows[index].ItemArray;
                    mylist.Rows.Add(myrow);
                }
                lastnum = rownum;
                index += 1;
            }


            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = mylist }));
        }

        private void GetCarUseWay(HttpContext context)
        {
            var list = _carUseWayBll.GetAllCarUseWay();
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void GetHotLine(HttpContext context)
        {
            var list = _hotLineBll.GetAllHotLine();
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void GetCarBrand(HttpContext context)
        {
            var list = _carBrandBll.GetAllCarBrand();
            context.Response.Write(JsonConvert.SerializeObject(list));
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