using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BLL;
using Newtonsoft.Json;
using IEZU.Log;
using Model.Ext;
using Model;
using System.Text;
using Common;
using System.Data;

namespace CarAppAdminWebUI.Order
{
    /// <summary>
    /// DownwindHandler 的摘要说明
    /// </summary>
    public class DownwindHandler : IHttpHandler
    {
        private readonly OrderBLL _orderBll = new OrderBLL();
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            var action = context.Request["action"];
            switch (action)
            {
                case "list":
                    GetDownwindOrderList(context);
                    break;
                case "addwindOrder":
                    AddDownwindOrder(context);
                    break;
                case "edit":
                    Edit(context);
                    break;
                case "setshowtime":
                    Setshowtime(context);
                    break;
                case "setdeduction":
                    Setpercent(context);
                    break;
                case "cancelorder":
                    Cancelorder(context);
                    break;
                case "settip":
                    Settip(context);
                    break;
            }
        }

        private void Settip(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string text =context.Request["tip"];
                var lotery = new BLL.ActivitiesBLL().GetLotterySetting(4);
                new BLL.ActivitiesBLL().UpdateLotterySetting(DateTime.Now, DateTime.Now, 0, text, 4);

                message.IsSuccess = true;
                message.Message = "修改成功";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Cancelorder(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                string orderid = context.Request["id"];
                var orderModel = _orderBll.GetModel(orderid);

                var winddt = _orderBll.GetPassengerList(orderid, "已付款", 0);
                if (winddt.Rows.Count > 0)
                {
                    message.IsSuccess = false;
                    message.Message = "有人下单，无法取消";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }

                var windt = _orderBll.GetPassengerList(orderid, "已取消", 0);


                decimal deductmoney = 0;
                foreach (DataRow row in windt.Rows)
                {
                    deductmoney += Convert.ToDecimal(row["deductmoney"]);
                }
                orderModel.orderStatusID = 5;
                orderModel.totalMoney = deductmoney;

                _orderBll.upDateAllByModule(orderModel);

                message.IsSuccess = true;
                message.Message = "取消成功";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Setpercent(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int money = Convert.ToInt32(context.Request["percent"]);
                var lotery = new BLL.ActivitiesBLL().GetLotterySetting(3);
                new BLL.ActivitiesBLL().UpdateLotterySetting(DateTime.Now, DateTime.Now, money, lotery.Rows[0]["buttontext"].ToString(), 3);

                message.IsSuccess = true;
                message.Message = "修改成功";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Setshowtime(HttpContext context)
        {
            var message = new AjaxResultMessage();
            try
            {
                int money = Convert.ToInt32(context.Request["time"]);
                var lotery = new BLL.ActivitiesBLL().GetLotterySetting(2);
                new BLL.ActivitiesBLL().UpdateLotterySetting(DateTime.Now, DateTime.Now, money, lotery.Rows[0]["buttontext"].ToString(), 2);

                message.IsSuccess = true;
                message.Message = "修改成功";

                context.Response.Write(JsonConvert.SerializeObject(message));
            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }

        private void Edit(HttpContext context)
        {
            var message = new AjaxResultMessage();
            string id = context.Request["id"];
            string startAddress = context.Request["startAddress"];
            string startAddressDetail = context.Request["placedetail"];
            string mapPoint = context.Request["startpoint"];
            string arriveAddress = context.Request["arriveAddress"];
            string arriveAddressDetail = context.Request["enddetail"];
            string endPoint = context.Request["endpoint"];
            string departureTimeString = context.Request["departureTime"];
            string passengerName = context.Request["passengerName"];
            string passengerPhone = context.Request["passengerPhone"];
            string orderStatusIDStr = context.Request["orderStatusID"];

            decimal windprice =Convert.ToDecimal(context.Request["amount"]);
            int passengernum = Convert.ToInt32(context.Request["Passengernum"]);
            int rentcarid = Convert.ToInt32(context.Request["rentcar"]);
            int orderStatusID;
            DateTime dateTime;
            if (departureTimeString == "0001/1/1 0:00:00")
            {
                message.IsSuccess = false;
                message.Message = "请输入一个有效的预约时间";
                context.Response.Write(JsonConvert.SerializeObject(message));
                return;
            }
            bool isSuccess = DateTime.TryParse(departureTimeString, out dateTime);
            if (!isSuccess)
            {
                message.IsSuccess = false;
                message.Message = "请输入一个有效的预约时间";
            }

            else
            {
                var model = _orderBll.GetModel(id);
                var winddt = new BLL.OrderBLL().GetPassengerList(model.orderId, "已付款", 0);
                var winddt2 = new BLL.OrderBLL().GetPassengerList(model.orderId, "已取消", 0);
                if (winddt.Rows.Count > 0||winddt2.Rows.Count>0)
                {
                    message.IsSuccess = false;
                    message.Message = "订单已经有人下单，无法更改信息";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                    return;
                }


                var sb = new StringBuilder();
                sb.Append("修改订单编号[" + id + "]");
                sb.Append(string.Format("；修改前的订单信息为    上车地址：{0}，下车地址：{1}，出发时间：{2}，乘车人：{3}，乘车人电话：{4}", model.startAddress, model.arriveAddress, model.departureTime, model.passengerName, model.passengerPhone));

                model.startAddress = startAddress;
                model.startAddressDetail = startAddressDetail;
                model.mapPoint = mapPoint;
                model.arriveAddress = arriveAddress + "，" + arriveAddressDetail;
                model.EndPosition = endPoint;
                model.departureTime = dateTime;
                model.pickupTime = dateTime;
                model.passengerName = passengerName ?? "";
                model.passengerPhone = passengerPhone ?? "";
                model.passengerNum = passengernum;
                model.WindPrice = windprice;
                model.rentCarID = rentcarid;
                sb.Append(string.Format("；修改后的订单信息为    上车地址：{0}，下车地址：{1}，出发时间：{2}，乘车人：{3}，乘车人电话：{4}", model.startAddress, model.arriveAddress, model.departureTime, model.passengerName, model.passengerPhone));


                try
                {

                    _orderBll.upDateAllByModule(model);
                    var ordertimes = new OrderTimesBLL();
                    var timeModel = ordertimes.GetModel(id);
                    timeModel.UserOrderedtime = dateTime.ToString("yyyy-MM-dd HH:mm:ss");
                    ordertimes.UpdateDate(timeModel);
                    LogHelper.WriteOperation(sb.ToString(), OperationType.Update, "编辑成功",
                        HttpContext.Current.User.Identity.Name);
                    message.IsSuccess = true;
                    message.Message = "";

                }
                catch (Exception exception)
                {
                    message.IsSuccess = false;
                    LogHelper.WriteException(exception);
                }

            }
            context.Response.Write(JsonConvert.SerializeObject(message));
        }

        private void AddDownwindOrder(HttpContext context)
        {
            string amount = context.Request["amount"];
            string Passengernum = context.Request["Passengernum"];
            string departureCityId = context.Request["countyId"];
            string DepartureTime = context.Request["DepartureTime"];
            string endCityId = context.Request["countyIde"];
            string rentcar = context.Request["rentcar"];
            string startAddress = context.Request["startAddress"];
            string startAddressDetail = context.Request["startAddressDetail"];
            string startpoint = context.Request["startpoint"];
            string endAddress = context.Request["endAddress"];
            string endAddressDetail = context.Request["endAddressDetail"];
            string endpoint = context.Request["endpoint"];
            string useraccount = context.Request["useraccount"];

            var message = new AjaxResultMessage();
            try
            {
                Orders model = new Orders();
                model.WindPrice = Convert.ToDecimal(amount);
                model.passengerNum = Int32.Parse(Passengernum);
                model.departureTime = Convert.ToDateTime(DepartureTime);
                model.departureCityID = departureCityId;
                model.rentCarID = Int32.Parse(rentcar);
                model.targetCityID = endCityId;
                model.startAddress = startAddress;
                model.startAddressDetail = startAddressDetail;
                model.mapPoint = startpoint;
                model.arriveAddress = endAddress;
                model.EndPosition = endpoint;
                model.userID = Int32.Parse(useraccount);
                model.orderId = Common.GenerateNo.GenerateUniqueOrderNo(5).Split('|')[0];
                string adminName = context.User.Identity.Name;

                int result = new OrderBLL().AddWindOrder(model, adminName);
                if (result != 0)
                {
                    message.IsSuccess = true;
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }
                else
                {
                    message.IsSuccess = false;
                    message.Message = "未知原因，请联系技术人员";
                    context.Response.Write(JsonConvert.SerializeObject(message));
                }

            }
            catch (Exception exp)
            {
                message.IsSuccess = false;
                message.Message = exp.Message;
                context.Response.Write(JsonConvert.SerializeObject(message));
            }
        }
        private void GetDownwindOrderList(HttpContext context)
        {
            int count = 0;
            var totamoney = 0.00M;
            int pageIndex = Convert.ToInt32(context.Request["page"] ?? "1");
            int pageSize = Convert.ToInt32(context.Request["rows"] ?? "15");

            string creatorname = context.Request["username"] ?? "";
            string sname = context.Request["sname"] ?? "";//passengername
            string usertel = context.Request["usertel"] ?? "";
            string passengertel = context.Request["passenagertel"] ?? "";
            string startcity = context.Request["startaddress"] ?? "";
            string targetcity = context.Request["targetaddress"] ?? "";
            string caruseway = "0";//顺风车
            string orderStatusId = string.IsNullOrEmpty(context.Request["orderStatusID"]) ? "0" : context.Request["orderStatusID"];
            string cartype = string.IsNullOrEmpty(context.Request["cartype"]) ? "0" : context.Request["cartype"];
            string orderid = context.Request["orderid"] ?? "";
            string starttime = context.Request["startdate"] ?? "";
            var endtime = context.Request["enddate"] ?? "";
            string carNo = context.Request["carNo"] ?? "";
            try
            {
                var list = _orderBll.GetWindPageList(starttime, endtime, creatorname, Int32.Parse(orderStatusId), Int32.Parse(cartype),
                                                     orderid, startcity, targetcity, carNo,
                                                      pageSize, pageIndex, out count);
                var dict = new List<object>();
                dict.Add(new { orderId = "订单总数：" + count });
                context.Response.Write(JsonConvert.SerializeObject(new
                {
                    index = pageIndex,
                    total = count,
                    rows = list,
                    footer = dict
                }));
            }
            catch (Exception ex)
            {
                LogHelper.WriteException(ex);
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