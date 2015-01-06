using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using BLL;
using Common;
using IEZU.Log;
using Model;
using Newtonsoft.Json;
using NPOI.HSSF.Util;
using NPOI.SS.Formula.Functions;
using Action = Model.Action;

namespace CarAppAdminWebUI.Ajax
{
    /// <summary>
    /// payfororder 的摘要说明
    /// </summary>
    public class payfororder : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            if (context.Request["ordernum"] == "1")
            {
                if (context.Request["orderid"] != null)
                {
                    var voucherid = context.Request["voucherid"];
                    var couponid = context.Request["couponid"];
                    try
                    {
                        var orderbll = new OrderBLL();
                        var orderModel = orderbll.GetModel(context.Request["orderid"]);
                        var couponModel = new Model.Coupon();
                        var voucherModel = new Vouchers();
                        decimal reducemoney = 0;
                        if (!string.IsNullOrEmpty(context.Request["couponid"]))
                        {
                            try
                            {
                                couponModel = BLL.Coupon.GetModel(int.Parse(context.Request["couponid"]));

                                if (couponModel.Status == 1 || couponModel.Startdate > DateTime.Now ||
                                    couponModel.Deadline < DateTime.Now || couponModel.userID != orderModel.userID ||
                                    orderModel.orderMoney < couponModel.Restrictions)
                                {
                                    context.Response.Write(
                                        JsonConvert.SerializeObject(new { resultcode = 0, msg = "优惠券信息异常" }));
                                    return;
                                }
                                reducemoney = couponModel.Cost;
                            }
                            catch
                            {
                                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "优惠券错误" }));
                                return;
                            }
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(voucherid))
                            {
                                try
                                {
                                    voucherModel = new VouchersBll().GetModel(int.Parse(voucherid));

                                    if (voucherModel.Status == "已使用" || voucherModel.StartTime > DateTime.Now ||
                                        voucherModel.EndTime < DateTime.Now || voucherModel.UserId != orderModel.userID)
                                    {
                                        context.Response.Write(
                                            JsonConvert.SerializeObject(new { resultcode = 0, msg = "代金券异常" }));
                                        return;
                                    }
                                    reducemoney = voucherModel.Cost;
                                }
                                catch
                                {
                                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "代金券异常" }));
                                    return;
                                }
                            }
                        }
                        if (orderModel == null)
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "订单信息错误" }));
                            return;
                        }
                        if (orderModel.orderStatusID != 1)
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "请勿重复支付订单" }));
                            return;
                        }
                        var userbll = new UserAccountBLL();
                        var userModel = userbll.GetModel(orderModel.userID);
                        if (userModel == null)
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "用户信息错误" }));
                            return;
                        }
                        var moneytoPay = 0.00M;
                        moneytoPay = orderModel.orderMoney < reducemoney
                            ? 0
                            : orderModel.orderMoney - reducemoney;
                        var userBalance = userModel.Balance - moneytoPay;
                        if (userBalance < 0)
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "账户余额不足，请充值" }));
                            return;
                        }
                        var model = (new AdminBll()).GetModel(context.User.Identity.Name);
                        var httpCookie = context.Request.Cookies["exten"];
                        if (httpCookie != null && model != null)
                        {
                            new CallCenterOrderBLL().InsertData(new CallCenterOrder()
                            {
                                Exten = httpCookie.Value,
                                GroupId = 0,
                                OrderDate = DateTime.Now,
                                OrderId = context.Request["orderid"],
                                UserName = context.User.Identity.Name,
                                UserId = model.AdminId
                            });
                        }
                        else
                        {
                            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "支付失败" }));
                            return;
                        }

                        var result = userbll.UpdateAccount(userModel.Id, moneytoPay, "reduce");
                        if (result > 0)
                        {
                            var accountBll = new AccountBLL();
                            var accountNo = accountBll.GetSerialNumber();
                            if (!string.IsNullOrEmpty(context.Request["couponid"]))
                            {
                                couponModel.Status = 1;
                                couponModel.OrderId = orderModel.orderId;
                                BLL.Coupon.Update(couponModel);
                            }
                            if (!string.IsNullOrEmpty(context.Request["voucherid"]))
                            {
                                voucherModel.Status = "已使用";
                                voucherModel.OrderId = orderModel.orderId;
                                voucherModel.UseTime = DateTime.Now;

                                new VouchersBll().UpdateState(int.Parse(voucherid), orderModel.orderId);
                            }
                            accountBll.InsertAccount(new Account()
                            {
                                Action = Common.Action.PAYORDER,
                                Money = moneytoPay,
                                Type = Common.PayType.Pay,
                                userID = Convert.ToInt32(orderModel.userID),
                                Balance = userBalance,
                                AccountNumber = accountNo,
                                OrderId = context.Request["orderid"]
                            });
                            orderbll.UpdateProperty(orderModel.orderId, moneytoPay, 8);
                            var ordertimesbll = new OrderTimesBLL();
                            var timeModel = ordertimesbll.GetModel(orderid: orderModel.orderId);
                            if (timeModel != null)
                            {
                                timeModel.PayTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                                ordertimesbll.UpdateDate(timeModel);
                            }
                            context.Response.Write(
                                JsonConvert.SerializeObject(
                                    new { resultcode = 1, msg = "支付成功", location = context.Request["querystring"] }));

                            int carusewayid = new RentCarBLL().GetModel(orderModel.rentCarID).carusewayID;
                            if (carusewayid != 7)
                            {
                                SMS.user_OrderConfirm(userModel.Telphone);
                            }
                            if (orderModel.SMSReceiver == 1)
                            {
                                if (orderModel.passengerPhone != userModel.Telphone)
                                {
                                    SMS.user_OrderConfirm(orderModel.passengerPhone);
                                }
                            }
                            return;
                        }
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "支付失败" }));
                    }
                    catch (Exception exception)
                    {
                        LogHelper.WriteException(exception);
                        context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "支付失败" }));
                    }
                }
                else
                {
                    context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "参数错误" }));
                }

            }
            else
            {
                MultiPayOrder(context);
            }

        }

        public void MultiPayOrder(HttpContext context)
        {
            var mutilbll = new MutilOrderBLL();
            var orderid = context.Request["orderid"];
            var data = mutilbll.GetMultiOrderList(orderid);
            var sb = new StringBuilder();
            for (int i = 0; i < data.Rows.Count; i++)
            {
                sb.Append(data.Rows[i]["orderid"]);
                sb.Append(",");
            }
            int result = 0;
            var cookie = context.Request.Cookies["exten"];
            var exten = "";
            exten = cookie == null ? "" : cookie.Value;

            mutilbll.UpdateOrderStatus(sb.ToString(), exten, context.User.Identity.Name, out result);
            if (result > 0)
            {
                context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 1, msg = "支付成功", location = context.Request["querystring"] }));
                return;
            }
            context.Response.Write(JsonConvert.SerializeObject(new { resultcode = 0, msg = "支付失败" }));
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