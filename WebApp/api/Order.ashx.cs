using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.InteropServices;
using System.Runtime.Remoting.Services;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using Common;
using DAL;
using BLL;
using System.Data;
using System.Data.SqlClient;
using IEZU.Log;
using Model;
using Model.InvoiceModel;
using Newtonsoft.Json;

namespace WebApp.api
{
    /// <summary>
    /// Order 的摘要说明
    /// </summary>
    public class Order : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            if (context.Request.Params["submitInfo"] != null)
            {
                if (context.Session["UserInfo"] == null)
                {
                    context.Response.Write("notlogined");
                    context.Response.End();
                    return;
                }
                var userThis = context.Session["UserInfo"] as UserAccount;

                int count = new BLL.PermissionBLL().gettodayErrorCount(userThis.Id, 3);
                if (count >= 5)
                {
                    context.Response.Write("permission");
                    context.Response.End();
                    return;
                }

                var orderid = context.Request.Form["orderId"].Trim();
                var orderModel = new BLL.OrderBLL().GetModel(orderid);

                new BLL.UserAddressBLL().AddAddressByOrder(orderModel);//增加常用地址

                var couponid = 0;
                decimal ordermoney = orderModel.orderMoney;
                var couponmodel = new Model.Coupon();

                if (context.Request.Form["couponId"] != "0")
                {
                    couponid = int.Parse(context.Request.Form["couponId"].Split('-')[0]);
                    couponmodel = BLL.Coupon.GetModel(couponid);
                    if (couponmodel != null)
                    {
                        if (!string.IsNullOrEmpty(couponmodel.OrderId))
                        {
                            context.Response.Write("inuse");
                            context.Response.End();
                            return;
                        }
                    }
                    var model = BLL.Coupon.GetByOrderId(orderid);
                    if (model != null)
                    {
                        context.Response.Write("inuse");
                        context.Response.End();
                        return;
                    }
                    var model2 = new BLL.VouchersBll().GetModel(orderid);
                    if (model2 != null)
                    {
                        context.Response.Write("vouuse2"); //订单已经使用代金券
                        context.Response.End();
                        return;
                    }
                    if (couponmodel != null && couponmodel.Cost >= orderModel.orderMoney)
                    {
                        ordermoney = 0;
                    }
                    else
                    {
                        if (couponmodel != null) ordermoney = orderModel.orderMoney - couponmodel.Cost;
                    }
                    (new BLL.Coupon()).UpdateStatus(orderid, couponid.ToString());
                }
                if (context.Request.Form["vouchersId"] != "0")
                {
                    if (couponid == 0)
                    {
                        var voucherBll = new BLL.VouchersBll();
                        int voucherId = Int32.Parse(context.Request.Form["vouchersId"].Split('-')[0]);
                        var voucher = voucherBll.GetModel(voucherId);
                        if (voucher.Status == "未使用")
                        {
                            var model = voucherBll.GetModel(orderid);
                            if (model != null)
                            {
                                context.Response.Write("vouuse2"); //订单已经使用代金券
                                context.Response.End();
                                return;
                            }
                            var model2 = BLL.Coupon.GetByOrderId(orderid);
                            if (model2 != null)
                            {
                                context.Response.Write("inuse");
                                context.Response.End();
                                return;
                            }

                            int result = voucherBll.UpdateState(voucherId, orderid);
                            if (result != 0)
                            {
                                if (voucher.Cost >= (decimal)orderModel.orderMoney)
                                {
                                    ordermoney = 0;
                                }
                                else
                                {
                                    ordermoney = orderModel.orderMoney - voucher.Cost;
                                }
                            }
                        }
                        else
                        {
                            context.Response.Write("vouuse"); //代金券已使用
                            context.Response.End();
                            return;
                        }

                    }
                }


                var rentdal = (new OrderBLL()).GetOrderById(orderid).Rows[0]["rentcarid"].ToString();
                var cartypeid = (new BLL.RentCarBLL()).GetModel(int.Parse(rentdal)).carTypeID;
                int cartUseWayId = (new BLL.RentCarBLL()).GetModel(int.Parse(rentdal)).carusewayID;

