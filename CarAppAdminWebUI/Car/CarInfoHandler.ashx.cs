using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BLL;
using CarAppAdminWebUI.Ajax;
using CarAppAdminWebUI.ProvinceCity;
using Common;
using IEZU.Log;
using Model.Ext;
using Newtonsoft.Json;
using NPOI.SS.Formula.Functions;
using Model;

namespace CarAppAdminWebUI.Car
{
    /// <summary>
    /// CarInfoHandler 的摘要说明
    /// </summary>
    public class CarInfoHandler : IHttpHandler
    {
        private readonly CarInfoBLL _carInfoBll = new CarInfoBLL();
        private readonly OrderBLL _orderBll = new OrderBLL();
        private readonly ServiceCityBLL _serviceCityBll = new ServiceCityBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            string action = context.Request["action"];
            switch (action)
            {
                case "add":
                    Add(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "list":
                    GetCarList(context);  
                    break;
                case "combolist":
                    ComboList(context);
                    break;
                case "delete":
                    Delete(context);
                    break;
                case "servicecitylist":
                    ServiceCityList(context);
                    break;
                case "carorderlist":
                    CarOrderList(context);
                    break;
                case "hotlinelist":
                    GetHotlineList(context);
                    break;
                case "kmmoney":  //查看车辆的公里数和订单金额
                    GetCarKmMoneyById(context);
                    break;
                case "aboutOrder": //租用次数查看相关订单
                    GetAlboutOrders(context);
                    break;
                case "carBrandChat":
                    context.Response.ContentType = "application/json";
                    context.Response.Write(JsonConvert.SerializeObject(new BLL.CarInfoBLL().GetBrandChat()));
                    break;
                case "gps":
                    try
                    {
                        var result = GPSOperation.ExportGpsData();
                        context.Response.Write(result > 0 ? "1" : "0");
                        return;
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                        context.Response.Write("0");
                    }
                    break;
                case "carno":

                    context.Response.ContentType = "application/json";
                    GetCarNo(context);
                    break;
            }
        }

