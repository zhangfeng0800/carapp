using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using BLL;
using DBUtility;
using Model;
using Common;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace WebApp.twicepay
{
    public partial class YeepayCallBack : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 处理部分
                if (Request.Form["data"] == null || Request.Form["encryptkey"] == null)
                {
                    Response.Redirect("/twicepay/error.aspx");
                    return;
                }
                string data = Request.Form["data"].ToString();
                string encryptkey = Request.Form["encryptkey"].ToString();
                string payresult_view = YJPayUtil.checkYbCallbackResult(data, encryptkey);
                string orderid = "";
                string amount = "";
                string status = "";

                JObject obj = JObject.Parse(payresult_view);
                status = obj.GetValue("status").ToString();
                if (status == "0")
                {
                    Response.Write("支付失败");
                    Response.End();
                    return;
                }

                orderid = obj.GetValue("orderid").ToString().Split('x')[0];
                amount = obj.GetValue("amount").ToString();


                DataTable dt = new OrderBLL().GetOrderById(orderid);
                DataTable userAccount = new UserAccountBLL().GetDataTable(Convert.ToInt32(dt.Rows[0]["userID"]));
                if (Convert.ToInt32(dt.Rows[0]["orderStatusID"]) == 6 && Convert.ToInt32(dt.Rows[0]["paystatus"]) == 1)
                {
                    payStatus.InnerText = "已付款";
                    totalFee.InnerText = dt.Rows[0]["totalMoney"].ToString() + "元";
                    member.InnerText = userAccount.Rows[0]["username"].ToString() + "（" + userAccount.Rows[0]["telphone"].ToString() + "）";
                    passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                    return;
                }
                else
                {
                    UserAccount objUser;
                    Account objAccount = new Account();
                    objUser = new UserAccountBLL().GetMaster(Convert.ToInt32(dt.Rows[0]["userID"]));
                    CarInfo car = new BLL.CarInfoBLL().GetModel(dt.Rows[0]["carId"].ToString());
                    int p = new UserAccountBLL().UpdateAccount(objUser.Id, (decimal.Parse(amount)) / 100, "add");
                    if (p != 0)
                    {
                        objAccount.Action = Common.Action.BANKUNION;
                        objAccount.Money = (decimal.Parse(amount)) / 100;
                        objAccount.Type = PayType.Income;
                        objAccount.userID = Convert.ToInt32(dt.Rows[0]["userID"]);
                        objAccount.Balance = objUser.Balance + (decimal.Parse(amount)) / 100;
                        objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                        new AccountBLL().InsertAccount(objAccount);
                    }
                    new UserAccountBLL().UpdateAccount(objUser.Id, decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()), "reduce");
                    objAccount.Action = Common.Action.PAYORDER;
                    objAccount.Money = decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                    objAccount.Type = Common.PayType.Pay;
                    objAccount.userID = Convert.ToInt32(dt.Rows[0]["userID"]);
                    objAccount.Balance = objUser.Balance + (decimal.Parse(amount)) / 100 - decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString());
                    objAccount.AccountNumber = new AccountBLL().GetSerialNumber();
                    objAccount.OrderId = orderid;
                    new AccountBLL().InsertAccount(objAccount);
                    new OrderBLL().UpdateOrderInfo(6, orderid, DateTime.Now.ToLocalTime());
                    payStatus.InnerText = "已付款";
                    totalFee.InnerText = dt.Rows[0]["totalMoney"].ToString() + "元";
                    member.InnerText = userAccount.Rows[0]["username"].ToString() + "（" + userAccount.Rows[0]["telphone"].ToString() + "）";
                    passenger.InnerText = dt.Rows[0]["passengerName"].ToString() + "（" + dt.Rows[0]["passengerPhone"].ToString() + "）";
                    Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), userAccount.Rows[0]["telphone"].ToString());//给下单人发短信
                    Common.SMS.driver_OrderComplete(car.telPhone , orderid, car.telPhone);//给司机发短信
                    if (dt.Rows[0]["SMSReceiver"].ToString() == "1" && userAccount.Rows[0]["telphone"].ToString() != dt.Rows[0]["passengerPhone"].ToString())
                    {
                        Common.SMS.user_SecondPaid(Math.Round(float.Parse(dt.Rows[0]["unpaidMoney"].ToString()), 2).ToString(), dt.Rows[0]["passengerPhone"].ToString());//给乘车人发的
                    }
                    new BLL.DirverAccountBLL().PustMessageToDriver(car.Id, orderid + "号订单已成功完成。");
                    new RestrictBLL().addRestrict(Convert.ToInt32(dt.Rows[0]["userID"]), decimal.Parse(dt.Rows[0]["unpaidMoney"].ToString()));
                    new UserAccountBLL().AddScore(Common.DataTableToList.List<Model.Orders>(dt).FirstOrDefault());
                }

                
                #endregion
            }
            catch (Exception ex)
            {
                IEZU.Log.LogHelper.WriteException(ex);
            }
        }
    }
}