                DateTime userCarTime = new DateTime();
                if (cartUseWayId == 1)//接机
                    userCarTime = orderModel.pickupTime;
                else
                    userCarTime = orderModel.departureTime;

                if (!new BLL.UserAccountBLL().CanGetOrder(userThis.Id, cartypeid, ordermoney, userCarTime))
                {
                    context.Response.Write("noauth");
                    context.Response.End();
                    return;
                }
                if (context.Request.Form["isinvoice"] != null)
                {
                    //var title = context.Request.Form["invoiceHead"].ToString();
                    //var type = context.Request.Form["invoiceType"].ToString(CultureInfo.InvariantCulture);
                    //var address = context.Request.Form["address"];
                    //var zipcode = context.Request.Form["zipcode"];
                    //var invoiceclass = context.Request.Form["invoiceClass"];
                    //var TaxpayerID = context.Request.Form["TaxpayerID"];
                    //var CompAdd = context.Request.Form["CompAdd"];
                    //var CompTel = context.Request.Form["CompTel"];
                    //var CompBank = context.Request.Form["CompBank"];
                    //var CompAccount = context.Request.Form["CompAccount"];
                    //var id = new BLL.UserAccountBLL().GetMaster(userThis.Id).Id;
                    var invoice = new InvoiceBLL();
                    int myinvoiceid = 0;
                    if (context.Request.Form["isinvoice"] == "0")
                    {
                        //var invoiceid = invoice.InsertData(new Invoice
                        //{
                        //    InvoiceAdress = address,
                        //    InvoiceHead = title,
                        //    InvoiceZipCode = zipcode,
                        //    UserId = id,
                        //    invoiceClass = int.Parse(invoiceclass),
                        //    TaxpayerID = TaxpayerID,
                        //    CompAdd = CompAdd,
                        //    CompTel = CompTel,
                        //    CompBank = CompBank,
                        //    CompAccount = CompAccount,
                        //    InvoiceType = int.Parse(type)
                        //});
                        var invoiceid = 0;
                        if (context.Request["invoice"] != null)
                        {
                            InvoiceBase personinvoice;
                            if (context.Request["invoice"] == "0")
                            {
                                personinvoice = new PersonalInvoice()
                                {
                                    Name = context.Request["username"].ToString(),
                                    Address = context.Request["address"].ToString(),
                                    CardNo = context.Request["ssn"].ToString(),
                                    PostCode = context.Request["zipcode"].ToString(),
                                    UserId = userThis.Id 
                                }; 
                                invoiceid = invoice.InsertInvoice(TaxType.普通发票, TaxPayerType.个人, personinvoice);
                            }
                            else if(context.Request["invoice"] == "1")
                            {
                                personinvoice=new PlainInvoice()
                                {
                                    InvoiceClass = context.Request["invoiceClass"].ToString(),
                                    Address = context.Request["address"].ToString(),
                                    PostCode = context.Request["zipcode"].ToString(),
                                    UserId = userThis.Id,
                                    InvoiceContent = context.Request["invoicetype"],
                                    Title = context.Request["invoiceHead"].ToString(),
                                    TaxSeriesNo = context.Request["TaxpayerID"]
                                };
                                invoiceid = invoice.InsertInvoice(TaxType.普通发票, TaxPayerType.单位, personinvoice);
                            }
                            else if (context.Request["invoice"] == "2")
                            {
                                personinvoice = new   ValueAddedInvoice()
                                {
                                    InvoiceClass = context.Request["invoiceClass"].ToString(),
                                    Address = context.Request["address"].ToString(),
                                    PostCode = context.Request["zipcode"].ToString(),
                                    UserId = userThis.Id,
                                    InvoiceContent = context.Request["invoicetype"],
                                    Title = context.Request["invoiceHead"].ToString(),
                                    TaxSeriesNo = context.Request["TaxpayerID"],
                                    AccountBank = context.Request["CompBank"],
                                    CompanyAccount = context.Request["CompAccount"],
                                    CompanyAddress = context.Request["compadd"],
                                    Telphone = context.Request["comptel"],
                                    AgentCard = context.Request["agentid"],
                                    BankAccountPermission = context.Request["bankpermission"],
                                    BusinessLicence = context.Request["licence"],
                                    CommonTaxPayLicence = context.Request["commontaxpayer"],
                                    OrgCodeLicence = context.Request["orglicense"],
                                    LegalPersonCard = context.Request["lawerid"],
                                    TaxPayLicence = context.Request["taxlicense"],
                                    InstrduceEnvelope = context.Request["introductmsg"],
                                    InvoiceResource = context.Request["resource"]
                                };
                                invoiceid = invoice.InsertInvoice(TaxType.增值税发票, TaxPayerType.单位, personinvoice);
                            }
                            else
                            {
                                personinvoice = new PersonalInvoice();
                            }
                           
                        }
                        myinvoiceid = invoiceid;
                        int reult = (new InvoiceBLL()).UpdateInvoice(orderid, invoiceid.ToString());
                    }
                    else
                    {
                        int reult = (new InvoiceBLL()).UpdateInvoice(orderid, context.Request.Form["invoiceid"]);
                        myinvoiceid = Int32.Parse(context.Request.Form["invoiceid"]);
                    }

                    int result = new BLL.OrderInvoiceBll().AddByInvoice(orderid, myinvoiceid);//根据invoice的id来添加一条orderInvoice

                }
                var userid = ((UserAccount)(context.Session["UserInfo"])).Id;
                (new OrderBLL()).UpdateMoney(orderid, ordermoney.ToString());
                context.Response.Write("success");
                context.Response.End();
            }
            if (context.Request.Params["IsUseBalance"] != null)
            {
                if (context.Session["userinfo"] == null)
                    context.Response.Redirect("/Login.aspx");
                string IsUseBalance = context.Request.Params["IsUseBalance"].ToString();
                int addM = Convert.ToInt32(context.Request.Params["addM"]);
                string orderId = context.Request.Params["orderID"].ToString();
                int orderMoney = Convert.ToInt32(new OrderBLL().GetOrderById(orderId).Rows[0]["orderMoney"]);
                switch (IsUseBalance)
                {
                    case "NotUse":
                        {
                            if (addM >= orderMoney)
                            {
                                context.Response.Write("mok");
                                context.Response.End();
                            }
                            else
                            {
                                context.Response.Write("mnot");
                                context.Response.End();
                            }
                            break;
                        }
                    case "Use":
                        {
                            int balance = Convert.ToInt32(new UserAccountBLL().GetUserInfo(Convert.ToInt32(context.Session["userid"])).Rows[0]["balance"]);
                            if ((balance + addM) >= orderMoney)
                            {
                                context.Response.Write("mok");
                                context.Response.End();
                            }
                            else
                            {
                                context.Response.Write("mnot");
                                context.Response.End();
                            }
                            break;
                        }
                }
            }
            //获取所有的机场信息
            if (context.Request.Params["getAirPort"] != null)
            {
                int rentID = Convert.ToInt32(context.Request.Params["rent"]);
                string cityID = new RentCarBLL().GetCarInfoById(rentID).Rows[0]["cityID"].ToString();
                List<AirPort> objList = new AirportBLL().GetAirPort(cityID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string list = jss.Serialize(objList);
                context.Response.Write(list);
            }
            if (context.Request.Params["type"] != null)
            {
                int rentCarID = Convert.ToInt32(context.Request.Params["pro"]);
                string cityID = new RentCarBLL().GetCarInfoById(rentCarID).Rows[0]["cityID"].ToString();
                List<province_cityExt> list = new province_cityBLL().GetCityInfoById(cityID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string objList = jss.Serialize(list);
                context.Response.Write(objList);
            }
            if (context.Request.Params["getHotPro"] != null)
            {
                int rentCarID = Convert.ToInt32(context.Request.Params["car"]);
                DataTable dt = new RentCarBLL().GetCarInfoById(rentCarID);
                string cityID = dt.Rows[0]["cityID"].ToString();
                if (dt.Rows[0]["hotLineID"].ToString() == "")
                    return;
                int hotLineID = Convert.ToInt32(dt.Rows[0]["hotLineID"]);
                List<hotLineExt> list = new HotLineBLL().GetHotById(hotLineID);
                JavaScriptSerializer jss = new JavaScriptSerializer();
                string objList = jss.Serialize(list);
                context.Response.Write(objList);
            }
            if (context.Request.Params["rentWay"] != null)
            {
                if (context.Session["UserInfo"] == null)
                {
                    context.Response.Write("notlogined");
                    context.Response.End();
                    return;
                }
                string way = context.Request.Params["rentWay"].ToString();
                switch (way)
                {

                    case "1"://接机
                        {
                            int rentCarInfo = Convert.ToInt32(context.Request.Params["rentCarInfo"]);
                            string startAddr = context.Request.Params["startAddr"].ToString();
                            //int select_portName = Convert.ToInt32(context.Request.Params["select_portName"]);

                            DateTime airTime = DateTime.Parse(context.Request.Params["flightDate"]);

                            string select_city = context.Request.Params["select_city"].ToString();
                            string arriveAddr = context.Request.Params["arrivalAddr"].ToString();
                            string passengerName = context.Request.Params["passengerName"].Trim();
                            string passengerPhone = context.Request.Params["passengerPhone"].ToString();
                            int passengerNum = Convert.ToInt32(context.Request.Params["passengerNum"]);
                            string BZ = context.Request.Params["BZ"].ToString();
                            DataTable dt = new RentCarBLL().GetCarInfoById(rentCarInfo);
                            Orders objOrders = new Orders();
                            objOrders.passengerName = passengerName;
                            objOrders.passengerPhone = passengerPhone;
                            objOrders.passengerNum = passengerNum;
                            objOrders.remarks = BZ;
                            objOrders.userID = ((UserAccount)(context.Session["UserInfo"])).Id;
                            objOrders.extraFee = 0;
                            objOrders.orderMoney = decimal.Parse(dt.Rows[0]["discountprice"].ToString()) + objOrders.extraFee;//订单总额
                            objOrders.departureCityID = dt.Rows[0]["countyid"].ToString();
                            objOrders.flightNo = context.Request["flightNumber"];
                            objOrders.OrderStatus = (OrderStatus)Enum.Parse(typeof(OrderStatus), "1");
                            objOrders.targetCityID = select_city;
                            objOrders.arriveAddress = arriveAddr;
                            objOrders.startAddress = startAddr;
                            objOrders.airportID = int.Parse(context.Request.Form["airportId"]);
                            Model.AirPort airport = new BLL.AirportBLL().GetModel(objOrders.airportID);
                            objOrders.mapPoint = airport.Lng + "," + airport.Lat;
                            objOrders.EndPosition = context.Request.Form["endPosition"];
                            objOrders.pickupTime = airTime;
                            objOrders.departureTime = airTime;
                            objOrders.rentCarID = rentCarInfo;
                            objOrders.orderDate = DateTime.Now;
                            objOrders.SMSReceiver = int.Parse(context.Request.Form["isSmsPassenger"].ToString());

                            objOrders.OrderOrigin = "电脑网站";

                            string orderId = new OrderBLL().SubmitOrders(objOrders, 2);
                            var countyid = dt.Rows[0]["countyid"].ToString();
                            var type = (new CityBLL()).GetCityType(countyid);

                            if (!IsTimePass(airTime, int.Parse(type)))
                            {
                                context.Response.Write("time");
                                context.Response.End();
                                return;
                            }
                            if (orderId != "")
                            {
                                try
                                {
                                    var ordertimebll = new OrderTimesBLL();
                                    var timeModel = new OrderTimes
                                    {
                                        UserOrderedtime = objOrders.departureTime.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderDate = objOrders.orderDate.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderedStartAddr = objOrders.startAddress,
                                        OrderedEndAddr = objOrders.arriveAddress,
                                        OrderId = orderId
                                    };
                                    ordertimebll.InsertData(timeModel);
                                }
                                catch (Exception exception)
                                {
                                    LogHelper.WriteException(exception);
                                }

                                context.Response.Write(orderId);
                                context.Response.End();
                            }
                            else
                            {
                                context.Response.Write("failed");
                                context.Response.End();
                            }
                            break;
                        }

                    case "2"://送机
                        {
                            int rentCarInfo = Convert.ToInt32(context.Request.Params["rentCarInfo"]);
                            string startAddr = context.Request.Params["startAddr"].ToString();
                            int select_portName = Convert.ToInt32(context.Request.Params["select_portName"]);
                            DateTime airTime = DateTime.Parse(context.Request.Params["airTime"]);
                            //string select_province = context.Request.Params["select_province"].ToString();
                            string select_city = context.Request.Params["select_city"].ToString();
                            string arriveAddr = context.Request.Params["arriveAddr"].ToString();
                            string passengerName = context.Request.Params["passengerName"].Trim();
                            string passengerPhone = context.Request.Params["passengerPhone"].ToString();
                            int passengerNum = Convert.ToInt32(context.Request.Params["passengerNum"]);
                            string BZ = context.Request.Params["BZ"].ToString();
                            string detailpalce = context.Request["addressDetail"].ToString();


                            DataTable dt = new RentCarBLL().GetCarInfoById(rentCarInfo);
                            Orders objOrders = new Orders();
                            objOrders.passengerName = passengerName;
                            objOrders.passengerPhone = passengerPhone;
                            objOrders.passengerNum = passengerNum;
                            objOrders.remarks = BZ;
                            objOrders.userID = ((UserAccount)(context.Session["UserInfo"])).Id;
                            objOrders.extraFee = 0;
                            objOrders.orderMoney = decimal.Parse(dt.Rows[0]["discountprice"].ToString()) + objOrders.extraFee;//订单总额
                            objOrders.departureCityID = dt.Rows[0]["countyid"].ToString();
                            objOrders.OrderStatus = OrderStatus.等待确认;
                            objOrders.targetCityID = select_city;
                            objOrders.arriveAddress = arriveAddr;
                            objOrders.startAddress = startAddr;
                            objOrders.airportID = select_portName;
                            Model.AirPort airport = new BLL.AirportBLL().GetModel(objOrders.airportID);
                            objOrders.EndPosition = airport.Lng + "," + airport.Lat;
                            objOrders.departureTime = airTime;
                            objOrders.rentCarID = rentCarInfo;
                            objOrders.departureTime = airTime;
                            objOrders.orderDate = DateTime.Now;
                            objOrders.SMSReceiver = int.Parse(context.Request.Form["isSmsPassenger"].ToString());
                            objOrders.mapPoint = context.Request.Form["position"];
                            objOrders.startAddressDetail = detailpalce;
                            objOrders.OrderOrigin = "电脑网站";
                            string orderId = new OrderBLL().SubmitOrders(objOrders, 3);
                            var countyid = dt.Rows[0]["countyid"].ToString();
                            var type = (new CityBLL()).GetCityType(countyid);
                            if (!IsTimePass(airTime, int.Parse(type)))
                            {
                                context.Response.Write("time");
                                context.Response.End();
                                return;
                            }
                            if (orderId != "")
                            {
                                try
                                {
                                    var ordertimebll = new OrderTimesBLL();
                                    var timeModel = new OrderTimes
                                    {
                                        UserOrderedtime = objOrders.departureTime.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderDate = objOrders.orderDate.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderedStartAddr = objOrders.startAddress,
                                        OrderedEndAddr = objOrders.arriveAddress,
                                        OrderId = orderId
                                    };
                                    ordertimebll.InsertData(timeModel);
                                }
                                catch (Exception exception)
                                {
                                    LogHelper.WriteException(exception);
                                }

                                context.Response.Write(orderId);
                            }
                            else
                            {
                                context.Response.Write("failed");
                            }

                            context.Response.End();
                            //new BLL.UserAddressBLL().AddAddressByOrder(objOrders);//增加常用地址
                            break;
                        }
                    case "3":
                    case "4":
                    case "5":
                        {
                            int rentCarInfo = Convert.ToInt32(context.Request.Params["rentCarInfo"]);
                            string rentAddr = context.Request.Params["rentAddr"].ToString();
                            DateTime rentTime = DateTime.Parse(context.Request.Params["rentTime"].ToString());
                            int useHour = Convert.ToInt32(context.Request.Params["useHour"]);
                            string province = context.Request.Params["province"].ToString();
                            string city = context.Request.Params["city"].ToString();
                            string rentArrive = context.Request.Params["rentArrive"].ToString();
                            string passengerName = context.Request.Params["passengerName"].Trim();
                            string passengerPhone = context.Request.Params["passengerPhone"].ToString();
                            int passengerNum = Convert.ToInt32(context.Request.Params["passengerNum"]);
                            string BZ = context.Request.Params["BZ"].ToString();
                            DataTable dt = new RentCarBLL().GetCarInfoById(rentCarInfo);
                            Orders objOrders = new Orders();
                            objOrders.passengerName = passengerName;
                            objOrders.passengerPhone = passengerPhone;
                            objOrders.passengerNum = passengerNum;
                            objOrders.remarks = BZ;
                            objOrders.userID = ((UserAccount)(context.Session["UserInfo"])).Id;
                            objOrders.extraFee = 0;
                            objOrders.orderMoney = decimal.Parse(dt.Rows[0]["discountprice"].ToString()) + objOrders.extraFee;//订单总额
                            objOrders.departureCityID = dt.Rows[0]["countyid"].ToString();
                            objOrders.OrderStatus = (OrderStatus)Enum.Parse(typeof(OrderStatus), "1");
                            objOrders.startAddress = rentAddr;
                            objOrders.arriveAddress = rentArrive;
                            objOrders.departureTime = Convert.ToDateTime(rentTime);
                            objOrders.useHour = useHour;
                            objOrders.targetCityID = city;
                            objOrders.rentCarID = rentCarInfo;
                            objOrders.departureTime = rentTime;
                            objOrders.mapPoint = context.Request["position"];
                            objOrders.SMSReceiver = int.Parse(context.Request.Form["isSmsPassenger"].ToString());
                            objOrders.startAddressDetail = context.Request["addressDetail"];
                            objOrders.orderDate = DateTime.Now;
                            objOrders.EndPosition = context.Request.Form["endPosition"];
                            objOrders.OrderOrigin = "电脑网站";
                            var countyid = dt.Rows[0]["countyid"].ToString();
                            var type = (new CityBLL()).GetCityType(countyid);
                            if (!IsTimePass(rentTime, int.Parse(type)))
                            {
                                context.Response.Write("time");
                                context.Response.End();
                                return;
                            }

                            string orderid = new OrderBLL().SubmitOrders(objOrders, 4);
                            if (orderid != "")
                            {
                                var ordertimebll = new OrderTimesBLL();
                                try
                                {
                                    var timeModel = new OrderTimes
                                    {
                                        UserOrderedtime = objOrders.departureTime.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderDate = objOrders.orderDate.ToString("yyyy-MM-dd HH:mm:ss"),
                                        OrderedStartAddr = objOrders.startAddress,
                                        OrderedEndAddr = objOrders.arriveAddress,
                                        OrderId = orderid
                                    };
                                    ordertimebll.InsertData(timeModel);
                                }
                                catch (Exception exception)
                                {
                                    LogHelper.WriteException(exception);
                                }

                                context.Response.Write(orderid);
                            }
                            else
                            {
                                context.Response.Write("failed");
                            }
                            context.Response.End();
                            //new BLL.UserAddressBLL().AddAddressByOrder(objOrders);//增加常用地址
                            break;
                        }
                    case "6":
                        {
                            int rentCarInfo = Convert.ToInt32(context.Request.Params["rentCarInfo"]);
                            string passengerName = context.Request.Params["passengerName"].Trim();
                            string passengerPhone = context.Request.Params["passengerPhone"].ToString();
                            int passengerNum = Convert.ToInt32(context.Request.Params["passengerNum"]);
                            DateTime hotTime = Convert.ToDateTime(context.Request.Params["hotTime"]);
                            string BZ = context.Request.Params["BZ"].ToString();
                            string hotStart = context.Request.Params["hotStart"].ToString();
                            string hotAddr = context.Request.Params["hotAddr"].ToString();
                            DataTable dt = new RentCarBLL().GetCarInfoById(rentCarInfo);
                            Orders objOrders = new Orders();
                            objOrders.userID = ((UserAccount)(context.Session["UserInfo"])).Id;
                            objOrders.extraFee = 0;
                            objOrders.orderMoney = decimal.Parse(dt.Rows[0]["discountprice"].ToString()) + objOrders.extraFee;//订单总额
                            objOrders.departureCityID = dt.Rows[0]["countyid"].ToString();
                            objOrders.OrderStatus = (OrderStatus)Enum.Parse(typeof(OrderStatus), "1");
                            objOrders.passengerName = passengerName;
                            objOrders.passengerPhone = passengerPhone;
                            objOrders.passengerNum = passengerNum;
                            objOrders.SMSReceiver = int.Parse(context.Request.Form["isSmsPassenger"].ToString());
                            objOrders.remarks = BZ;
                            objOrders.startAddress = hotStart;
                            objOrders.targetCityID = (new RentCarBLL()).GetModel(rentCarInfo).hotLineID.ToString();
                            objOrders.arriveAddress = hotAddr;
                            objOrders.departureTime = hotTime;
                            objOrders.rentCarID = rentCarInfo;
                            objOrders.pickupTime = hotTime;
                            objOrders.mapPoint = context.Request["position"];
                            objOrders.startAddressDetail = context.Request["addressDetail"];
                            objOrders.TicketNum = int.Parse(context.Request["ticketnum"]);
                            objOrders.orderDate = DateTime.Now;
                            objOrders.EndPosition = context.Request.Form["endPosition"];
                            objOrders.OrderOrigin = "电脑网站";
                            var countyid = dt.Rows[0]["countyid"].ToString();
                            var type = (new CityBLL()).GetCityType(countyid);
                            if (!IsTimePass(hotTime, int.Parse(type)))
                            {
                                context.Response.Write("time");
                                context.Response.End();
                                return;
                            }
                            string orderId = new OrderBLL().SubmitOrders(objOrders, 6);
                            if (orderId != "")
                            {
                                if (orderId != "")
                                {
                                    try
                                    {
                                        var ordertimebll = new OrderTimesBLL();
                                        var timeModel = new OrderTimes
                                        {
                                            UserOrderedtime = objOrders.departureTime.ToString("yyyy-MM-dd HH:mm:ss"),
                                            OrderDate = objOrders.orderDate.ToString("yyyy-MM-dd HH:mm:ss"),
                                            OrderedStartAddr = objOrders.startAddress,
                                            OrderedEndAddr = objOrders.arriveAddress,
                                            OrderId = orderId
                                        };
                                        ordertimebll.InsertData(timeModel);
                                    }
                                    catch (Exception exception)
                                    {
                                        LogHelper.WriteException(exception);
                                    }

                                    context.Response.Write(orderId);
                                }
                                else
                                {
                                    context.Response.Write("failed");
                                }
                            }

                            else
                            {
                                context.Response.Write("failed");
                            }

                            context.Response.End();
                            //new BLL.UserAddressBLL().AddAddressByOrder(objOrders);//增加常用地址
                            break;
                        }
                }

            }
        }
        public void Routing(string action, HttpContext context)
        {
            switch (action)
            {
                case "add": break;
                default:
                    break;
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        public bool IsTimePass(DateTime dt, int type)
        {
            var limit = 0;
            if (type == 2)
            {
                limit = 70;
            }
            else if (type == 3)
            {
                limit = 130;
            }
            if (dt < DateTime.Now)
            {
                return false;
            }
            if (dt.Day == DateTime.Now.Day)
            {
                var timespan = (dt - DateTime.Now);
                if (timespan.TotalMinutes < limit)
                {
                    return false;
                }
            }
            else if (dt < DateTime.Now)
            {
                return false;
            }
            return true;
        }

    }
}