        public void GetCarNo(HttpContext context)
        {
            var carno = context.Request["term"] ?? "";
            var carnolist = (from m in (_carInfoBll.GetCarNo(carno)).AsEnumerable() select m["carno"].ToString()).ToList();
            context.Response.Write(JsonConvert.SerializeObject(carnolist));
        }
        private void CarOrderList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string id = context.Request["id"];
            string where = "carId=" + id;
            // var list = _orderBll.GetPageList(pageIndex, pageSize, where, out count);
            var list = _orderBll.GetPageListByPro(Int32.Parse(id), 0, "", 0, pageSize, pageIndex, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void ServiceCityList(HttpContext context)
        {
            int count = 0;
            string pid = context.Request["pid"];
            string where = "carusewayID=6 and isDelete=0";
            if (!string.IsNullOrEmpty(pid))
            {
                where += " and countyId=" + pid;
            }

            var list = _serviceCityBll.GetList(where);
            context.Response.Write(JsonConvert.SerializeObject(list));
        }

        private void Delete(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            try
            {
                _carInfoBll.DeleteData(id);
                LogHelper.WriteOperation("删除编号为[" + id + "]车辆", OperationType.Delete, "删除成功", HttpContext.Current.User.Identity.Name);
                message.IsSuccess = true;
                message.Message = "";
            }
            catch (Exception exception)
            {
                message.IsSuccess = false;
                LogHelper.WriteException(exception);
            }

            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void ComboList(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string type = context.Request["type"];
            string cartype = context.Request["cartype"];
            string carstatus = context.Request["carstatus"];
            string where = "1=1";
            where += " and carworkstatus!=7 ";
            if (!string.IsNullOrEmpty(type))
            {
                where += " and CarUseWay='" + type + "'";
            }
            if (!string.IsNullOrEmpty(carstatus))
            {
                where += " and carWorkStatus='" + carstatus + "'";
            }
            if (!string.IsNullOrEmpty(cartype))
            {
                where += " and carTypeId=" + cartype;
            }
            var list = _carInfoBll.GetList(pageIndex, pageSize, where, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }

        private void Add(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string carNo = context.Request["carNo"];
            int carTypeId = Convert.ToInt32(context.Request["carTypeId"]);
            string name = "";
            string telPhone = context.Request["telPhone"];
            string provenceID = context.Request["provenceID"];
            string cityId1 = context.Request["cityId1"];
            string cityId = context.Request["cityId"];
            string CarUseWay = context.Request["CarUseWay"];
            string hotline = context.Request["hotline"];
            string BrandId = context.Request["brandId"];

            if (_carInfoBll.IsExistCarNo(carNo))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此车牌号";
                LogHelper.WriteOperation("查询车牌号是[" + carNo + "]", OperationType.Query, "没有此车牌", HttpContext.Current.User.Identity.Name);
            }
            else if (_carInfoBll.IsExistPhone(telPhone))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此电话";
                LogHelper.WriteOperation("查询车辆电话[" + telPhone + "]", OperationType.Query, "手机号存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                var model = new Model.CarInfo()
                {
                    CarTypeId = carTypeId,
                    CarNo = carNo,
                    Name = name,
                    nowOrderId = "",
                    NowCityId = 0,
                    carWorkStatus = Model.Enume.CarWorkStatus.leave,
                    telPhone = telPhone,
                    passWord = "123",
                    ProvinceId = provenceID,
                    CityId = cityId1,
                    CountyId = cityId,
                    CarUseWay = CarUseWay,
                    DriverID = 0,
                    BrandId = Int32.Parse(BrandId)
                };

                if (string.IsNullOrEmpty(hotline))
                {
                    model.HotLine = "";
                }
                else
                {
                    if (CarUseWay == "A")
                    {
                        string[] tempArr = hotline.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                        foreach (var s in tempArr)
                        {
                            model.HotLine += s + ",";
                        }
                        if (!string.IsNullOrEmpty(model.HotLine))
                        {
                            model.HotLine = model.HotLine.Substring(0, model.HotLine.Length - 1);
                        }
                    }
                    else
                    {
                        model.HotLine = "";
                    }
                }
                try
                {
                    _carInfoBll.AddData(model);
                    LogHelper.WriteOperation("添加了车辆，车牌号[" + carNo + "]", OperationType.Add, "添加成功", HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string carNo = context.Request["carNo"];
            int carTypeId = Convert.ToInt32(context.Request["carTypeId"]);
            string id = context.Request["id"];
            string name = "";
            string telPhone = context.Request["telPhone"];
            string carWorkStatusStrintg = context.Request["carWorkStatus"];
            string carUseWay = context.Request["CarUseWay"];
            string provenceId = context.Request["provenceID"];
            string cityId1 = context.Request["cityId1"];
            string cityId = context.Request["cityId"];
            string hotline = context.Request["hotline"];
            string brandId = context.Request["BrandId"];
            int carWorkStatus;

            if (string.IsNullOrEmpty(brandId))
            {
                message.IsSuccess = false;
                message.Message = "请选择有效的车型";
            }
            else if (!int.TryParse(carWorkStatusStrintg, out carWorkStatus))
            {
                message.IsSuccess = false;
                message.Message = "状态类型无效";
                LogHelper.WriteOperation("查询车牌[" + carNo + "]的状态，状态码[" + carWorkStatusStrintg + "]", OperationType.Query, "指定的车辆状态无效", HttpContext.Current.User.Identity.Name);
            }
            else if (_carInfoBll.IsExistCarNo(id, carNo))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此车牌号";
                LogHelper.WriteOperation("查询车牌号是[" + carNo + "]", OperationType.Query, "已经存在此车牌号", HttpContext.Current.User.Identity.Name);
            }
            else if (_carInfoBll.IsExistPhone(id, telPhone))
            {
                message.IsSuccess = false;
                message.Message = "已经存在此电话";
                LogHelper.WriteOperation("查询车辆电话[" + telPhone + "]", OperationType.Query, "手机号存在", HttpContext.Current.User.Identity.Name);
            }
            else
            {
                try
                {
                    var model = new Model.CarInfo()
                    {
                        Id = int.Parse(id),
                        CarTypeId = carTypeId,
                        CarNo = carNo,
                        Name = name,
                        carWorkStatus = (Model.Enume.CarWorkStatus)carWorkStatus,
                        telPhone = telPhone,
                        ProvinceId = provenceId,
                        CityId = cityId1,
                        CountyId = cityId,
                        CarUseWay = carUseWay,
                        carWorkStatusId = carWorkStatus,

                        BrandId = Int32.Parse(brandId)
                    };

                    if (string.IsNullOrEmpty(hotline))
                    {
                        model.HotLine = "";
                    }
                    else
                    {
                        if (carUseWay == "A")
                        {
                            string[] tempArr = hotline.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                            foreach (var s in tempArr)
                            {
                                model.HotLine += s + ",";
                            }
                            if (!string.IsNullOrEmpty(model.HotLine))
                            {
                                model.HotLine = model.HotLine.Substring(0, model.HotLine.Length - 1);
                            }
                        }
                        else
                        {
                            model.HotLine = "";
                        }
                    }

                    _carInfoBll.AdminUpdateData(model);
                    LogHelper.WriteOperation("更新车辆编号[" + model.Id + "]的信息", OperationType.Update, "更新成功",
                        HttpContext.Current.User.Identity.Name);

                    message.IsSuccess = true;
                    message.Message = "";
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    message.IsSuccess = false;
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        public void GetHotlineList(HttpContext context)
        {

            if (context.Request["value"] != null)
            {
                var list = _serviceCityBll.GetList("id in (" + context.Request["value"] + ")");
                var result = new List<object>();
                foreach (var m in list)
                {
                    result.Add(new { cityName = m.cityName, hotlineName = m.HotlineName });
                }
                context.Response.Write(JsonConvert.SerializeObject(result));
            }
        }
        private void List(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string town = context.Request["town"];
            string province = context.Request["province"];
            string city = context.Request["city"];
            string carNo = context.Request["carNo"];

            string where = string.Empty;
            var name = context.Request["carname"];
            var cartypeid = context.Request["cartype"];
            var workstatus = context.Request["carstatus"];
            var nowcity = context.Request["nowcityname"];
            var telphone = context.Request["telphone"];
            var driverName = context.Request["driverName"];
            var driverState = context.Request["driverState"];
            string caruseway = context.Request["useway"];

            where += " 1=1 ";
            if (!string.IsNullOrEmpty(carNo))
            {
                where += " and ci.carNo like '%" + Common.Tool.SqlFilter(carNo) + "%'";
            }
            if (!string.IsNullOrEmpty(province))
            {
                where += " and  ci.ProvinceId = " + province + "";
            }
            if (!string.IsNullOrEmpty(city))
            {
                where += " and  ci.CityId = " + city + "";
            }
            if (!string.IsNullOrEmpty(town))
            {
                where += " and  ci.countyid = " + town + "";
            }
            if (!string.IsNullOrEmpty(name))
            {
                where += " and  brandName like '%" + Common.Tool.SqlFilter(name) + "%'";
            }
            if (!string.IsNullOrEmpty(cartypeid))
            {
                where += " and  ci.cartypeid =" + cartypeid;
            }
            if (!string.IsNullOrEmpty(workstatus))
            {
                where += " and  ci.carworkstatus =" + workstatus;
            }
            if (!string.IsNullOrEmpty(telphone))
            {
                where += " and  ci.telphone like '%" + telphone + "%'";
            }
            if (!string.IsNullOrEmpty(caruseway))
            {
                where += " and  ci.CarUseWay ='" + caruseway + "'";
            }
            if (!string.IsNullOrEmpty(driverName))
            {
                where += " and  ci.driverId IN (SELECT ID  FROM driverAccount WHERE name LIKE '%" +
                         driverName + "%')";
            }
            if (!string.IsNullOrEmpty(driverState))
            {
                if (driverState == "1")
                    where += "and  ci.driverId<>0 ";
                else
                {
                    where += "and  ci.driverId=0 ";
                }
            }

            var list = _carInfoBll.PagerList(pageIndex, pageSize, where, out count, nowcity);
            //GPSOperation.GetCarList();
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }
        #region 根据车牌号查询相关订单
        public void GetAlboutOrders(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            string carNO = context.Request["carNo"];
            string startdate = context.Request["startdate"];
            string endate = context.Request["enddate"];
            var list = _carInfoBll.GetAlboutOrdersByCarNo(carNO, startdate, endate, pageIndex, pageSize, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }
        #endregion

        #region 根据条件查询车辆信息
        private void GetCarList(HttpContext context)
        {
            CarInfo car = new CarInfo();
            int count = 0;
            string[] result = new string[3];
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            car.CountyId = context.Request["town"] == null ? "" : context.Request["town"];
            car.ProvinceId = context.Request["province"] == null ? "13" : context.Request["province"]; //默认河北 13
            car.CityId = context.Request["city"] == null ? "1301" : context.Request["city"]; //默认石家庄 1301
            car.CarNo = context.Request["carNo"] == null ? "" : context.Request["carNo"];
            car.Name = context.Request["carname"] == null ? "" : context.Request["carname"];
            car.carType = context.Request["cartype"] == null ? "" : context.Request["cartype"];
            car.carState = context.Request["carstatus"] == null ? "" : context.Request["carstatus"];
            car.telPhone = context.Request["telphone"] == null ? "" : context.Request["telphone"];
            car.driverName = context.Request["driverName"] == null ? "" : context.Request["driverName"];
            car.driverState = context.Request["driverState"] == null ? "" : context.Request["driverState"];
            car.CarUseWay = context.Request["useway"] == null ? "" : context.Request["useway"];
            car.StarDate = context.Request["startDate"] == null ? "" : context.Request["startDate"];
            car.EndDate = context.Request["endDate"] == null ? "" : context.Request["endDate"];

            car.SortName = Common.Tool.GetString(context.Request["sort"]) == "" ? "totalKm" : Common.Tool.GetString(context.Request["sort"]);  //排序字段
            car.SortType = Common.Tool.GetString(context.Request["order"]) == "" ? "desc" : Common.Tool.GetString(context.Request["order"]);    //排序方式

            var list = _carInfoBll.GetCarList(pageIndex, pageSize, car, out count, ref result);
            var foot = new List<object>()
            { 
                new { telPhone = "<span style='color:red;font-size:15px;font-weight:bold'>车辆总计：</span>", 
                      brandName = count + "辆", 
                      CarType = "<span style='color:red;font-size:15px;font-weight:bold'>租车总数：</span>", 
                      CarUseName = result[0] + "次",
                      HotLines = "", 
                      vid = "",
                      drivername = "",
                      useKm = "<span>"+result[1]+"</span>",
                      moneys=result[2]
                } 
            };
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list, footer = foot }));
        }
        #endregion

        #region 根据ID查询车辆的公里数和订单金额
        /// <summary>
        /// 根据ID查询车辆的公里数和订单金额
        /// </summary>
        /// <param name="context"></param>
        private void GetCarKmMoneyById(HttpContext context)
        {
            int count = 0;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");
            int carid = int.Parse(context.Request["Id"]);
            string starDate = context.Request["startDate"] == null ? "" : context.Request["startDate"];
            string endDate = context.Request["endDate"] == null ? "" : context.Request["endDate"];

            var list = _carInfoBll.GetCarKmMoney(pageIndex, pageSize, carid, starDate, endDate, out count);
            context.Response.Write(JsonConvert.SerializeObject(new { index = pageIndex, total = count, rows = list }));
        }
        #endregion

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}