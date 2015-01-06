using System;
using System.Collections.Generic;
using System.Transactions;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Model.Enume;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace WebApp.PCenter
{
    public partial class MyOrders : PageBase.PageBase
    {
        protected List<Model.Orders> OrderList = new List<Model.Orders>();
        protected List<Model.UserAccount> UserList = new List<Model.UserAccount>();
        protected int MaxCount = 0;
        protected int[] StatusCount = new int[10];
        protected RentCarBLL RCB = new RentCarBLL();
        protected CarUseWayBLL CUWB = new CarUseWayBLL();
        protected List<ChargeDescription> charges;
        protected void Page_Load(object sender, EventArgs e)
        {
            charges = new BLL.ChargeDescriptionBll().GetList("");
            BLL.OrderBLL OB = new OrderBLL();

            if (Request.Form["Action"] == "Cancel")
            {
                if (Request.Form["OrderId"] == null)//取消的订单号不存在
                {
                    Response.ContentType = "application/json";
                    Response.Write("{\"Message\":\"Error\"}");
                    Response.End();
                }

                Model.Orders ordersCancel = OB.GetModel(Request.Form["OrderId"]);//获取要取消的订单
                try
                {
                    string OrderIdStr = Request.Form["OrderId"];
                    bool Complete = false;
                    bool cancelNum = false;
                    DateTime dtCancel = DateTime.Now;
                    if (ordersCancel == null)
                    {
                        LogHelper.WriteOperation("查询订单号为[" + OrderIdStr + "]", OperationType.Query, "没有此订单号", Username);
                    }
                    else
                    {
                        int num = new BLL.PermissionBLL().gettodayErrorCount(ordersCancel.userID, 3);
                        if (num >= 5)
                        {
                            cancelNum = true;
                        } 
                        else
                        {
                            var carno = "";
                            var cartelphone = "";
                            var caruseid = "";
                            var carchannelid = "";
                            string usertelphone = "";
                            decimal refound = 0.00M;
                            int statusid = 0;
                            var carusewayid = 0;
                            var result = 0;
                            var openId = "";
                            new OrderBLL().CancelOrder(userAccount.Compname, userAccount.Id, ordersCancel.orderId, "", 1, out carno, out cartelphone, out caruseid, out carchannelid, out usertelphone, out refound, out statusid, out carusewayid, out result, out openId);
                            var orderid = ordersCancel.orderId;
                            if (result > 0)
                            {
                                Complete = true;
                                if (!string.IsNullOrEmpty(carno))
                                {
                                    if (openId != "")
                                    {
                                        var msg = carno + "，" + orderid + "号订单已取消。如有问题，请联系客服（0311-85119999）";
                                        var backmsg = Common.WXCommon.SendMessageToDriver(openId, "取消订单", msg);

                                        IEZU.Log.LogHelper.WriteOperation("取消订单微信消息,result:"+backmsg,OperationType.Query,"","");
                                    }
                                    var msgContent = new { contentType = 4, img = "", content = orderid + "号订单已取消。如有问题，请联系客服。", datetime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), username = "", orderid = orderid };

                                    Common.SMS.driver_OrderCancel(carno , orderid, cartelphone); //短信、客户端推送司机
                                    Common.BaiduPush.PushManager.PushMessage(Common.BaiduPush.Enums.DeviceType.Andriod, Common.BaiduPush.Enums.PushType.User, JsonConvert.SerializeObject(msgContent), caruseid, carchannelid, "");
                                    Common.BaiduPush.PushManager.PushNotification(Common.BaiduPush.Enums.DeviceType.Andriod, Common.BaiduPush.Enums.PushType.User, "订单取消通知", orderid + "号订单已取消。如有问题，请联系客服。", caruseid, carchannelid, "");
                                }
                                var usermodel = new BLL.UserAccountBLL().GetModel(usertelphone);
                                if (carusewayid != 7)
                                {
                                    switch (statusid)
                                    {
                                        case 1:
                                            //Common.SMS.MessageSender("", usertelphone, SMSTemp.NoPayOrderCancel);
                                            if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                                            {
                                                var re = WXCommon.CancelOrderWithMoney(usermodel.WeixinOpenId);
                                                IEZU.Log.LogHelper.WriteOperation("推送微信消息：取消订单", OperationType.Query,
                                                  re, "");
                                            }
                                            break;
                                        case 12:
                                        case 2:
                                        case 8:
                                            Common.SMS.user_OrderCancelNoPay( usertelphone);
                                            if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                                            {
                                                var re = WXCommon.CancelOrderWithMoney(usermodel.WeixinOpenId);
                                                IEZU.Log.LogHelper.WriteOperation("推送微信消息：取消订单", OperationType.Query,
                                                  re, "");
                                            }
                                            break;
                                        default:
                                            Common.SMS.user_OrderCancelAndPay(usertelphone);
                                            if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                                            {
                                                var re = WXCommon.CancelOrder(usermodel.WeixinOpenId, usermodel.Compname);
                                                IEZU.Log.LogHelper.WriteOperation("推送微信消息：取消订单", OperationType.Query,
                                                  re, "");
                                            }
                                            break;
                                    }
                                }
                                else
                                {
                                    switch (statusid)
                                    {
                                        case 1:
                                            Common.SMS.NoPayOrderCancel(usertelphone);
                                            break;
                                        case 8:
                                            Common.SMS.user_OrderCancelNoPay(usertelphone);
                                            if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                                            {
                                                var re = WXCommon.CancelOrderWithMoney(usermodel.WeixinOpenId);
                                                IEZU.Log.LogHelper.WriteOperation("推送微信消息：取消订单", OperationType.Query,
                                                  re, "");
                                            }
                                            break;
                                        default:
                                            Common.SMS.user_OrderCancelAndPay( usertelphone);
                                            if (usermodel != null && usermodel.WeixinOpenId != null && usermodel.WeixinOpenId != "")
                                            {
                                                var re = WXCommon.CancelOrder(usermodel.WeixinOpenId, usermodel.Compname);
                                                IEZU.Log.LogHelper.WriteOperation("推送微信消息：取消订单", OperationType.Query,
                                                  re, "");
                                            }
                                            break;
                                    }
                                }
                            }
                            else
                            {
                                Complete = false;
                            }
                        }
                    }
                    Response.ContentType = "application/json";
                    if (Complete)
                    {
                        Session["UserInfo"] = new BLL.UserAccountBLL().GetModel(userAccount.Id);
                        Response.Write("{\"Message\":\"Complete\"}");
                    }
                    else
                    {
                        if (cancelNum)
                        {
                            Response.Write("{\"Message\":\"取消次数超过5次，无法继续取消！\"}");
                        }
                        else
                        {
                            Response.Write("{\"Message\":\"取消失败！\"}");
                        }

                    }
                }
                catch (Exception exception)
                {
                    LogHelper.WriteException(exception);
                    Response.Write("{\"Message\":\"取消失败！\"}");
                }
                finally
                {
                    Response.End();
                }
            }

            BLL.UserAccountBLL UB = new UserAccountBLL();
            string UidArrayStr = UB.GetSubIdArrayStr(userAccount.Id);//获取用户标识的字符串
            string UidStr = "";
            if (Request.QueryString["UserId"] == null || Convert.ToInt32(Request.QueryString["UserId"]) == userAccount.Id)
                UidStr = UidArrayStr;
            else
            {
                UidStr = Request.QueryString["UserId"];
                if (UB.GetMaster(Convert.ToInt32(UidStr)).Id != userAccount.Id)
                    UidStr = UidArrayStr;
            }
            string[] OrderDate = new string[2];
            if (Request.QueryString["DateLL"] != null && Request.QueryString["DateUL"] != null)//判断时间格式是否正确
            {
                DateTime testDateTime = new DateTime();
                if (DateTime.TryParse(Request.QueryString["DateLL"], out testDateTime))
                    OrderDate[0] = Request.QueryString["DateLL"];
                if (DateTime.TryParse(Request.QueryString["DateUL"], out testDateTime))
                    OrderDate[1] = Request.QueryString["DateUL"];
            }
            UserList = UB.GetListById(UidArrayStr);//根据用户标识的字符串获取用户List
            for (int i = 0, max = StatusCount.Length; i < max; i++)//根据每个状态获取订单数量
            {
                StatusCount[i] = OB.GetCountByStatus(i, UidArrayStr, OrderDate);
            }
            OrderList = OB.GetList(UidStr, OrderDate, Common.Tool.GetInt(Request.QueryString["Status"]), 20, Common.Tool.GetInt(Request.QueryString["Previous"]), out MaxCount);

        }

        public string GetStatusName(string id)
        {

            try
            {
                return Enum.Parse(typeof(OrderStatus), id).ToString();
            }
            catch
            {
                return "状态未知";
            }



        }
    }
}